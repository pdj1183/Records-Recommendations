//
//  AlbumListView.swift
//  R&R
//
//  Created by Phillip Johnson on 2/6/24.
//

import SwiftUI
import CoreData

enum FilterOptions: String, CaseIterable, Identifiable {
    case all
    case listened
    case unlistened
}

extension FilterOptions {
    var id: String {
        rawValue
    }
    var displayName: String {
        rawValue.capitalized
    }
}

enum SortOptions: String, CaseIterable, Identifiable {
    case artist
    case date
    case listens
    case name
    var id: String { self.rawValue }
    var displayName: String { self.rawValue.capitalized }
}


struct AlbumListView: View {
    var userId: String
    @EnvironmentObject var viewModel: AlbumListViewModel
    
    var body: some View {
        
        NavigationStack {
            HeaderVeiw(subTitle: "Your Collection!", color: Color("Purple"))
                .offset(y: 140)
                .padding(.bottom, -140)
            List{
                VStack{
                    Picker("", selection: $viewModel.sortOption) {
                        ForEach(SortOptions.allCases) { option in
                            Text(option.displayName).tag(option)
                        }
                    } .onChange(of: viewModel.sortOption) { viewModel.fetchAlbums() }
                    Picker("Select", selection: $viewModel.filterOption) {
                        ForEach(FilterOptions.allCases) { option in
                            Text(option.displayName).tag(option)
                        }
                    }.pickerStyle(.segmented)
                        .onChange(of: viewModel.filterOption) { viewModel.fetchAlbums() }
                }
                HStack {
                    VStack{
                        Text("Name")
                    }
                    Spacer()
                    VStack{
                        Text("Artist")
                    }
                    Spacer()
                    VStack{
                        Text("Listens")
                    }
                }
                ForEach(viewModel.albums) { album in
                    let album = AlbumItemModel(id: album.id!, name: album.name!, artist: album.artist!, genre: album.genre!, listens: album.listens, lastListened: album.lastListened!)
                    AlbumItemView(viewModel: AlbumItemViewModel(albumItem: album))
                
                        .foregroundStyle(Color("Purple"))
                }
                .onDelete(perform: { indexSet in
                    guard let index = indexSet.map({ $0 }).last else {
                        return
                    }
                    CoreDataManager.shared.removeAlbum(id: viewModel.albums[index].id!)
                    viewModel.fetchAlbums()
                })
            }
.toolbar {
                    ToolbarItem{
                        Button(action: {
                            viewModel.showNewItemView = true
                            }) {
                            Image(systemName: "plus")
                                .foregroundStyle(.white)
                        }
                    }
                }

.sheet(isPresented: $viewModel.showNewItemView) {
    NewItemView(newItemPresented: $viewModel.showNewItemView, onAddCompletion: viewModel.fetchAlbums)
}

        }
    }
}

#Preview {
    AlbumListView(userId: "").environment(\.managedObjectContext, PersistenceController.shared.container.viewContext)
}
