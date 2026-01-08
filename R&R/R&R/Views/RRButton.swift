//
//  RRButton.swift
//  R&R
//
//  Created by Phillip Johnson on 2/6/24.
//

import SwiftUI

struct RRButton: View {
    let title: String
    let background: Color
    let action: () -> Void
    
    var body: some View {
        Button {
            action()
        } label: {
            ZStack {
                RoundedRectangle(cornerRadius: 12)
                    .foregroundStyle(background)
                
                Text(title)
                    .foregroundStyle(.white)
                    .bold()
                    .font(Font.custom("Cochin", fixedSize: 24))
                    .padding(.vertical, 12)
                    .padding(.horizontal, 16)
            }
        }
        .frame(height: 50)
    }
}

#Preview {
    RRButton(title: "value", background: .blue)
    {
        //Action
    }
}

