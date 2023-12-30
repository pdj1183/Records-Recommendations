//
//  R_R_iOSApp.swift
//  R&R iOS
//
//  Created by Phillip Johnson on 12/29/23.
//

import SwiftUI

@main
struct R_R_iOSApp: App {
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
