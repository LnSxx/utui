//
//  MediaType.swift
//  utui
//
//  Created by Leonid  on 06.11.26.
//

enum MediaType: String, Codable {
  case audio
  case video

  var systemImage: String {
    switch self {
    case .audio: "music.note"
    case .video: "video"
    }
  }
}
