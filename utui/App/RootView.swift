//
//  RootView.swift
//  utui
//
//  Created by Leonid  on 05.11.26.
//

import SwiftUI

struct RootView: View {
  var body: some View {
    TabView {
      Tab("Library", systemImage: "photo.on.rectangle.angled") {
        NavigationStack {
          LibraryView()
        }
      }

      Tab("Settings", systemImage: "gearshape") {
        NavigationStack {
          SettingsView()
        }
      }
    }
  }
}

#Preview {
  RootView()
}
