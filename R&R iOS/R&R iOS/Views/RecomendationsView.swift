//
//  RecomendationsView.swift
//  R&R iOS
//
//  Created by Phillip Johnson on 1/6/24.
//

import SwiftUI

struct RecomendationsView: View {
    @EnvironmentObject private var cloudModel: CloudModel
    @AppStorage("first name") var firstName: String = ""

    var body: some View {
        NavigationStack {
            HeaderVeiw(subTitle: "Welcome Back \(self.firstName)!", color: Color("Cyan"))
                .offset(y: 178)
                .padding(.bottom, -102)
            List {
                RRButton(title: "Give Me A Record", background: Color("Cyan"), action: {
                    cloudModel.randomRecommendation()
                                })
                if cloudModel.randomAlbum != nil {
                    RecommendedAlbumItemView(index: 0, albumItem: cloudModel.randomAlbum!)
                        .foregroundStyle(Color("Cyan"))
                }
                Spacer()
                RRButton(title: "Weekly Records", background: Color("Cyan"), action: {
                    cloudModel.weeklyRecommendations()
                    print(cloudModel.weekRecommendations)
                })
                ForEach(0..<cloudModel.weekRecommendations.count, id: \.self) { index in
                                    if let albumItem = cloudModel.albumDictionary[cloudModel.weekRecommendations[index]] {
                                        RecommendedAlbumItemView(index: index, albumItem: albumItem)
                                            .foregroundStyle(Color("Cyan"))
                                    }
                                }
                .padding()
            }
        }
    }
}

#Preview {
    RecomendationsView()
}
