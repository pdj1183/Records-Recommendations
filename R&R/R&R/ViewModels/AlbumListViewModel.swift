//
//  AlbumListViewModel.swift
//  R&R
//
//  Created by Phillip Johnson on 2/6/24.
//

import Foundation
import CoreData
import SwiftUI

class AlbumListViewModel: ObservableObject {
    @Published var albums: [AlbumItem] = []
    @Published var showNewItemView = false
    @Published var filterOption: FilterOptions = .all
    @Published var sortOption: SortOptions = .listens
    @Published var weeklyAlbums: [AlbumItemModel] = []
    @Published var randomAlbum: [AlbumItem] = []
    @Published var mostListened: [AlbumItem] = []
    @Published var oldestListened: [AlbumItem] = []
    @Published var genres: [Genre] = []
    @Published var artists: [String: [AlbumItemModel]] = [:]
    
    init() {
        fetchAlbums()
        getRandom()
        getWeek()
        getMostListend()
        getFavGenre()
        getOldestListened()
        getArtists()
    }
    
    // Call this to refresh the list
    func fetchAlbums() {
        albums = CoreDataManager.shared.fetchFilteredAndSortedAlbumItems(filteredBy: filterOption, sortedBy: sortOption) // Adapt this based on actual filtering/sorting mechanisms
    }
    
    func updateAlbums(filter: FilterOptions, sort: SortOptions) {
        albums = CoreDataManager.shared.fetchFilteredAndSortedAlbumItems(filteredBy: filter, sortedBy: sort)
    }

    func getRandom() {
        randomAlbum = CoreDataManager.shared.randomRecommendation()
    }
    
    func getWeek() {
        weeklyAlbums = CoreDataManager.shared.loadWeek()
    }
    
    func getMostListend() {
        guard let album = CoreDataManager.shared.getMostListened() else {
            return
        }
        mostListened = [album]
    }
    
    struct Genre {
        var genre: String
        var listens: Int16
        var color: Color
    }
    
    func getFavGenre() {
        let colorArr: [Color] = [Color("bar1"), Color("bar2"), Color("bar3"), Color("bar4"), Color("bar5")]

        genres = []
        let genreList = CoreDataManager.shared.getFavGenre()
        var i = 0
        for genre in genreList {
            genres.append(Genre(genre: genre.key, listens: genre.value, color: colorArr[i % colorArr.count]))
            i += 1
        }
        genres = genres.sorted { $0.genre < $1.genre}
    }
    
    func getOldestListened() {
        guard let album = CoreDataManager.shared.getOldest() else {
            return
        }
        oldestListened = [album]
    }
    
    struct Artist {
        var name: String
        var songs: [AlbumItemModel]
    }
    
    func getArtists() {
        artists = [:]
        let albums = CoreDataManager.shared.fetchFilteredAndSortedAlbumItems(filteredBy: .all, sortedBy: .artist)
        for album in albums {
            let albumModel = AlbumItemModel(id: album.id!, name: album.name!, artist: album.artist!, genre: album.genre!, listens: album.listens, lastListened: album.lastListened!)
            if let artist = album.artist, !artist.isEmpty {
                artists[artist, default: []].append(albumModel)
            }
        }
    }

}

