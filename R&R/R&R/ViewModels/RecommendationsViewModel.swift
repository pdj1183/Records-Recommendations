//
//  RecommendationsViewModel.swift
//  R&R
//
//  Created by Phillip Johnson on 2/16/24.
//

import Foundation
import CoreData

class RecommendationsViewModel: ObservableObject {
    @Published var weeklyAlbums: [AlbumItemModel]
    @Published var randomAlbum: [AlbumItem]
    
    init() {

        randomAlbum = CoreDataManager.shared.randomRecommendation()
        weeklyAlbums = CoreDataManager.shared.loadWeek()
    }

}
