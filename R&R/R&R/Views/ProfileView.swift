//
//  ProfileView.swift
//  R&R
//
//  Created by Phillip Johnson on 2/6/24.
//

import SwiftUI
import Charts

struct ProfileView: View {
    @EnvironmentObject var viewModel: AlbumListViewModel
    init () {
        
    }
    var body: some View {
        NavigationStack {
            HeaderVeiw(subTitle: "Profile", color: Color("Orange"))
                .offset(y: 179)
                .padding(.bottom, -101)
            List{
                    Section(header: Text("")){
                        HStack{
                            Spacer()
                            Text("Your Favorite Record")
                                .font(Font.custom("Cochin", fixedSize: 26))
                                .foregroundStyle(Color("Orange"))
                                .multilineTextAlignment(.center)
                                .bold()
                                .padding()
                                .underline()
                            Spacer()
                        }
                        ForEach(viewModel.mostListened) { album in
                            let album = AlbumItemModel(id: album.id!, name: album.name!, artist: album.artist!, genre: album.genre!, listens: album.listens, lastListened: album.lastListened!)
                            AlbumItemView(viewModel: AlbumItemViewModel(albumItem: album), color: Color("Orange"))
                                .foregroundColor(Color("Orange"))
                        }
                        .padding()
                    }
                    .listRowSeparator(.hidden)

                    Section(header: Text("")){
                        HStack{
                            Spacer()
                            Text("It's Been a While")
                                .font(Font.custom("Cochin", fixedSize: 26))
                                .foregroundStyle(Color("Orange"))
                                .multilineTextAlignment(.center)
                                .bold()
                                .padding()
                                .underline()
                            Spacer()
                        }
                        ForEach(viewModel.oldestListened) { album in
                            let album = AlbumItemModel(id: album.id!, name: album.name!, artist: album.artist!, genre: album.genre!, listens: album.listens, lastListened: album.lastListened!)
                            AlbumItemView(viewModel: AlbumItemViewModel(albumItem: album), color: Color("Orange"))
                                .foregroundColor(Color("Orange"))
                        }
                        .padding()
                    }
                    .listRowSeparator(.hidden)

                    Section(header: Text("")) {
                        HStack{
                            Spacer()
                            Text("Your Genres")
                                .font(Font.custom("Cochin", fixedSize: 26))
                                .foregroundStyle(Color("Orange"))
                                .multilineTextAlignment(.center)
                                .bold()
                                .padding()
                                .underline()
                            Spacer()
                            
                        }
                        Chart(viewModel.genres, id: \.genre){ genre in
                            BarMark(
                                x: .value("Value", genre.listens),
                                y: .value("Key", genre.genre)
                            )
                            .foregroundStyle(genre.color)
                            
                        }
                        .frame(height: CGFloat(viewModel.genres.count) * 50)
                        .padding()
                    }
                    .listRowSeparator(.hidden)

                
            }
        }
        .toolbar {
            
        }
        .onAppear {
            viewModel.getFavGenre()
            viewModel.getMostListend()
        }
    }
}

#Preview {
    ProfileView()
        .environmentObject(AlbumListViewModel())
}

