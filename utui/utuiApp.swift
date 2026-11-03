//
//  utuiApp.swift
//  utui
//
//  Created by Leonid  on 03.11.26.
//

import SwiftUI
import CoreData

@main
struct utuiApp: App {
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
