//
//  R_R_iOS_AppApp.swift
//  R&R iOS App
//
//  Created by Phillip Johnson on 12/30/23.
//

import SwiftUI

@main
struct R_R_iOS_AppApp: App {
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
