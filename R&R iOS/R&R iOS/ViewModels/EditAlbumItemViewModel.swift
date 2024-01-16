//
//  EditAlbumItemViewModel.swift
//  R&R iOS
//
//  Created by Phillip Johnson on 1/3/24.
//
import CloudKit
import Foundation

class EditAlbumItemViewModel: ObservableObject {
    @Published var name: String
    @Published var artist: String
    @Published var genre: String
    @Published var listens: Int
    @Published var recordId: CKRecord.ID?
    @Published var lastListened: Date?
    @Published var showAlert = false
    
    init(albumItem: AlbumItem) {
        self.name = albumItem.name
        self.artist = albumItem.artist
        self.genre = albumItem.genre
        self.listens = albumItem.listens
        self.recordId = albumItem.recordId
        self.lastListened = albumItem.lastListened
    }
    
    var canEdit: Bool {
        guard !name.trimmingCharacters(in: .whitespaces).isEmpty else {
            return false
        }
        
        guard !artist.trimmingCharacters(in: .whitespaces).isEmpty else {
            return false
        }
        return true
    }
}
