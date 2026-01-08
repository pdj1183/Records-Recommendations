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
        NavigationView {
            VStack {
                Form {
                    Section(header: Text("Album Details")) {
                        HStack {
                            Text("Album Name")
                                .frame(maxWidth: .infinity, alignment: .leading)
                            TextField("Title", text: $viewModel.name)
                                .frame(maxWidth: .infinity, alignment: .trailing)
                                .multilineTextAlignment(.trailing)
                        }
                        
                        HStack {
                            Text("Artist Name")
                                .frame(maxWidth: .infinity, alignment: .leading)
                            TextField("Artist", text: $viewModel.artist)
                                .multilineTextAlignment(.trailing)
                        }
                        
                        HStack {
                            Text("Genre")
                                .frame(maxWidth: .infinity, alignment: .leading)
                            TextField("Genre", text: $viewModel.genre)
                                .multilineTextAlignment(.trailing)
                        }
                    }
                    
                    Section(header: Text("Listening Stats")) {
                        Picker("Listens", selection: viewModel.listensBinding) {
                            ForEach(0...100, id: \.self) { number in
                                Text("\(number)")
                            }
                        }
                        
                        HStack {
                            Text("Last Listened")
                                .frame(maxWidth: .infinity, alignment: .leading)
                            Text(viewModel.lastListened!, formatter: itemFormatter)
                                .foregroundStyle(.secondary)
                        }
                    }
                    
                    Section {
                        HStack(spacing: 12) {
                            RRButton(title: "Cancel", background: .gray) {
                                EditAlbumItemPresented = false
                            }
                            RRButton(title: "Save", background: color) {
                                if viewModel.canEdit {
                                    edit()
                                    EditAlbumItemPresented = false
                                } else {
                                    viewModel.showAlert = true
                                }
                            }
                        }
                        .listRowInsets(EdgeInsets())
                        .listRowBackground(Color.clear)
                    }
                }
                .alert(isPresented: $viewModel.showAlert) {
                    Alert(title: Text("Error"), message: Text("Please fill in Album Name and Artist"))
                }
            }
            .toolbar {
                ToolbarItem(placement: .principal) {
                    Text("Edit Album")
                        .foregroundStyle(color)
                        .font(Font.custom("Cochin", fixedSize: 32))
                        .bold()
                        .padding(.top, 50)
                }
                ToolbarItem(placement: .topBarTrailing) {
                    Button(action: {
                        EditAlbumItemPresented = false
                    }) {
                        Image(systemName: "xmark.circle.fill")
                            .imageScale(.large)
                            .foregroundStyle(.secondary)
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

