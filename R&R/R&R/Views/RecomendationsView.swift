//
//  RecomendationsView.swift
//  R&R
//
//  Created by Phillip Johnson on 2/6/24.
//

import SwiftUI

struct RecommendationsView: View {
    @AppStorage("first name") var firstName: String = ""
    @EnvironmentObject var viewModel: AlbumListViewModel
    
    var body: some View {
        
        NavigationStack {
            HeaderVeiw(subTitle: "Welcome Back \(self.firstName)!", color: Color("Cyan"))
                .offset(y: 178)
                .padding(.bottom, -102)
            List {
                Section{
                    HStack{
                        Spacer()
                        RRButton(title: "Give Me A Record", background: Color("Cyan"), action: {
                            viewModel.randomAlbum = CoreDataManager.shared.randomRecommendation()
                        })
                        Spacer()
                    }
                    if viewModel.randomAlbum != nil {
                        ForEach(viewModel.randomAlbum) { album in
                            let album = AlbumItemModel(id: album.id!, name: album.name!, artist: album.artist!, genre: album.genre!, listens: album.listens, lastListened: album.lastListened!)
                            AlbumItemView(viewModel: AlbumItemViewModel(albumItem: album), color: Color("Cyan"))
                                .foregroundColor(Color("Cyan"))
                        }
                    }
                }
                .listStyle(.insetGrouped)
                .padding()
                .listRowSeparator(.hidden)
                
                Section {
                    HStack{
                        Text("")
                        RRButton(title: "Weekly Records", background: Color("Cyan"), action: {
                            CoreDataManager.shared.weeklyRecommendation()
                            viewModel.weeklyAlbums = CoreDataManager.shared.loadWeek()
                        })
                        Spacer()
                    }
                    if viewModel.albums.count >= 7 {
                        ForEach(viewModel.weeklyAlbums, id: \.id) { album in
                            AlbumItemView(viewModel: AlbumItemViewModel(albumItem: album), color: Color("Cyan"))
                        }
                        .foregroundStyle(Color("Cyan"))
                    } else {
                        Text("We need some more records to work with")
                            .padding()
                            .foregroundStyle(Color("Cyan"))
                            .bold()
                            .multilineTextAlignment(.center)
                    }
                }
                
                .padding()
            }
        }
    }
}

#Preview {
    RecommendationsView(firstName: "").environmentObject(AlbumListViewModel())
}
