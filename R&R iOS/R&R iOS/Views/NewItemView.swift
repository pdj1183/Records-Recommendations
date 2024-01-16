//
//  NewItemView.swift
//  R&R iOS
//
//  Created by Phillip Johnson on 12/30/23.
//

import SwiftUI

struct NewItemView: View {
    @StateObject var viewModel = NewItemViewModel()
    @EnvironmentObject private var cloudModel: CloudModel
    
    func add() {
        guard viewModel.canAdd else {
            return
        }
       
        let albumItem = AlbumItem(name: viewModel.album, artist: viewModel.artist, genre: viewModel.genre, listens: 0, lastListened: viewModel.lastListened)
        Task{
            try await cloudModel.addAlbum(albumItem: albumItem)
        }
        
    }
    @Binding var newItemPresented: Bool
    var body: some View {
        NavigationView{
            VStack {
                Form {
                    // Album Name
                    TextField("Title", text: $viewModel.album)
                    // Artist
                    TextField("Artist", text: $viewModel.artist)
                    // Genre
                    TextField("Genre", text: $viewModel.genre)
                    // Button
                    RRButton(title: "Add to Collection", background: .pink) {
                        if viewModel.canAdd {
                            add()
                            newItemPresented = false
                        } else {
                            viewModel.showAlert = true
                        }
                    }
                    .padding()
                }
                .alert(isPresented: $viewModel.showAlert) {
                    Alert(title: Text("Error"), message: Text("Please fill in Album Name and Artist"))
                }
            }
            .toolbar{
                ToolbarItem(placement: .principal){
                    Text("New Album")
                        .font(Font.custom("Amoitar", fixedSize: 32))
                        .foregroundStyle(.pink)
                        .bold()
                        .padding(.top, 50)
                }
                ToolbarItem{
                    Button(action: {
                        // Action
                        newItemPresented = false
                    })
                    {
                        Image(systemName: "multiply")
                    }
                    
                }
            }
        }
        
    }
}

#Preview {
    NewItemView(newItemPresented: Binding(get: {return true}, set: {_ in })).environmentObject(CloudModel())
}
