//
//  EditAlbumItemViewModel.swift
//  R&R
//
//  Created by Phillip Johnson on 2/6/24.
//

import Foundation
import SwiftUI

class EditAlbumItemViewModel: ObservableObject {
    @Published var name: String
    @Published var artist: String
    @Published var genre: String
    @Published var listens: Int16
    @Published var id: UUID
    @Published var lastListened: Date?
    @Published var showAlert = false
    
    init(albumItem: AlbumItemModel) {
        self.name = albumItem.name
        self.artist = albumItem.artist
        self.genre = albumItem.genre
        self.listens = albumItem.listens
        self.id = albumItem.id
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

extension EditAlbumItemViewModel {
    
    var listensBinding: Binding<Int> {
        Binding<Int>(
            get: {
                return Int(self.listens)
            },
            set: {
                self.listens = Int16($0)
            }
        )
    }
}
