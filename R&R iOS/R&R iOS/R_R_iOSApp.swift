//
//  R_R_iOSApp.swift
//  R&R iOS
//
//  Created by Phillip Johnson on 12/29/23.
//

import SwiftUI

@main
struct R_R_iOSApp: App {

    var body: some Scene {
        WindowGroup {
            MainView().environmentObject(CloudModel())
                .environment(\.font, Font.custom("Cochin", size: 16))
        }
    }
}
