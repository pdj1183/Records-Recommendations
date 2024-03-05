//
//  RecommendedAlbumItemView.swift
//  R&R
//
//  Created by Phillip Johnson on 2/6/24.
//

import SwiftUI

struct RecommendedAlbumItemView: View {
    @StateObject var viewModel: AlbumItemViewModel
    var body: some View {
        HStack{
            Button {
                viewModel.showEditAlbumItemView = true
            } label: {
                HStack {
                    VStack{
                        Text(viewModel.album.name)
                            .lineLimit(1)
                            .padding()
                    }
                    Spacer()
                }
            }
            .buttonStyle(.borderless)

            
            Button {
                CoreDataManager.shared.listen(id: viewModel.album.id)
                viewModel.fetchAlbum(album: viewModel.album)
            } label: {
                VStack{
                    HStack {
                        Text("\(viewModel.album.listens)")
                        Image(systemName: "waveform.badge.plus")
                    }
                }
            }
            .buttonStyle(.borderless)

        }
        .onAppear {
            viewModel.fetchAlbum(album: viewModel.album)
        }
        .sheet(isPresented: $viewModel.showEditAlbumItemView, onDismiss: {viewModel.fetchAlbum(album: viewModel.album)  } , content: {
            EditAlbumItemView(index: 0, color: Color("Cyan"), viewModel: EditAlbumItemViewModel(albumItem: viewModel.album), EditAlbumItemPresented: $viewModel.showEditAlbumItemView)
        })

    }
    
}

#Preview {
    RecommendedAlbumItemView(viewModel: AlbumItemViewModel(albumItem: AlbumItemModel(id: UUID(),name: "life of a wallflower", artist: "Whethan", genre: "EDM", listens: 10, lastListened: Date())))
}
