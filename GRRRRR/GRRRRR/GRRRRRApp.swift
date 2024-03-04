//
//  GRRRRRApp.swift
//  GRRRRR
//
//  Created by Phillip Johnson on 2/7/24.
//

import SwiftUI

@main
struct GRRRRRApp: App {
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
