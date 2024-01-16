//
//  AlbumsItemsView.swift
//  R&R iOS
//
//  Created by Phillip Johnson on 12/30/23.
//

import SwiftUI

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

    @StateObject var viewModel = AlbumListViewModel()
    @EnvironmentObject private var cloudModel: CloudModel
    @State private var filterOption: FilterOptions = .all
    @State private var sortOption: SortOptions = .listens


    
    private var filteredAlbumItems: [AlbumItem] {
        let filteredItems = cloudModel.filterAlbumItems(by: filterOption)
        return cloudModel.sortAlbumItems(by: sortOption, items: filteredItems)
    }

    
    
    var body: some View {
        let albumItems = filteredAlbumItems
        NavigationStack {
            HeaderVeiw(subTitle: "Your Collection!", color: Color("Purple"))
                .offset(y: 140)
                .padding(.bottom, -140)
            List{
                VStack{
                    Picker("", selection: $sortOption) {
                        ForEach(SortOptions.allCases) { option in
                            Text(option.displayName).tag(option)
                        }
                    }
                    Picker("Select", selection: $filterOption) {
                        ForEach(FilterOptions.allCases) { option in
                            Text(option.displayName).tag(option)
                        }
                    }.pickerStyle(.segmented)
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
                ForEach(0..<albumItems.count, id: \.self) { index in
                    let albumItem = albumItems[index]
                    AlbumItemView(index: index, albumItem: albumItem)
                        .foregroundStyle(Color("Purple"))
                }
                .onDelete(perform: { indexSet in
                    guard let index = indexSet.map({ $0 }).last else {
                        return
                    }
                    
                    let albumItem = cloudModel.albums[index]
                    Task {
                        do {
                            try await cloudModel.deleteAlbum(albumItemToBeDeleted: albumItem)
                        } catch {
                            print(error)
                        }
                    }
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
                    NewItemView(newItemPresented: $viewModel.showNewItemView)
                }
        }
    }
}

#Preview {
    AlbumListView(userId: "").environmentObject(CloudModel())
}
