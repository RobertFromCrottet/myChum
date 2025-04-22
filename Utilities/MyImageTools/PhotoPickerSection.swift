//
//  PhotoPickerSection.swift
//  Next
//
//  Created by Robert on 11/04/2025.
//
import SwiftUI
import PhotosUI

struct PhotoPickerSection: View {
    @Binding var images: [Data]
    @State private var selectedPhoto: PhotosPickerItem?
    @State private var showCamera = false

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            if let first = images.first, let uiImage = UIImage(data: first) {
                Image(uiImage: uiImage)
                    .resizable()
                    .scaledToFit()
                    .frame(height: 150)
                    .cornerRadius(10)
            }

            PhotosPicker(
                selection: $selectedPhoto,
                matching: .images,
                photoLibrary: .shared()
            ) {
                Label("Choisir une photo", systemImage: "photo")
            }
            .onChange(of: selectedPhoto) { newItem in
                Task {
                    if let data = try? await newItem?.loadTransferable(type: Data.self) {
                        images.append(data)
                    }
                }
            }

            Button {
                showCamera = true
            } label: {
                Label("⚡ Capter l'instant", systemImage: "camera.fill")
                    .padding()
                    .background(Color.red.opacity(0.1))
                    .clipShape(Capsule())
            }
        }
        .sheet(isPresented: $showCamera) {
            ImagePicker { data in
                images.append(data)
            }
        }
    }
}
