//
//  ProfileView.swift
//  R&R
//
//  Created by Phillip Johnson on 2/6/24.
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

