//
//  MainView.swift
//  R&R
//
//  Created by Phillip Johnson on 2/6/24.
//

import SwiftUI

struct MainView: View {
    @StateObject var viewModel = MainViewModel()
    @StateObject var albumsModel = AlbumListViewModel()
    
    @AppStorage("userId") var userId: String = ""
    
    private var isSignedIn: Bool {
        !self.userId.isEmpty
    }
   
    var body: some View {
        if isSignedIn {
            // signed in
            if #available(iOS 26.0, *) {
                TabView {
                    Tab("Collection", systemImage: "waveform.circle") {
                        AlbumListView(userId: self.userId)
                            .environmentObject(albumsModel)
                            .onAppear { albumsModel.fetchAlbums() }
                    }
                    Tab("Recommendations", systemImage: "house") {
                        RecommendationsView()
                            .environmentObject(albumsModel)
                            .onAppear {
                                albumsModel.getRandom()
                                albumsModel.getWeek()
                            }
                    }
                    Tab("Profile", systemImage: "person.circle") {
                        ProfileView()
                            .environmentObject(albumsModel)
                            .onAppear {
                                albumsModel.getFavGenre()
                                albumsModel.getMostListend()
                                albumsModel.getOldestListened()
                            }
                    }
                }
                .tabBarMinimizeBehavior(.onScrollDown)
            } else {
                TabView {
                    AlbumListView(userId: self.userId)
                        .environmentObject(albumsModel)
                        .onAppear { albumsModel.fetchAlbums() }
                        .tabItem {
                            Label("Collection", systemImage: "waveform.circle")
                        }
                    RecommendationsView()
                        .environmentObject(albumsModel)
                        .onAppear {
                            albumsModel.getRandom()
                            albumsModel.getWeek()
                        }
                        .tabItem {
                            Label("Recommendations", systemImage: "house")
                        }
                    ProfileView()
                        .environmentObject(albumsModel)
                        .onAppear {
                            albumsModel.getFavGenre()
                            albumsModel.getMostListend()
                            albumsModel.getOldestListened()
                        }
                        .tabItem {
                            Label("Profile", systemImage: "person.circle")
                        }
                }
            }
        } else {
            LoginView()
        }
        
    }
}

#Preview {
    MainView(userId: "a").environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
}

