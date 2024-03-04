//
//  AlbumItemModel.swift
//  R&R
//
//  Created by Phillip Johnson on 2/6/24.
//
import Foundation
import CloudKit

struct AlbumItemModel  {
    var id: UUID // Replacing recordId with a simple UUID for local identification.
    let name: String
    let artist: String
    let genre: String
    var listens: Int16
    var lastListened: Date
    
    // Initializer that directly sets all properties
    init(id: UUID, name: String, artist: String, genre: String, listens: Int16, lastListened: Date) {
        self.id = id
        self.name = name
        self.artist = artist
        self.genre = genre
        self.listens = listens
        self.lastListened = lastListened
    }
}



