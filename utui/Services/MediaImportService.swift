//
//  MediaImportService.swift
//  utui
//
//  Created by Leonid  on 05.11.26.
//

import Foundation

struct MediaImportService {

  func importFiles(_ urls: [URL]) throws -> [MediaItem] {
    try urls.map { url in
      let accessing = url.startAccessingSecurityScopedResource()

      defer {
        if accessing {
          url.stopAccessingSecurityScopedResource()
        }
      }

      let bookmark = try url.bookmarkData()

      return MediaItem(
        name: url.lastPathComponent,
        bookmark: bookmark
      )
    }
  }

  func importVideo(from url: URL) throws -> MediaItem {
    let directory = FileManager.default.urls(
      for: .documentDirectory,
      in: .userDomainMask
    )[0]

    let destination =
      directory
      .appendingPathComponent(UUID().uuidString)
      .appendingPathExtension(url.pathExtension)

    try FileManager.default.moveItem(
      at: url,
      to: destination
    )

    let bookmark = try destination.bookmarkData()

    return MediaItem(
      name: destination.lastPathComponent,
      bookmark: bookmark
    )
  }
}
