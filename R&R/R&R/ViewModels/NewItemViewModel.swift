//
//  NewItemViewModel.swift
//  R&R
//
//  Created by Phillip Johnson on 2/6/24.
//

import Foundation

class NewItemViewModel: ObservableObject {
    @Published var album = ""
    @Published var artist = ""
    @Published var genre = ""
    @Published var listens = 0
    @Published var lastListened = Date()
    @Published var showAlert = false
        
    
    var canAdd: Bool {
        guard !album.trimmingCharacters(in: .whitespaces).isEmpty else {
            return false
        }
        
        guard !artist.trimmingCharacters(in: .whitespaces).isEmpty else {
            return false
        }
        return true
    }
    
}
