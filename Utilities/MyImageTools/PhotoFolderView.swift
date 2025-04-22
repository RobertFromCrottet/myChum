//
//  PhotoFolderView.swift
//  Next
//
//  Created by Robert on 12/04/2025.
//


import SwiftUI
import SwiftData
import class Next.MyPoint

struct PhotoFolderView: View {
    let folderURL: URL
    
    @State private var subfolderNames: [String] = []
    @Query var points: [MyPoint]
 
    var body: some View {
        NavigationView {
            List(points) { point in
//                NavigationLink(
//                    destination: SubfolderImagesView(
//                        subfolderURL: AppPaths.photosFolder.appendingPathComponent(point.id.uuidString)
//                    )
//                ) {
                NavigationLink(destination: SubfolderImagesView(subfolderURL: point.photosFolderURL)) {
            
               
                    VStack(alignment: .leading) {
                        Text(point.name.isEmpty ? "Sans nom" : point.name)
                            .font(.headline)

                        Text(point.id.uuidString)
                            .font(.footnote)
                            .foregroundColor(.secondary)
                    }
                }
            }
        }
//            List(points) { point in
//                let folder = AppPaths.photosFolder.appendingPathComponent(point.id.uuidString)
//
//                NavigationLink(destination: SubfolderImagesView(subfolderURL: folder)) {
//                    VStack(alignment: .leading) {
//                        Text(point.name.isEmpty ? "Sans nom" : point.name)
//                            .font(.headline)
//
//                        Text(point.id.uuidString)
//                            .font(.footnote)
//                            .foregroundColor(.secondary)
//                    }
//                }
//            }
            .navigationTitle("Photos par point")
        }
    
    func createTestSubfoldersIfNeeded() {
        let fm = FileManager.default

        if !fm.fileExists(atPath: folderURL.path) {
            do {
                try fm.createDirectory(at: folderURL, withIntermediateDirectories: true)
                print("📁 Dossier Photos créé à : \(folderURL.path)")
            } catch {
                print("❌ Erreur création dossier Photos : \(error.localizedDescription)")
                return
            }
        }

        // Ajout de 3 sous-dossiers de test
        for i in 1...3 {
            let testFolder = folderURL.appendingPathComponent("UUID-Test-\(i)")
            if !fm.fileExists(atPath: testFolder.path) {
                do {
                    try fm.createDirectory(at: testFolder, withIntermediateDirectories: true)
                    print("📂 Sous-dossier créé : \(testFolder.lastPathComponent)")
                    createDummyImage(named: "sample", in: testFolder)
                } catch {
                    print("❌ Erreur création sous-dossier : \(error.localizedDescription)")
                }
            }
        }
    }

//    func loadSubfolders() {
//        do {
//            let contents = try FileManager.default.contentsOfDirectory(at: folderURL, includingPropertiesForKeys: nil)
//            
//            let folders = contents.filter { url in
//                url.hasDirectoryPath && UUID(uuidString: url.lastPathComponent) != nil
//            }
//
//            subfolderNames = folders.map { $0.lastPathComponent }
//            print("📁 Dossiers UUID trouvés : \(subfolderNames)")
//        } catch {
//            print("❌ Erreur lecture dossiers : \(error.localizedDescription)")
//        }
//    }
    func createDummyImage(named name: String, in folder: URL) {
        // Crée une image SwiftUI simple
        let image = UIImage(systemName: "leaf.fill")?
            .withTintColor(.systemGreen, renderingMode: .alwaysOriginal)

        guard let data = image?.jpegData(compressionQuality: 0.8) else {
            print("❌ Impossible de créer les données image")
            return
        }

        let imageURL = folder.appendingPathComponent("\(name).jpg")

        do {
            try data.write(to: imageURL)
            print("🖼️ Image test créée : \(imageURL.lastPathComponent)")
        } catch {
            print("❌ Erreur écriture image : \(error.localizedDescription)")
        }
    }
}
