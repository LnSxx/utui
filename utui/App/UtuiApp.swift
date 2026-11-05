//
//  UtuiApp.swift
//  utui
//
//  Created by Leonid  on 03.11.26.
//

import SwiftUI
import CoreData

@main
struct UtuiApp: App {
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            RootView()
        }
    }
}
