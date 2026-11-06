//
//  MediaImportService.swift
//  utui
//
//  Created by Leonid  on 05.11.26.
//

import AVFoundation
import Foundation
import UIKit

@MainActor
struct MediaImportService {

  func importFiles(_ urls: [URL]) async throws -> [MediaItem] {
    var items: [MediaItem] = []

    for url in urls {
      let accessing = url.startAccessingSecurityScopedResource()

      defer {
        if accessing {
          url.stopAccessingSecurityScopedResource()
        }
      }

      let item = try await makeMediaItem(from: url)
      items.append(item)
    }

    return items
  }

  func importVideo(from url: URL) async throws -> MediaItem {
    let directory = FileManager.default.urls(
      for: .applicationSupportDirectory,
      in: .userDomainMask
    )[0].appendingPathComponent("ImportedMedia", isDirectory: true)

    try FileManager.default.createDirectory(
      at: directory,
      withIntermediateDirectories: true
    )

    let destination =
      directory
      .appendingPathComponent(UUID().uuidString)
      .appendingPathExtension(url.pathExtension)

    try FileManager.default.moveItem(
      at: url,
      to: destination
    )

    return try await makeMediaItem(from: destination)
  }

  private func makeMediaItem(from url: URL) async throws -> MediaItem {
    let asset = AVURLAsset(url: url)

    let duration = try await asset.load(.duration)
    let seconds =
      duration.seconds.isFinite
      ? max(0, duration.seconds)
      : 0

    let videoTracks = try await asset.loadTracks(
      withMediaType: .video
    )

    let type: MediaType = videoTracks.isEmpty ? .audio : .video

    var thumbnail: Data?

    if type == .video {
      let generator = AVAssetImageGenerator(asset: asset)
      generator.appliesPreferredTrackTransform = true
      generator.maximumSize = CGSize(width: 320, height: 320)

      let time = CMTime(
        seconds: min(1, seconds / 2),
        preferredTimescale: 600
      )

      if let result = try? await generator.image(at: time) {
        thumbnail = UIImage(cgImage: result.image)
          .jpegData(compressionQuality: 0.75)
      }
    }

    return MediaItem(
      name: url.lastPathComponent,
      bookmark: try url.bookmarkData(),
      duration: seconds,
      thumbnail: thumbnail,
      type: type,
    )
  }
}
