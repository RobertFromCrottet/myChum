
import SwiftUI
import PhotosUI
import SwiftData
import CoreLocation



struct AddPointView: View {
    @Environment(\.dismiss) private var dismiss
    @Environment(\.modelContext) private var modelContext

    var existingPoint: MyPoint? = nil
    
    @State private var name = ""
    @State private var latitude = ""
    @State private var longitude = ""
    @State private var textDescription = ""
    @State private var icon: String = ""
//    @State private var imageData: Data?
    @State private var images: [Data] = []
    @State private var city = ""
    @State private var country = ""
    @State private var adresse = ""
    @State private var showPhotoPicker = false
    @State private var selectedPhoto: PhotosPickerItem?
   
    @State private var selectedImageData: Data? = nil
    @State private var showCamera = false
    @FocusState private var isNameFocused: Bool
    @State private var selectedIcon: SFIcon = .mappin
    // Nouveau pour reverse geocoding
    @State private var showAddPointAlert = false
    @State private var pendingCoordinate: CLLocationCoordinate2D?
    @State private var suggestedName = ""
    @State private var suggestedCity = ""

    var body: some View {
        ZStack {
            Color(.systemGroupedBackground).ignoresSafeArea()
            
            VStack(spacing: 20) {
                Form {
                    Section(header: Text("Info")) {
                        TextField("Name", text: $name)
                            .focused($isNameFocused)
                        TextField("Latitude", text: $latitude)
                            .keyboardType(.numberPad)
                        TextField("Longitude", text: $longitude)
                            .keyboardType(.numberPad)
                        TextField("Adresse", text: $adresse)
                        TextField("City", text: $city)
                        TextField("Country", text: $country)
//                        TextField("Icon (SF Symbol)", text: $icon)
                        SymbolPickerView(selected: $selectedIcon)
                    }

                    Section(header: Text("Description")) {
                        TextEditor(text: $textDescription)
                            .frame(height: 100)
                    }

            //        Section(header: Text("Photo")) {

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
                            Label("Choose a Photo", systemImage: "photo")
                        }
                       
                        Button {
                            showCamera = true
                        } label: {
                            Label("⚡ Capter l'instant", systemImage: "camera.fill")
                                .padding()
                                .background(Color.red.opacity(0.1))
                                .clipShape(Capsule())
                        }
                        
                        .onChange(of: selectedPhoto) { newItem in
                            Task {
                                if let data = try? await newItem?.loadTransferable(type: Data.self) {
                                    images.append(data)
                                }
                            }
                        }
                        
                    }
                Section(header: Text("Photo")) {
                    PhotoPickerSection(images: $images)

                    Button("Save Point") {
                        savePoint()
                    }
                    .buttonStyle(.borderedProminent)
                    .frame(maxWidth: .infinity, alignment: .center)
                    .disabled(latitude.trimmingCharacters(in: .whitespaces).isEmpty ||
                              longitude.trimmingCharacters(in: .whitespaces).isEmpty ||
                              name.trimmingCharacters(in: .whitespaces).isEmpty)
                    .buttonStyle(.borderedProminent)
                    .frame(maxWidth: .infinity, alignment: .center)
                }
            }
        }
        .onAppear {
            isNameFocused = true
            if let existing = existingPoint {
                   name = existing.name
                   latitude = String(existing.latitude)
                   longitude = String(existing.longitude)
                   textDescription = existing.textDescription
                   selectedIcon = SFIcon(rawValue: existing.icon ?? "mappin") ?? .mappin
                   city = existing.city ?? ""
                   country = existing.country ?? ""
                    adresse = existing.adresse ?? ""
                   images = existing.images

// fallback si 'images' est vide, mais 'image' existe :
                   if images.isEmpty, let fallback = existing.image {
                       images = [fallback]
                   }
               }
        }
        .navigationTitle("Add View Point")
        .alert("Créer un point ?", isPresented: $showAddPointAlert) {
            Button("Oui") {
                if let coord = pendingCoordinate {
                    name = suggestedName
                    city = suggestedCity
                    latitude = String(format: "%.6f", coord.latitude)
                    longitude = String(format: "%.6f", coord.longitude)
                }
            }
            Button("Non", role: .cancel) {}
        } message: {
            Text("Souhaitez-vous créer un point \"\(suggestedName)\" à \(suggestedCity) ?")
        }
        .sheet(isPresented: $showCamera) {
//            ImagePicker(imageData: $imageData)
            ImagePicker { data in
                images.append(data)
            }
        }
    }  //body

    
    func savePoint() {
        guard let lat = Double(latitude), let lon = Double(longitude),
              !name.trimmingCharacters(in: .whitespaces).isEmpty else {
            print("❌ Coordonnées ou nom invalides")
            return
        }

        let newPoint = MyPoint(
            name: name,
            latitude: lat,
            longitude: lon,
            textDescription: textDescription,
            icon: selectedIcon.rawValue,
            image: images.first,   // image de preview
            city: city,
            country: country,
            adresse: adresse
        )

        modelContext.insert(newPoint)

        // 💾 Enregistrer les fichiers (photos multiples)
        for imgData in images {
            try? PhotoStorageManager.saveImage(data: imgData, for: newPoint.id)
        }

        print("📍 Point sauvegardé avec ID \(newPoint.id)")
        dismiss()
    }
    func handleDoubleTap(at coordinate: CLLocationCoordinate2D) {
        pendingCoordinate = coordinate
        let location = CLLocation(latitude: coordinate.latitude, longitude: coordinate.longitude)
        let geocoder = CLGeocoder()

        geocoder.reverseGeocodeLocation(location) { placemarks, error in
            if let placemark = placemarks?.first {
                suggestedName = placemark.name ?? "Lieu sans nom"
                suggestedCity = placemark.locality ?? "Inconnu"
            } else {
                suggestedName = "Lieu sans nom"
                suggestedCity = "Inconnu"
            }
            showAddPointAlert = true
        }
    }
}
