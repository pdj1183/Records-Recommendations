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
                RRButton(title: "Give Me A Record", background: Color("Cyan"), action: {
                    viewModel.randomAlbum = CoreDataManager.shared.randomRecommendation()
               })
                if viewModel.randomAlbum != nil {
                    ForEach(viewModel.randomAlbum) { album in
                        let album = AlbumItemModel(id: album.id!, name: album.name!, artist: album.artist!, genre: album.genre!, listens: album.listens, lastListened: album.lastListened!)
                        RecommendedAlbumItemView(viewModel: AlbumItemViewModel(albumItem: album))
                            .foregroundColor(Color("Cyan"))
                    }

                }
                Spacer()
                if viewModel.albums.count >= 7 {
                    RRButton(title: "Weekly Records", background: Color("Cyan"), action: {
                        CoreDataManager.shared.weeklyRecommendation()
                        viewModel.weeklyAlbums = CoreDataManager.shared.loadWeek()
                    })
                    ForEach(viewModel.weeklyAlbums, id: \.id) { album in
                        AlbumItemView(viewModel: AlbumItemViewModel(albumItem: album))
                    }
                    .foregroundStyle(Color("Cyan"))
                    .padding()

                } else {
                    Text("Add at least seven records to get recommendations!")
                        .padding()
                        .foregroundStyle(Color("Cyan"))
                }
            }
        }
    }
}

#Preview {
    RecommendationsView(firstName: "")
}

