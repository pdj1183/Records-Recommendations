//
//  HeaderVeiw.swift
//  R&R iOS
//
//  Created by Phillip Johnson on 12/30/23.
//

import SwiftUI

struct HeaderVeiw: View {
    var subTitle: String
    var color: Color
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 75)
                .foregroundStyle(color)
                .rotationEffect(Angle(degrees: 15))
                .offset(y:-55)
                
            VStack{
                Text("R&R")
                    .font(Font.custom("Amoitar", fixedSize: 50))
                    .foregroundStyle(.white)
                Text(subTitle)
                    .font(Font.custom("Cochin", fixedSize: 32))
                    .foregroundStyle(.white)

                    
            }
        }
        .frame(width: UIScreen.main.bounds.width * 1.25, height: 300)
        .offset(y: -270)
    }
}

#Preview {
    HeaderVeiw(subTitle: "Login", color: .pink)
}
