//
//  PhotoStorageManager.swift
//  Next
//
//  Created by Robert on 10/04/2025.
//

#if os(iOS)
import Foundation
#if canImport(UIKit)
import UIKit
#endif

#if canImport(AppKit)
import AppKit
#endif

struct PhotoStorageManager {
    
    static private var baseFolder: URL {
        FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
            .appendingPathComponent("Photos")
    }

    static func saveImage(data: Data, for uuid: UUID) throws {
        let folderURL = baseFolder.appendingPathComponent(uuid.uuidString)
        try FileManager.default.createDirectory(at: folderURL, withIntermediateDirectories: true)
        
        let fileCount = try FileManager.default.contentsOfDirectory(at: folderURL, includingPropertiesForKeys: nil).count
        let filename = "photo_\(fileCount + 1).jpg"
        let fileURL = folderURL.appendingPathComponent(filename)

        try data.write(to: fileURL)
        print("📸 Image enregistrée pour point \(uuid) à : \(fileURL.lastPathComponent)")
    }

    static func getImages(for uuid: UUID) -> [UIImage] {
        let folderURL = baseFolder.appendingPathComponent(uuid.uuidString)
        let fileManager = FileManager.default
        guard let files = try? fileManager.contentsOfDirectory(at: folderURL, includingPropertiesForKeys: nil) else {
            return []
        }

        return files.compactMap { url in
            if let data = try? Data(contentsOf: url),
               let image = UIImage(data: data) {
                return image
            }
            return nil
        }
    }

    static func deleteImages(for uuid: UUID) {
        let folderURL = baseFolder.appendingPathComponent(uuid.uuidString)
        try? FileManager.default.removeItem(at: folderURL)
        print("🗑 Images supprimées pour le point \(uuid)")
    }
}
#endif
