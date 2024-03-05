import CoreData
import SwiftUI
import Foundation

class CoreDataManager {
    static let shared = CoreDataManager()
    let container: NSPersistentCloudKitContainer
    private var albumsArr: [AlbumItem] = []
    private var gFilterOptions: FilterOptions = FilterOptions.all
    private var gSortOptions: SortOptions = SortOptions.listens
    
    private init() {
        container = NSPersistentCloudKitContainer(name: "R_R")
        container.loadPersistentStores { storeDescription, error in
            if let error = error {
                fatalError("Unresolved error \(error)")
            }
        }
        container.viewContext.automaticallyMergesChangesFromParent = true
        // Additional setup...
    }
    
    func saveContext() {
        let context = container.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }
    
    func addAlbum(name: String, artist: String, genre: String?) {
        let newAlbum = AlbumItem(context: container.viewContext)
        newAlbum.id = UUID()
        newAlbum.name = name
        newAlbum.genre = genre
        newAlbum.artist = artist
        newAlbum.listens = 0
        
        saveContext()
    }
    
    func updateAlbum(editedAlbum: AlbumItemModel) {
        let fetchRequest: NSFetchRequest<AlbumItem> = AlbumItem.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "id == %@", editedAlbum.id as CVarArg) // Filter by the unique id
        
        do {
            let results = try container.viewContext.fetch(fetchRequest)
            
            if let albumToUpdate = results.first {
                let i = albumsArr.firstIndex(of: albumToUpdate)
                // Updating album's attributes
                albumToUpdate.name = editedAlbum.name
                albumToUpdate.artist = editedAlbum.artist
                albumToUpdate.genre = editedAlbum.genre
                albumToUpdate.listens = editedAlbum.listens
                
                saveContext() // Save changes to the context
                print("Album updated successfully.")
                
                
                albumsArr[i!] = albumToUpdate
            }
        } catch {
            print("Failed to fetch album: \(error.localizedDescription)")
        }
    }
    
    func removeAlbum(id: UUID) {
        let fetchRequest: NSFetchRequest<AlbumItem> = AlbumItem.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "id == %@", id as CVarArg) // Filter by the unique id
        
        do {
            let results = try container.viewContext.fetch(fetchRequest)
            
            if let albumToRemove = results.first {
                container.viewContext.delete(albumToRemove) // Deleting the album
                saveContext() // Save changes to the context
                print("Album removed successfully.")
            }
        } catch {
            print("Failed to fetch album: \(error.localizedDescription)")
        }
    }
    
    func listen(id: UUID) {
        let fetchRequest: NSFetchRequest<AlbumItem> = AlbumItem.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "id == %@", id as CVarArg) // Filter by the unique id
        
        do {
            let results = try container.viewContext.fetch(fetchRequest)
            if let album = results.first {
                let i = albumsArr.firstIndex(of: album)
                album.lastListened = Date()
                album.listens += 1 // Incrementing listen count by 1
                saveContext() // Save changes to the context
               
                albumsArr[i!] = album
            }
        } catch {
            print("Failed to fetch album: \(error.localizedDescription)")
        }
    }
}

