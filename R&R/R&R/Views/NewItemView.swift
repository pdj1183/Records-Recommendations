//
//  NewItemView.swift
//  R&R
//
//  Created by Phillip Johnson on 2/6/24.
//

import SwiftUI

struct NewItemView: View {
    @StateObject var viewModel = NewItemViewModel()
    
    func add() {
        guard viewModel.canAdd else {
            return
        }
       
//        let albumItem = AlbumItemModel(name: viewModel.album, artist: viewModel.artist, genre: viewModel.genre, listens: 0, lastListened: viewModel.lastListened)
        Task{
            CoreDataManager.shared.addAlbum(name: viewModel.album, artist: viewModel.artist, genre: viewModel.genre)
            DispatchQueue.main.async {
                            onAddCompletion?() // Call the completion handler
                            newItemPresented = false
                        }
        }
        
    }
    @Binding var newItemPresented: Bool
    var onAddCompletion: (() -> Void)?
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
    NewItemView(newItemPresented: Binding(get: {return true}, set: {_ in })) .environment(\.managedObjectContext, PersistenceController.shared.container.viewContext)
}

