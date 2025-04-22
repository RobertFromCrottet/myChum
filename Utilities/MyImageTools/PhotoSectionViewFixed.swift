import SwiftUI
import PhotosUI

struct PhotoSectionViewFixed: View {
    @Binding var point: MyPoint
    @State private var selectedItems: [PhotosPickerItem] = []
    @State private var showDeleteAllAlert = false
    @State private var showDeleteOneAlert = false
    @State private var imageCache: [Int: UIImage] = [:]

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
//            Text("📁 Galerie du point")
//                .font(.caption)
//                .bold()

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
                                        .scaledToFill()
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

            // Actions
            HStack(spacing: 12) {
                PhotosPicker(
                    selection: $selectedItems,
                    matching: .images,
                    label: {
                        Label("Ajouter des photos", systemImage: "photo")
                    }
                )

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
            .alert("Supprimer la photo principale ?", isPresented: $showDeleteOneAlert) {
                Button("Supprimer", role: .destructive) {
                    if let current = point.image {
                        // 1. Supprimer l’image du tableau si elle existe
                        if let index = point.images.firstIndex(of: current) {
                            point.images.remove(at: index)
                        }
                        // 2. Supprimer aussi la miniature
                        point.image = nil

                        // 3. Vider le cache pour forcer le refresh
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                            imageCache = [:]
                        }
                    }
                }
                Button("Annuler", role: .cancel) { }
            }
            .alert("Supprimer toutes les photos ?", isPresented: $showDeleteAllAlert) {
                Button("Tout supprimer", role: .destructive) {
                    withAnimation {
                        point.images = []
                        point.image = nil
                    }
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                        imageCache = [:]
                    }
                }
                Button("Annuler", role: .cancel) { }
            }
        }
        // 🔁 Quand une nouvelle image est sélectionnée
        .onChange(of: selectedItems) { newItems in
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
        // 🧼 En cas de suppression manuelle
        .onChange(of: point.image) { _ in
            imageCache = [:]
        }
    }

    // 🧩 Vue réutilisable pour une image dans la galerie
    @ViewBuilder
    func imageView(_ uiImage: UIImage, index: Int, isMainImage: Bool) -> some View {
        VStack {
            Image(uiImage: uiImage)
                .resizable()
                .scaledToFill()
                .frame(width: 120, height: 90)
                .clipped()
                .cornerRadius(8)
                .onTapGesture {
                    point.image = point.images[index]
                }

            if isMainImage {
                Text("Image principale")
                    .font(.caption2)
                    .foregroundColor(.green)
            }
        }
    }
}