extension CoreDataManager {
    func fetchFilteredAndSortedAlbumItems(filteredBy filterOptions: FilterOptions, sortedBy sortOptions: SortOptions) -> [AlbumItem] {
        let fetchRequest: NSFetchRequest<AlbumItem> = AlbumItem.fetchRequest()
        
        // Apply sort option
        let sortDescriptor: NSSortDescriptor
        switch sortOptions {
        case .artist:
            sortDescriptor = NSSortDescriptor(key: "artist", ascending: true, selector: #selector(NSString.caseInsensitiveCompare))
        case .date:
            sortDescriptor = NSSortDescriptor(key: "lastListened", ascending: true) // Adjust the key as per your model
        case .listens:
            sortDescriptor = NSSortDescriptor(key: "listens", ascending: false)
        case .name:
            sortDescriptor = NSSortDescriptor(key: "name", ascending: true, selector: #selector(NSString.caseInsensitiveCompare))
        }
        
        let secondarySort: NSSortDescriptor = NSSortDescriptor(key: "name", ascending: true, selector: #selector(NSString.caseInsensitiveCompare))
        fetchRequest.sortDescriptors = [sortDescriptor, secondarySort]
        
        // Apply filter option
        switch filterOptions {
        case .all:
            // No additional predicate needed
            break
        case .listened:
            fetchRequest.predicate = NSPredicate(format: "listens > %d", 0)
        case .unlistened:
            fetchRequest.predicate = NSPredicate(format: "listens == %d", 0)
        }
        gSortOptions = sortOptions
        gFilterOptions = filterOptions
        do {
            let albums = try container.viewContext.fetch(fetchRequest)
            albumsArr = albums
            return albums
        } catch {
            print("Failed to fetch albums: \(error.localizedDescription)")
            return []
        }
    }
    
    func fetchAlbum(id: UUID) -> [AlbumItemModel] {
        let fetchRequest: NSFetchRequest<AlbumItem> = AlbumItem.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "id == %@", id as CVarArg)
        
        do {
            let results = try container.viewContext.fetch(fetchRequest)
            if let album = results.first{
                let albumItem = AlbumItemModel(id: album.id!, name: album.name!, artist: album.artist!, genre: album.genre!, listens: album.listens, lastListened: album.lastListened!)
                return [albumItem]
            }
        } catch {
            print("Failed to fetch album: \(error.localizedDescription)")
            
        }
        return []
    }
}

extension CoreDataManager {
    func randomRecommendation() -> [AlbumItem] {
        guard !albumsArr.isEmpty else { return [] }

        return [albumsArr.randomElement()!]
        
    }
    
    func weeklyRecommendation() {
        var arr = albumsArr
        var recommendations: String = ""
        var unlistenedAlbums = arr.filter { $0.listens == 0 }.sorted { $0.lastListened! < $1.lastListened! }
        let numUnlistened = min(3, unlistenedAlbums.count)
        
        for _ in 0..<numUnlistened {
            if let album = unlistenedAlbums.randomElement() {
                recommendations += "\(String(describing: album.id!))\n"
                unlistenedAlbums.removeAll(where: { $0.id == album.id })
                arr.removeAll(where: { $0.id == album.id })
            }
        }

        var longTimeNotListenedAlbums = arr.filter { $0.listens > 0 }.sorted { $0.lastListened! < $1.lastListened! }
        let numLongTimeNotListened = min(7 - numUnlistened, longTimeNotListenedAlbums.count)
        
        for _ in 0..<numLongTimeNotListened {
            if let album = longTimeNotListenedAlbums.randomElement() {
                recommendations += "\(String(describing: album.id!))\n"
                longTimeNotListenedAlbums.removeAll(where: { $0.id == album.id })
                arr.removeAll(where: { $0.id == album.id })
            }
        }

        var mostListenedAlbums = arr.sorted { $0.listens > $1.listens }
        let numMostListened = 7 - numUnlistened - numLongTimeNotListened

        for _ in 0..<numMostListened {
            if let album = mostListenedAlbums.randomElement() {
                recommendations += "\(String(describing: album.id!))\n"
                mostListenedAlbums.removeAll(where: { $0.id == album.id })
                arr.removeAll(where: { $0.id == album.id })
            }
        }
        
        let fetchRequest: NSFetchRequest<WeeklyRecommendation> = WeeklyRecommendation.fetchRequest()
        
        let batchDeleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest as! NSFetchRequest<NSFetchRequestResult>)
        
        do {
            try container.viewContext.execute(batchDeleteRequest)
            saveContext()
            print("All recommendations removed successfully.")
        } catch {
            print("Failed to remove recommendations: \(error.localizedDescription)")
        }
        
        let weekRecommendations = WeeklyRecommendation(context: container.viewContext)
        weekRecommendations.recommendation = recommendations
        saveContext()
    }
    
    func loadWeek() -> [AlbumItemModel] {
        let fetchRequest: NSFetchRequest<WeeklyRecommendation> = WeeklyRecommendation.fetchRequest()
        do {
            let results = try container.viewContext.fetch(fetchRequest)
            if let recommendation = results.first{
                if recommendation.recommendation != nil {
                    var Recommendations: [AlbumItemModel] = []
                    let ids = recommendation.recommendation!.split(separator: "\n")
                    for id in ids {
                        let id: UUID = UUID(uuidString: String(id))!
                        let album = fetchAlbum(id: id)[0]
                        Recommendations.append(album)
                    }
                    return Recommendations
                }
                
            }} catch {
                print("Failed to fetch album: \(error.localizedDescription)")
                return []

            }
        return []
        }
    }

extension CoreDataManager {
    func getMostListened() -> AlbumItem? {
        if !albumsArr.isEmpty {
            let mostListenedAlbums = albumsArr.sorted { $0.listens > $1.listens }
            return mostListenedAlbums[0]
        }
        return nil
    }
    
    func getFavGenre() -> [String: Int16] {
        var genres: [String: Int16] = [:]
        for album in albumsArr {
            if let genre = album.genre, !genre.isEmpty {
                genres[genre, default: 0] += album.listens
            }
        }
        return genres
    }
    
    func getOldest() -> AlbumItem? {
        if albumsArr.count > 1 {
            var longTimeNotListenedAlbums = albumsArr.sorted { $0.lastListened! < $1.lastListened! }
            return longTimeNotListenedAlbums[0]
            
        }
        return nil
    }
}
    

