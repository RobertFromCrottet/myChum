//
//  LoadPointsView.swift
//  Next
//
//  Created by Robert on 09/04/2025.
//

import SwiftUI
import SwiftData

struct LoadPointsView: View {
    @Environment(\.modelContext) private var context
    @State private var status = "En attente..."

    var body: some View {
        
        VStack(spacing: 20) {
            Text("📍 Importation des points de France")
                .font(.headline)
         

            Button("📥 Charger les 2500 points") {
                importPoints()
                if let bundleRoot = Bundle.main.resourceURL {
                    let jsonFolderURL = bundleRoot.appendingPathComponent("ImportJson")
                    let fm = FileManager.default

                    if let files = try? fm.contentsOfDirectory(at: jsonFolderURL, includingPropertiesForKeys: nil) {
                        print("📂 Contenu de ImportJson :")
                        for file in files {
                            print("   → \(file.lastPathComponent)")
                        }
                    } else {
                        print("❓ Impossible de lire le contenu de ImportJson")
                    }
                }
            }
            .buttonStyle(.borderedProminent)

            Text(status)
                .font(.caption)
                .foregroundColor(.secondary)
        }
        
        .padding()
    }

    func importPoints() {
        guard let url = Bundle.main.url(forResource: "points_france", withExtension: "json", subdirectory: "ImportJson") else {
            status = "❌ Fichier non trouvé:"
            print("❌ Fichier JSON encore introuvable")
            let resource = "points_france"
            let subdir = "ImportJson"

            if let url = Bundle.main.url(forResource: resource, withExtension: "json", subdirectory: subdir) {
                print("📦 Fichier trouvé : \(url.path)")
            } else {
                print("❌ Fichier '\(resource).json' introuvable dans le dossier '\(subdir)' du bundle.")
                
                // Tentative de debug : affiche les fichiers disponibles dans le bundle
                if let resourcePath = Bundle.main.resourcePath {
                    print("📁 Bundle path : \(resourcePath)")
                    let fileManager = FileManager.default
                    let files = try? fileManager.contentsOfDirectory(atPath: resourcePath)
                    print("📄 Fichiers dans le bundle : \(files ?? [])")
                }
                if let jsonFolderURL = Bundle.main.url(forResource: subdir, withExtension: nil) {
                    let fm = FileManager.default
                    if let files = try? fm.contentsOfDirectory(at: jsonFolderURL, includingPropertiesForKeys: nil) {
                        print("📂 Contenu de ImportJson :")
                        for file in files {
                            print("   → \(file.lastPathComponent)")
                        }
                    } else {
                        print("❓ Impossible de lire le contenu de ImportJson")
                    }
                }
            }
            return
            
        }

        print("📁 Fichier JSON trouvé : \(url.lastPathComponent)")

        guard let data = try? Data(contentsOf: url) else {
            status = "❌ Impossible de lire les données"
            print("❌ Erreur lors de la lecture du fichier")
            return
        }

        print("📦 Données chargées (\(data.count) octets)")

        guard let decoded = try? JSONDecoder().decode([MyPointDTO].self, from: data) else {
            status = "❌ Échec du décodage JSON"
            print("❌ Problème lors du décodage JSON")
            return
        }

        print("✅ \(decoded.count) points décodés")

        for dto in decoded {
            let point = MyPoint(
                name: dto.name,
                latitude: dto.latitude,
                longitude: dto.longitude,
                textDescription: "",
                icon: "mappin",
                image: nil,
                city: dto.city,
                country: dto.country,
                adresse: dto.adresse
            )
            context.insert(point)
        }

        status = "✅ \(decoded.count) points ajoutés"
    }
}

// DTO pour le décodage JSON
struct MyPointDTO: Codable {
    let name: String
    let latitude: Double
    let longitude: Double
    let city: String
    let country: String
    let adresse: String
}
