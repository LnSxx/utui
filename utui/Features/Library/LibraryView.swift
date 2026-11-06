//
//  LibraryView.swift
//  utui
//
//  Created by Leonid  on 05.11.26.
//

import PhotosUI
import SwiftUI
import UniformTypeIdentifiers

struct LibraryView: View {
  @State private var viewModel = LibraryViewModel()

  @State private var showPhotos = false
  @State private var showFiles = false

  @State private var selectedPhoto: PhotosPickerItem?

  var body: some View {
    List {
      ForEach(viewModel.mediaItems) { item in
        MediaRowView(item: item)
      }
    }
    .overlay {
      if viewModel.mediaItems.isEmpty && !viewModel.isImporting {
        ContentUnavailableView(
          "No Media",
          systemImage: "play.rectangle",
          description: Text("Add videos or audio to get started.")
        )
      }

      if viewModel.isImporting {
        ProgressView("Importing media...")
      }
    }
    .navigationTitle("Library")
    .toolbar {
      ToolbarItem(placement: .primaryAction) {
        Menu {
          Button {
            showPhotos = true
          } label: {
            Label("Photos", systemImage: "photo")
          }

          Button {
            showFiles = true
          } label: {
            Label("Files", systemImage: "folder")
          }
        } label: {
          Image(systemName: "plus")
        }
      }
    }
    .fileImporter(
      isPresented: $showFiles,
      allowedContentTypes: [.movie, .audio],
      allowsMultipleSelection: true
    ) { result in
      switch result {
      case .success(let urls):
        Task {
          await viewModel.importFiles(urls)
        }

      case .failure(let error):
        viewModel.errorMessage = error.localizedDescription
      }
    }
    .photosPicker(
      isPresented: $showPhotos,
      selection: $selectedPhoto,
      matching: .videos
    )
    .onChange(of: selectedPhoto) { _, photo in
      Task {
        await viewModel.importPhoto(photo)
      }
    }
    .alert(
      "Import Failed",
      isPresented: Binding(
        get: { viewModel.errorMessage != nil },
        set: { if !$0 { viewModel.errorMessage = nil } }
      )
    ) {
      Button("OK", role: .cancel) {
        viewModel.errorMessage = nil
      }
    } message: {
      Text(viewModel.errorMessage ?? "")
    }
  }
}

#Preview {
  NavigationStack {
    LibraryView()
  }
}
