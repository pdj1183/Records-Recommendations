//
//  R_RApp.swift
//  R&R
//
//  Created by Phillip Johnson on 2/6/24.
//

import SwiftUI

@main
struct R_RApp: App {
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            MainView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
