//
//  AlbumItemView.swift
//  R&R iOS
//
//  Created by Phillip Johnson on 12/30/23.
//

import SwiftUI

struct RecommendedAlbumItemView: View {
    @StateObject var viewModel = AlbumItemViewModel()
    @EnvironmentObject private var cloudModel: CloudModel
    let index: Int
    var albumItem: AlbumItem
    
    func increment() {
        let newAlbumItem = AlbumItem(recordId: albumItem.recordId, name: albumItem.name, artist: albumItem.artist, genre: albumItem.genre, listens: albumItem.listens + 1, lastListened: Date())
        Task {
            try await cloudModel.updateAlbum(editedAlbumItem: newAlbumItem)
        }
    }

    var body: some View {
        HStack{
            Button {
                viewModel.showEditAlbumItemView = true
            } label: {
                HStack {
                    VStack{
                        Text(albumItem.name)
                            .lineLimit(1)
                            .padding()
                    }
                    Spacer()
                }
            }
            .buttonStyle(.borderless)

            
            Button {
                increment()
            } label: {
                VStack{
                    HStack {
                        Text("\(albumItem.listens)")
                        Image(systemName: "waveform.badge.plus")
                    }
                }
            }
            .buttonStyle(.borderless)

        }
        .sheet(isPresented: $viewModel.showEditAlbumItemView, content: {
            EditAlbumItemView(index: 0, color: Color("Cyan"), viewModel: EditAlbumItemViewModel(albumItem: albumItem), EditAlbumItemPresented: $viewModel.showEditAlbumItemView)
        })
    }
    
}

#Preview {
    RecommendedAlbumItemView(index: 0, albumItem: AlbumItem(name: "life of a wallflower", artist: "Whethan", genre: "EDM", listens: 10, lastListened: Date()))
}
