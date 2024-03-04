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
            TabView{
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
                        Label("Recomendations", systemImage: "house")
                    }
                ProfileView()
                    .tabItem {
                        Label("Profile", systemImage: "person.circle")
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

