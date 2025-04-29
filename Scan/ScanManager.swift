//
//  ScanManager.swift
//  Next
//
//  Created by Robert on 29/04/2025.
//


import Foundation
import PDFKit

struct ScanManager {
    static func scansFolder() -> URL {
        let folder = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
            .appendingPathComponent("Scans")
        if !FileManager.default.fileExists(atPath: folder.path) {
            try? FileManager.default.createDirectory(at: folder, withIntermediateDirectories: true)
        }
        return folder
    }

    static func save(pdf: PDFDocument) -> URL {
        let filename = "Scan-\(UUID().uuidString.prefix(8)).pdf"
        let url = scansFolder().appendingPathComponent(filename)
        pdf.write(to: url)
        return url
    }

    static func listScans() -> [URL] {
        let folder = scansFolder()
        let files = (try? FileManager.default.contentsOfDirectory(at: folder, includingPropertiesForKeys: nil)) ?? []
        return files.filter { $0.pathExtension.lowercased() == "pdf" }.sorted { $0.lastPathComponent > $1.lastPathComponent }
    }
}