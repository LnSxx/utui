//
//  LibraryViewModel.swift
//  utui
//
//  Created by Leonid  on 05.11.26.
//

import Foundation
import Observation
import PhotosUI
import _PhotosUI_SwiftUI

@MainActor
@Observable
final class LibraryViewModel {
    var mediaItems: [MediaItem] = []
    var errorMessage: String?

    private let importService = MediaImportService()

    func importFiles(_ urls: [URL]) {
        do {
            let items = try importService.importFiles(urls)
            mediaItems.append(contentsOf: items)
        } catch {
            errorMessage = error.localizedDescription
        }
    }

    func importPhoto(_ photo: PhotosPickerItem?) async {
        guard let photo else { return }

        do {
            guard let video = try await photo.loadTransferable(
                type: ImportedVideo.self
            ) else {
                return
            }

            let item = try importService.importVideo(
                from: video.url
            )

            mediaItems.append(item)
        } catch {
            errorMessage = error.localizedDescription
        }
    }
}
