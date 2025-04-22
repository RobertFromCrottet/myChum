//
//  SubfolderImagesView.swift
//  Next
//
//  Created by Robert on 12/04/2025.
//

import SwiftUI

struct SubfolderImagesView: View {
    let subfolderURL: URL
    
    @State private var imageFiles: [URL] = []

    var body: some View {
        List(imageFiles, id: \.self) { url in
            HStack {
                if let uiImage = UIImage(contentsOfFile: url.path) {
                    Image(uiImage: uiImage)
                        .resizable()
                        .scaledToFill()
                        .frame(width: 60, height: 60)
                        .clipShape(RoundedRectangle(cornerRadius: 8))
                }

                Text(url.lastPathComponent)
                    .font(.subheadline)
            }
        }
        .navigationTitle("Images")
        .onAppear {
            loadImageFiles()
        }
    }

    func loadImageFiles() {
        do {
            let contents = try FileManager.default.contentsOfDirectory(at: subfolderURL, includingPropertiesForKeys: nil)
            imageFiles = contents.filter { $0.pathExtension.lowercased() == "jpg" || $0.pathExtension.lowercased() == "jpeg" }
        } catch {
            print("❌ Erreur chargement : \(error.localizedDescription)")
        }
    }
}
//import SwiftUI
//
//struct SubfolderImagesView: View {
//    let subfolderURL: URL
//    @State private var imageFiles: [URL] = []
//
//    var body: some View {
//        List(imageFiles, id: \.self) { url in
//            HStack {
//                if let uiImage = UIImage(contentsOfFile: url.path) {
//                    Image(uiImage: uiImage)
//                        .resizable()
//                        .frame(width: 50, height: 50)
//                        .clipShape(RoundedRectangle(cornerRadius: 8))
//                }
//
//                Text(url.lastPathComponent)
//            }
//        }
//        .navigationTitle(subfolderURL.lastPathComponent)
//        .onAppear {
//            let testImageURL = subfolderURL.appendingPathComponent("sample.jpg")
//            if !FileManager.default.fileExists(atPath: testImageURL.path) {
//                createTestImage(at: testImageURL)
//            }
//            loadImageFiles()
//        }
//    }
//
//    func loadImageFiles() {
//        do {
//            let contents = try FileManager.default.contentsOfDirectory(at: subfolderURL, includingPropertiesForKeys: nil)
//            print("📂 Contenu de \(subfolderURL.lastPathComponent):")
//            contents.forEach { print("  - \($0.lastPathComponent)") }
//
//            imageFiles = contents.filter { $0.pathExtension.lowercased() == "jpg" || $0.pathExtension.lowercased() == "jpeg" }
//        } catch {
//            print("❌ Erreur en listant les fichiers images : \(error.localizedDescription)")
//        }
//    }
//    func createTestImage(at url: URL) {
//        if let image = UIImage(systemName: "leaf.fill")?
//            .withTintColor(.systemGreen, renderingMode: .alwaysOriginal),
//           let data = image.jpegData(compressionQuality: 0.8) {
//            do {
//                try data.write(to: url)
//                print("🌿 Image test écrite dans : \(url.lastPathComponent)")
//            } catch {
//                print("❌ Erreur écriture image : \(error.localizedDescription)")
//            }
//        }
//    }
//}
