//
//  BlankApp.swift
//  Blank
//
//  Created by Phillip Johnson on 1/7/24.
//

import SwiftUI

@main
struct BlankApp: App {
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
