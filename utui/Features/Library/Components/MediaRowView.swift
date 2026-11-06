//
//  MediaRowView.swift
//  utui
//
//  Created by Leonid  on 06.11.26.
//

import SwiftUI

struct MediaRowView: View {
  let item: MediaItem

  var body: some View {
    HStack(spacing: 12) {
      thumbnail

      VStack(alignment: .leading, spacing: 6) {
        Text(item.name)
          .font(.headline)
          .lineLimit(2)

        Label(
          durationText,
          systemImage: item.type.systemImage,
        )
        .font(.subheadline)
        .foregroundStyle(.secondary)
      }

      Spacer()
    }
    .padding(.vertical, 4)
  }

  @ViewBuilder
  private var thumbnail: some View {
    Group {
      if let data = item.thumbnail,
        let image = UIImage(data: data)
      {
        Image(uiImage: image)
          .resizable()
          .scaledToFill()
      } else {
        Image(systemName: item.type.systemImage)
          .font(.title)
          .foregroundStyle(.secondary)
          .frame(maxWidth: .infinity, maxHeight: .infinity)
          .background(.quaternary)
      }
    }
    .frame(width: 100, height: 64)
    .clipped()
    .clipShape(RoundedRectangle(cornerRadius: 8))
    .accessibilityHidden(true)
  }

  private var durationText: String {
    let seconds = Int(item.duration)
    let hours = seconds / 3600
    let minutes = (seconds % 3600) / 60
    let remainingSeconds = seconds % 60

    if hours > 0 {
      return String(
        format: "%d:%02d:%02d",
        hours, minutes, remainingSeconds
      )
    }

    return String(
      format: "%d:%02d",
      minutes, remainingSeconds
    )
  }
}
