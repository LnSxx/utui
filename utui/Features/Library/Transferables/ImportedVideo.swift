//
//  ImportedVideo.swift
//  utui
//
//  Created by Leonid  on 05.11.26.
//


import CoreTransferable
import UniformTypeIdentifiers

struct ImportedVideo: Transferable {
    let url: URL
    
    static var transferRepresentation: some TransferRepresentation {
        FileRepresentation(
            importedContentType: .movie
        ) { received in
            let destination = FileManager.default.temporaryDirectory
                .appendingPathComponent(UUID().uuidString)
                .appendingPathExtension(
                    received.file.pathExtension.isEmpty
                    ? "mov"
                    : received.file.pathExtension
                )
            
            try FileManager.default.copyItem(
                at: received.file,
                to: destination
            )
            
            return ImportedVideo(url: destination)
        }
    }
}
