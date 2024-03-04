//
//  EditAlbumItemView.swift
//  R&R
//
//  Created by Phillip Johnson on 2/6/24.
//

import CloudKit
import SwiftUI

struct EditAlbumItemView: View {
    let index: Int
    let color: Color
    @StateObject var viewModel: EditAlbumItemViewModel
    @Binding var EditAlbumItemPresented: Bool

    func edit() {
        guard viewModel.canEdit else {
            return
        }
       
        var editedAlbumItem = AlbumItemModel(id: viewModel.id ,name: viewModel.name, artist: viewModel.artist, genre: viewModel.genre, listens: viewModel.listens, lastListened: viewModel.lastListened! )
        if editedAlbumItem.listens > viewModel.listens {
            editedAlbumItem.lastListened = Date()
        }
        Task{
            CoreDataManager.shared.updateAlbum(editedAlbum: editedAlbumItem)
        }
        
    }
    var body: some View {
        let dateFormatter = DateFormatter()
        NavigationView{
            VStack {
                Form {
                    // Album Name
                    HStack{
                        Text("Album Name")
                            .frame(maxWidth: .infinity, alignment: .leading)
                        TextField("Title", text: $viewModel.name)
                            .frame(maxWidth: .infinity, alignment: .trailing)
                    }
                    // Artist
                    HStack{
                        Text("Artist Name")
                            .frame(maxWidth: .infinity, alignment: .leading)
                        TextField("Artist", text: $viewModel.artist)
                    }
                    // Genre
                    HStack{
                        Text("Genre")
                            .frame(maxWidth: .infinity, alignment: .leading)
                        TextField("Genre", text: $viewModel.genre)
                    }
                    // Listens
                    HStack{
                        Picker("Listens", selection: viewModel.listensBinding) {
                            ForEach(0...100, id: \.self) {number in
                                Text("\(number)")
                            }
                        }
                        .padding(.trailing, 120)
                    }
                    // Last Listened
                    HStack{
                        Text("Last Listened")
                            .frame(maxWidth: .infinity, alignment: .leading)
                        Text(viewModel.lastListened!, formatter: itemFormatter)
                    }
                    // Buttons
                    HStack{
                        RRButton(title: "Cancel", background: .gray) {
                            EditAlbumItemPresented = false
                        }
                        .padding()
                        RRButton(title: "Save", background: color) {
                            if viewModel.canEdit {
                                edit()
                                EditAlbumItemPresented = false
                            } else {
                                viewModel.showAlert = true
                            }
                        }
                        .padding()
                    }}
                .alert(isPresented: $viewModel.showAlert) {
                    Alert(title: Text("Error"), message: Text("Please fill in Album Name and Artist"))
                }
            }
            .toolbar{
                ToolbarItem(placement: .principal){
                    Text("Edit Album")
                        .foregroundStyle(color)
                        .font(Font.custom("Cochin", fixedSize: 32))
                        .bold()
                        .padding(.top, 50)
                }
                ToolbarItem{
                    Button(action: {
                        // Action
                        EditAlbumItemPresented = false
                    })
                    {
                        Image(systemName: "multiply")
                    }
                    
                }
            }
        }
        
    }
    private let itemFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .short
        formatter.timeStyle = .medium
        return formatter
    }()
}

#Preview {
    EditAlbumItemView(index: 0, color: Color("Cyan"), viewModel: EditAlbumItemViewModel(albumItem: AlbumItemModel(id: UUID(), name: "Test", artist: "Test", genre: "test", listens: 5, lastListened: Date())), EditAlbumItemPresented: Binding(get: {return true}, set: {_ in})).environment(\.managedObjectContext, PersistenceController.shared.container.viewContext)
    
}

