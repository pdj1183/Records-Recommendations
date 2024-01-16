//
//  AlbumItem.swift
//  R&R iOS
//
//  Created by Phillip Johnson on 12/30/23.
//

import Foundation
import CloudKit

enum AlbumRecordKeys: String {
    case type = "Album"
    case name
    case artist
    case genre
    case listens
    case lastListened
}

struct AlbumItem  {
    var recordId: CKRecord.ID?
    let name: String
    let artist: String
    let genre: String
    var listens: Int
    var lastListened: Date
}

extension AlbumItem {
    init?(record: CKRecord) {
        guard let name = record[AlbumRecordKeys.name.rawValue] as? String,
              let artist = record[AlbumRecordKeys.artist.rawValue] as? String,
              let genre = record[AlbumRecordKeys.genre.rawValue] as? String,
              let listens = record[AlbumRecordKeys.listens.rawValue] as? Int,
              let lastListened = record[AlbumRecordKeys.lastListened.rawValue] as? Date else {
            return nil
        }
        self.init(recordId: record.recordID, name: name, artist: artist, genre: genre, listens: listens, lastListened: lastListened)
    }
}

extension AlbumItem {
    var record: CKRecord {
        let record = CKRecord(recordType: AlbumRecordKeys.type.rawValue)
        record[AlbumRecordKeys.name.rawValue] = name
        record[AlbumRecordKeys.artist.rawValue] = artist
        record[AlbumRecordKeys.genre.rawValue] = genre
        record[AlbumRecordKeys.listens.rawValue] = listens
        record[AlbumRecordKeys.lastListened.rawValue] = lastListened
        return record
    }
}


