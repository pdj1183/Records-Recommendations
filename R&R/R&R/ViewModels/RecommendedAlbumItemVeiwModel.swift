////
////  RecommendedAlbumItemVeiwModel.swift
////  R&R
////
////  Created by Phillip Johnson on 2/16/24.
////
//
//import Foundation
//import CoreData
//
//class RecommendedAlbumItemVeiwModel: ObservableObject {
//    @Published var showEditAlbumItemView = false
//    @Published var showEditListensVeiw = false
//    @Published var album: AlbumItemModel
//
//    init(albumItem: AlbumItemModel) {
//        album = albumItem
//        fetchAlbum(album: album)
//    }
//    
//    func fetchAlbum(album: AlbumItemModel) {
//        self.album = CoreDataManager.shared.fetchAlbum(id: album.id)[0]
//    }
//}
