//
//  UtuiApp.swift
//  utui
//
//  Created by Leonid  on 03.11.26.
//

import CoreData
import SwiftUI

@main
struct UtuiApp: App {
  let persistenceController = PersistenceController.shared

  var body: some Scene {
    WindowGroup {
      RootView()
    }
  }
}
