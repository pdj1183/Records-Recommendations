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
                .offset(y: 124)
                .padding(.bottom, -124)
            HStack(spacing: 40) {
                Spacer()
                Button(action: {
                    albumMode = true
                }) {
                    Text("Albums")
                        .font(Font.custom("Cochin", fixedSize: 26))
                        .foregroundStyle(Color("Purple"))
                        .bold()
                        .underline(albumMode)
                }
                Spacer()
                Button(action: {
                    albumMode = false
                }) {
                    Text("Artists")
                        .font(Font.custom("Cochin", fixedSize: 26))
                        .foregroundStyle(Color("Purple"))
                        .bold()
                        .underline(!albumMode)
                }
                Spacer()
            }
            .padding(.vertical, 8)
            if albumMode {
                List {
                    Section {
                        VStack(spacing: 12) {
                            Picker("", selection: $viewModel.sortOption) {
                                ForEach(SortOptions.allCases) { option in
                                    Text(option.displayName).tag(option)
                                }
                            }
                            .onChange(of: viewModel.sortOption) { viewModel.fetchAlbums() }
                            
                            Picker("Select", selection: $viewModel.filterOption) {
                                ForEach(FilterOptions.allCases) { option in
                                    Text(option.displayName).tag(option)
                                }
                            }
                            .pickerStyle(.segmented)
                            .onChange(of: viewModel.filterOption) { viewModel.fetchAlbums() }
                        }
                        .padding(.vertical, 8)

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
                    .padding()
                }
                
                .listStyle(.insetGrouped)
                .scrollContentBackground(.hidden)
                .toolbar {
                    ToolbarItem {
                        Button(action: {
                            viewModel.showNewItemView = true
                        }) {
                            Image(systemName: "plus")
                                .foregroundStyle(.white)
                                .imageScale(.large)
                        }
                    }
                }
                .sheet(isPresented: $viewModel.showNewItemView) {
                    NewItemView(newItemPresented: $viewModel.showNewItemView, onAddCompletion: viewModel.fetchAlbums)
                }
                
            } else {
                List {
                    Section {
                        ForEach(viewModel.artists.sorted { $0.key < $1.key }, id: \.key) { key, value in
                            Section(header: Text(key)
                                .font(Font.custom("Cochin", fixedSize: 22))
                                .foregroundStyle(Color("Purple"))
                                .bold()
                            ) {
                                ForEach(0..<value.count) { i in
                                    AlbumItemView(viewModel: AlbumItemViewModel(albumItem: value[i]), color: Color("Purple"))
                                        .foregroundStyle(Color("Purple"))
                                }
                            }
                        }
                    }
                    .padding()
                }
                .listStyle(.insetGrouped)
                .scrollContentBackground(.hidden)
                .toolbar {
                    ToolbarItem {
                        Button(action: {
                            viewModel.showNewItemView = true
                        }) {
                            Image(systemName: "plus")
                                .foregroundStyle(.white)
                                .imageScale(.large)
                        }
                    }
                }
                .onAppear {
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
