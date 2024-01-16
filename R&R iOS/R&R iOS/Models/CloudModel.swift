//
//  CloudModel.swift
//  R&R iOS
//
//  Created by Phillip Johnson on 1/2/24.
//

import Foundation
import CloudKit

// Aggregate Model
@MainActor
class CloudModel: ObservableObject {
    
    private var database = CKContainer.default().privateCloudDatabase
    @Published var albumDictionary: [CKRecord.ID: AlbumItem] = [:]
    @Published var weekRecommendations: [CKRecord.ID] = []
    @Published var randomAlbum: AlbumItem?

    var albums: [AlbumItem] {
        let unsortedAlbums = albumDictionary.values.compactMap{ $0 }
        return unsortedAlbums.sorted { $0.listens > $1.listens }  // Most listens at the beginning
    }
    
    func addAlbum(albumItem: AlbumItem) async throws {
        print(albumDictionary)
        
        let record = try await database.save(albumItem.record)
        guard let album = AlbumItem(record: record) else { return }
        albumDictionary[album.recordId!] = album
        print(albumDictionary)
    }
    
    func updateAlbum(editedAlbumItem: AlbumItem) async throws {
        
        albumDictionary[editedAlbumItem.recordId!]? = editedAlbumItem
        
        do {
            let record = try await database.record(for: editedAlbumItem.recordId!)
            record[AlbumRecordKeys.name.rawValue] = editedAlbumItem.name
            record[AlbumRecordKeys.artist.rawValue] = editedAlbumItem.artist
            record[AlbumRecordKeys.genre.rawValue] = editedAlbumItem.genre
            record[AlbumRecordKeys.lastListened.rawValue] = editedAlbumItem.lastListened
            record[AlbumRecordKeys.listens.rawValue] = editedAlbumItem.listens
            try await loadRecommendations()
            try await database.save(record)
            //sortAlbumItems()
        } catch {
            albumDictionary[editedAlbumItem.recordId!] = editedAlbumItem
        }
    }
    
    func deleteAlbum(albumItemToBeDeleted: AlbumItem) async throws {
        albumDictionary.removeValue(forKey: albumItemToBeDeleted.recordId!)
        do {
            let _ = try await database.deleteRecord(withID: albumItemToBeDeleted.recordId!)
        } catch {
            albumDictionary[albumItemToBeDeleted.recordId!] = albumItemToBeDeleted
            print(error)
        }
        
    }
    
    func populateAlbums() async throws {
        let query = CKQuery(recordType: AlbumRecordKeys.type.rawValue, predicate: NSPredicate(value: true))
        query.sortDescriptors = [NSSortDescriptor(key: "listens", ascending: false)]
        let result = try await database.records(matching: query)
        let records = result.matchResults.compactMap { try? $0.1.get()  }
        
        records.forEach {record in
            albumDictionary[record.recordID] = AlbumItem(record: record)
        }
        Task {
                do {
                    try await loadRecommendations()
                    randomRecommendation()
                } catch {
                    print("Failed to load recommendations: \(error)")
                }
            }
    }
    
    func filterAlbumItems(by filterOptions: FilterOptions) -> [AlbumItem] {
        switch filterOptions {
        case .all:
            return albums
        case .listened:
            return albums.filter { $0.listens > 0 }
        case .unlistened:
            return albums.filter { $0.listens == 0 }
        }
    }
    
    func sortAlbumItems(by sortOption: SortOptions, items: [AlbumItem]) -> [AlbumItem] {
        switch sortOption {
        case .name:
            return items.sorted { $0.name.lowercased() < $1.name.lowercased() }
        case .artist:
            // If your artist property is a string
            return items.sorted { $0.artist.lowercased() < $1.artist.lowercased() }
        case .listens:
            // If your listens property is a number
            return items.sorted { $0.listens > $1.listens }
        case .date:
            // If your dateLastListened property is a Date
            return items.sorted { $0.lastListened > $1.lastListened }
        }
    }
    
    func randomRecommendation() {
        let albumsArray = Array(albumDictionary.keys)
        guard !albumsArray.isEmpty else { return }
        let randomIndex = Int.random(in: 0..<albumsArray.count)
        let randomAlbumID = albumsArray[randomIndex]
        // Set the randomAlbum variable to the corresponding AlbumItem
        randomAlbum = albumDictionary[randomAlbumID]
    }
    
    func weeklyRecommendations() {
        let unsortedAlbums = albumDictionary.values.compactMap{ $0 }
        
        // split albums into two lists based on whether they have been listened to or not
        var unlistenedAlbums = unsortedAlbums.filter { $0.listens == 0 }.sorted { $0.lastListened < $1.lastListened }
        var longTimeNotListenedAlbums = unsortedAlbums.filter { $0.listens > 0 }.sorted { $0.lastListened < $1.lastListened }
        var mostListenedAlbums = unsortedAlbums.sorted { $0.listens > $1.listens }
        
        // how many of each category we want to include in the recommendations
        let numUnlistened = min(3, unlistenedAlbums.count)
        let numLongTimeNotListened = min(7 - numUnlistened, longTimeNotListenedAlbums.count)
        let numMostListened = 7 - numUnlistened - numLongTimeNotListened
        
        // draw the recommendations at random from each of the lists
        var recommendations: [CKRecord.ID] = []
        recommendations.append(contentsOf: randomElements(from: &unlistenedAlbums, count: numUnlistened).map {$0.recordId!})
        recommendations.append(contentsOf: randomElements(from: &longTimeNotListenedAlbums, count: numLongTimeNotListened).map {$0.recordId!})
        recommendations.append(contentsOf: randomElements(from: &mostListenedAlbums, count: numMostListened).map {$0.recordId!})

        
        weekRecommendations = recommendations
        Task {
                do {
                    try await saveRecommendations()
                } catch {
                    print("Failed to save recommendations: \(error)")
                }
            }
    }
    
    // function to draw 'count' random elements from an array
    func randomElements<T>(from array: inout [T], count: Int) -> [T] {
        var result: [T] = []
        for _ in 0..<count {
            let i = Int.random(in: 0..<array.count)
            result.append(array.remove(at: i))
        }
        return result
    }
   
    func saveRecommendations() async throws {
        let query = CKQuery(recordType: "Recommendations", predicate: NSPredicate(value: true))
        let result = try await database.records(matching: query)
        let records = result.matchResults.compactMap { try? $0.1.get() }

        if let existingRecord = records.first {
            existingRecord["albums"] = weekRecommendations.map { $0.recordName }
            try await database.save(existingRecord)
        } else {
            let newRecord = CKRecord(recordType: "Recommendations")
            newRecord["albums"] = weekRecommendations.map { $0.recordName }
            try await database.save(newRecord)
        }
    }

    
    func loadRecommendations() async throws {
        let query = CKQuery(recordType: "Recommendations", predicate: NSPredicate(value: true))
        let result = try await database.records(matching: query)
        let records = result.matchResults.compactMap { try? $0.1.get() }

        if let record = records.first {
            let recordNames = record["albums"] as! [String]
            weekRecommendations = recordNames.compactMap { CKRecord.ID(recordName: $0) }
        }

    }

}



