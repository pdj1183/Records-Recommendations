//
//  AlbumItemView.swift
//  R&R
//
//  Created by Phillip Johnson on 2/6/24.
//

import SwiftUI

struct AlbumItemView: View {
    @StateObject var viewModel: AlbumItemViewModel
    let color: Color
    

    var body: some View {
        HStack(spacing: 12) {
            Button {
                viewModel.showEditAlbumItemView = true
            } label: {
                HStack(spacing: 8) {
                    Text(String(viewModel.album.name))
                        .lineLimit(2)
                        .truncationMode(.tail)
                        .allowsTightening(true)
                        .multilineTextAlignment(.leading)
                    Spacer()
                }
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            .layoutPriority(1)
            .buttonStyle(.borderless)

            Divider()
                .frame(width: 1, height: 35)
                .foregroundStyle(color)
                .opacity(0.7)
            
            Button {
                CoreDataManager.shared.listen(id: viewModel.album.id)
                viewModel.fetchAlbum(album: viewModel.album)
            } label: {
                HStack(spacing: 6) {
                    Text("\(viewModel.album.listens)")
                        .lineLimit(1)
                        .minimumScaleFactor(0.8)
                    Image(systemName: "waveform.badge.plus")
                        .imageScale(.medium)
                }
            }
            .frame(minWidth: 50)
            .fixedSize(horizontal: true, vertical: false)
            .layoutPriority(0)
            .buttonStyle(.borderless)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(.horizontal, 12)
        .padding(.vertical, 8)
        .onAppear {
            viewModel.fetchAlbum(album: viewModel.album)
        }
        .sheet(isPresented: $viewModel.showEditAlbumItemView, onDismiss: {viewModel.fetchAlbum(album: viewModel.album)} , content: {
            EditAlbumItemView(index: 0, color: color, viewModel: EditAlbumItemViewModel(albumItem: viewModel.album), EditAlbumItemPresented: $viewModel.showEditAlbumItemView)
        })
        
    }
    
}

#Preview {
    AlbumItemView(viewModel: AlbumItemViewModel(albumItem: AlbumItemModel(id: UUID(),name: "life of a wallflower", artist: "Whethan", genre: "EDM", listens: 10, lastListened: Date())), color: Color("Cyan"))
}

