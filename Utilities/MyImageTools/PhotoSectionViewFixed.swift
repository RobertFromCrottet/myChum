import SwiftUI
import PhotosUI

struct PhotoSectionViewFixed: View {
    @Binding var point: MyPoint
    @State private var selectedItems: [PhotosPickerItem] = []
    @State private var showDeleteAllAlert = false
    @State private var showDeleteOneAlert = false
    @State private var imageCache: [Int: UIImage] = [:]
    @State private var showCamera = false   // 👈 ajout

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            // Miniature principale
            if let imageData = point.image,
               let uiImage = UIImage(data: imageData) {
                Image(uiImage: uiImage)
                    .resizable()
                    .scaledToFit()
                    .cornerRadius(10)
                    .padding(.bottom)
            }

            // Galerie horizontale
            if !point.images.isEmpty {
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 10) {
                        ForEach(Array(point.images.enumerated()), id: \.offset) { offset, data in
                            let isMain = (point.image == data)

                            VStack {
                                if let uiImage = UIImage(data: data) {
                                    Image(uiImage: uiImage)
                                        .resizable()
                                        .scaledToFit()
                                        .frame(width: 120, height: 90)
                                        .clipped()
                                        .cornerRadius(8)
                                        .onTapGesture {
                                            point.image = data
                                        }

                                    if isMain {
                                        Text("Image principale")
                                            .font(.caption2)
                                            .foregroundColor(.green)
                                    }
                                }
                            }
                        }
                    }
                    .padding(.horizontal)
                }
            }

            // Actions boutons
            HStack(spacing: 12) {
                PhotosPicker(
                    selection: $selectedItems,
                    matching: .images,
                    label: {
                        Label("Ajouter des photos", systemImage: "photo")
                    }
                )

                Button {
                    showCamera = true
                } label: {
                    Label("Capter une photo", systemImage: "camera.fill")
                }
                .buttercup(color: .mint)

                Button("Effacer la photo sélectionnée") {
                    showDeleteOneAlert = true
                }
                .buttercup(color: .orange)

                Button("Tout effacer") {
                    showDeleteAllAlert = true
                }
                .buttercup(color: .red)
            }
            .padding(.horizontal)
        }

        // Import depuis PhotosPicker
        .onChange(of: selectedItems) { old, newItems in
            for item in newItems {
                Task {
                    if let data = try? await item.loadTransferable(type: Data.self) {
                        point.images.append(data)
                        if point.image == nil {
                            point.image = data
                        }
                    }
                }
            }
        }

        // Suppression manuelle
        .alert("Supprimer la photo principale ?", isPresented: $showDeleteOneAlert) {
            Button("Supprimer", role: .destructive) {
                if let current = point.image {
                    if let index = point.images.firstIndex(of: current) {
                        point.images.remove(at: index)
                    }
                    point.image = nil
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                        imageCache = [:]
                    }
                }
            }
            Button("Annuler", role: .cancel) {}
        }
        .alert("Supprimer toutes les photos ?", isPresented: $showDeleteAllAlert) {
            Button("Tout supprimer", role: .destructive) {
                withAnimation {
                    point.images = []
                    point.image = nil
                    imageCache = [:]
                }
            }
            Button("Annuler", role: .cancel) {}
        }

        // Appareil photo direct
        .sheet(isPresented: $showCamera) {
            ImagePicker { data in
                point.images.append(data)
                if point.image == nil {
                    point.image = data
                }
            }
        }
    }
}
