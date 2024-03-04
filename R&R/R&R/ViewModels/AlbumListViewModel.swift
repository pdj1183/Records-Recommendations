//
//  AlbumListViewModel.swift
//  R&R
//
//  Created by Phillip Johnson on 2/6/24.
//

import Foundation
import CoreData

class AlbumListViewModel: ObservableObject {
    @Published var albums: [AlbumItem] = []
    @Published var showNewItemView = false
    @Published var filterOption: FilterOptions = .all
    @Published var sortOption: SortOptions = .listens
    @Published var weeklyAlbums: [AlbumItemModel] = []
    @Published var randomAlbum: [AlbumItem] = []
    
    init() {
        fetchAlbums()
        getRandom()
        getWeek()
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

}

