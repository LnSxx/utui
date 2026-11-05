//
//  MediaItem.swift
//  utui
//
//  Created by Leonid  on 05.11.26.
//

import Foundation

struct MediaItem: Identifiable {
    let id = UUID()
    let name: String
    let bookmark: Data
}
