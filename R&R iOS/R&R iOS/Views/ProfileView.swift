//
//  ProfileView.swift
//  R&R iOS
//
//  Created by Phillip Johnson on 12/30/23.
//

import SwiftUI

struct ProfileView: View {
    @StateObject var viewModel = ProfileViewModel()
    
    init () {
        
    }
    var body: some View {
        NavigationView {
           HeaderVeiw(subTitle: "Profile", color: Color("Orange"))
                .offset(y: -27)
            VStack{}
                .toolbar{
                    
                }
                .padding()
            
                
        }
    }
}

#Preview {
    ProfileView()
}
