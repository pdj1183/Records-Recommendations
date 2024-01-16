//
//  MainView.swift
//  R&R iOS
//
//  Created by Phillip Johnson on 12/30/23.
//

import SwiftUI

struct MainView: View {
    @EnvironmentObject private var cloudModel: CloudModel
    @StateObject var viewModel = MainViewModel()
    
    @AppStorage("userId") var userId: String = ""
    
    private var isSignedIn: Bool {
        !self.userId.isEmpty
    }
    
    var body: some View {
        if isSignedIn {
            // signed in
            TabView{
                AlbumListView(userId: self.userId)
                    .tabItem {
                        Label("Collection", systemImage: "waveform.circle")
                    }
                RecomendationsView()
                    .tabItem {
                        Label("Recomendations", systemImage: "house")
                    }
                ProfileView()
                    .tabItem {
                        Label("Profile", systemImage: "person.circle")
                    }
                    
            }
            .task {
                do {
                    try await cloudModel.populateAlbums()
                    try await cloudModel.loadRecommendations()
                    cloudModel.randomRecommendation()
                } catch {
                    print(error)
                }
            }
        } else {
            LoginView()
        }
        
    }
}

#Preview {
    MainView(userId: "a").environmentObject(CloudModel())
}
