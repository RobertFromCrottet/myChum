//
//  PhotoPickerView.swift
//  Horizon
//
//  Created by Robert on 02/04/2025.
//

import SwiftUI
import PhotosUI

struct PhotoPickerView: View {
    @Binding var images: [Data]
    @State private var selectedPhotos: [PhotosPickerItem] = []

    var body: some View {
        PhotosPicker(
            selection: $selectedPhotos,
            maxSelectionCount: 10,
            matching: .images,
            photoLibrary: .shared()
        ) {
            Label("Choisir des photos", systemImage: "photo.on.rectangle.angled")
        }
        .onChange(of: selectedPhotos) { newItems in
            print("🌀 PhotosPicker triggered avec \(newItems.count) élément(s)")

            for item in newItems {
                Task {
                    print("🎯 Tentative de chargement d’une image")
                    if let data = try? await item.loadTransferable(type: Data.self) {
                        images.append(data)
                        print("📸 Image ajoutée - total: \(images.count)")
                    } else {
                        print("❌ Erreur chargement image")
                    }
                }
            }
        }
    } //body
} // view
