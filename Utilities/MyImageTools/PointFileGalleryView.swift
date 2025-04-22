//
//  PointFileGalleryView.swift
//  Next
//
//  Created by Robert on 10/04/2025.
//


import SwiftUI


struct PointFileGalleryView: View {
    let uuid: UUID
    @State private var images: [URL] = []
    @State private var selectedImageURL: URL? = nil
    @State private var showPreview = false

    var body: some View {
        VStack(alignment: .leading) {
            if images.isEmpty {
                Text("Aucune photo enregistrée")
                    .font(.caption)
                    .foregroundColor(.secondary)
            } else {
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 10) {
                        ForEach(images, id: \.self) { url in
                            if let data = try? Data(contentsOf: url),
                               let uiImage = UIImage(data: data) {
                                Image(uiImage: uiImage)
                                    .resizable()
                                    .scaledToFill()
                                    .frame(width: 120, height: 90)
                                    .clipped()
                                    .cornerRadius(10)
                                    .shadow(radius: 2)
                                    .onTapGesture {
                                        selectedImageURL = url
                                        showPreview = true
                                    }
                            }
                        }
                    } //hstack
                    Text("\(images.count) photo(s)")
                        .font(.caption2)
                        .foregroundColor(.secondary)
                        .padding(.leading)
                    .padding(.horizontal)
                }
            }
        }
        .onAppear {
            loadImageURLs()
        }
        .sheet(isPresented: $showPreview) {
            if let url = selectedImageURL,
               let data = try? Data(contentsOf: url),
               let image = UIImage(data: data) {
                VStack {
                    Image(uiImage: image)
                        .resizable()
                        .scaledToFit()
                        .padding()

                    HStack {
                        Button("🗑 Supprimer") {
                            try? FileManager.default.removeItem(at: url)
                            loadImageURLs()
                            showPreview = false
                        }
                        .foregroundColor(.red)

                        Spacer()

                        ShareLink(item: url) {
                            Label("Partager", systemImage: "square.and.arrow.up")
                        }
                    }
                    .padding()
                }
                .presentationDetents([.medium, .large])
            }
        }
    }

    private func loadImageURLs() {
        let folderURL = FileManager.default
            .urls(for: .documentDirectory, in: .userDomainMask)[0]
            .appendingPathComponent("Photos")
            .appendingPathComponent(uuid.uuidString)

        if let files = try? FileManager.default.contentsOfDirectory(at: folderURL, includingPropertiesForKeys: nil) {
            images = files.sorted(by: { $0.lastPathComponent < $1.lastPathComponent })
        }
    }
}
