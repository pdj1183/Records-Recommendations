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
    var displayName: String {
        if (self.rawValue == "date") {
            let short = self.rawValue.capitalized
            return short + (" (oldest first)")
        }
        return self.rawValue.capitalized
    }
}


struct AlbumListView: View {
    var userId: String
    @EnvironmentObject var viewModel: AlbumListViewModel
    @State var albumMode:Bool = true
    
    var body: some View {
        
        NavigationStack {
            HeaderVeiw(subTitle: "Your Collection!", color: Color("Purple"))
                .offset(y: 140)
                .padding(.bottom, -140)
            HStack {
                Spacer()
                Button(action: {
                    albumMode = true
                }, label: {
                    Text("Albums")
                        .font(Font.custom("Cochin", fixedSize: 26))
                        .foregroundStyle(Color("Purple"))
                        .bold()
                        .underline(albumMode)
                })
                Spacer()
                Button(action: {
                    albumMode = false
                }, label: {
                    Text("Artists")
                        .font(Font.custom("Cochin", fixedSize: 26))
                        .foregroundStyle(Color("Purple"))
                        .bold()
                        .underline(!albumMode)
                })
                Spacer()
            }
            if albumMode {
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
                    //                HStack {
                    //                    VStack{
                    //                        Text("Name")
                    //                    }
                    //                    Spacer()
                    //                    VStack{
                    //                        Text("Artist")
                    //                    }
                    //                    Spacer()
                    //                    VStack{
                    //                        Text("Listens")
                    //                    }
                    //                }
                    ForEach(viewModel.albums) { album in
                        let album = AlbumItemModel(id: album.id!, name: album.name!, artist: album.artist!, genre: album.genre!, listens: album.listens, lastListened: album.lastListened!)
                        AlbumItemView(viewModel: AlbumItemViewModel(albumItem: album), color: Color("Purple"))
                        
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
                
            } else {
                List{
                    ForEach(viewModel.artists.sorted{ $0.key < $1.key}, id: \.key) { key, value in
                        Section(header: Text(key)
                            .font(Font.custom("Cochin", fixedSize: 22))
                            .foregroundStyle(Color("Purple"))
                            .bold()
                        ){
                            ForEach(0..<value.count) { i in
                                AlbumItemView(viewModel: AlbumItemViewModel(albumItem: value[i]), color: Color("Purple"))
                                    .foregroundStyle(Color("Purple"))
                            }
                        }
                    }

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
                .onAppear{
                    viewModel.getArtists()
                }
                .sheet(isPresented: $viewModel.showNewItemView) {
                    NewItemView(newItemPresented: $viewModel.showNewItemView, onAddCompletion: viewModel.fetchAlbums)
                }
            }
        }
    }
}

#Preview {
    AlbumListView(userId: "").environment(\.managedObjectContext, PersistenceController.shared.container.viewContext).environmentObject(AlbumListViewModel())
}
