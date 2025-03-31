////
////  LocalisationView.swift
////  Horizon
////
////  Created by Robert on 29/03/2025.
////
//
////import SwiftUI
////
////struct LocalisationView: View {
////    var body: some View {
////        Text(/*@START_MENU_TOKEN@*/"Hello, World!"/*@END_MENU_TOKEN@*/)
////    }
////}
////
////#Preview {
////    LocalisationView()
////}
//// LieuFormView.swift
//// Horizon
//
//import SwiftUI
//import SwiftData
//
//struct LocalisationView: View {
//    
//    // MARK: -  for navigation
//    let id: Int
//    @Binding var path: NavigationPath
//    
//    @Environment(\.dismiss) private var dismiss
//    @Environment(\.modelContext) private var context
//
//    @State private var nom = ""
//    @State private var latitude = ""
//    @State private var longitude = ""
//    @State private var textDescription = ""
//    
//    var body: some View {
//        NavigationStack {
//            Form {
//                Section(header: Text("Informations")) {
//                    TextField("Nom", text: $nom)
//                    Group {
//                        TextField("Latitude", text: $latitude)
//                            .keyboardType(.decimalPad)
//                    }
//                    TextField("Longitude", text: $longitude)
//                        .keyboardType(.decimalPad)
//                    TextField("Description", text: $textDescription)
//                }
//                Section {
//                    Button("Enregistrer") {
//                        saveLocalisation()
//                    }
//                    .disabled(nom.isEmpty || latitude.isEmpty || longitude.isEmpty)
//                }
//            }
//            .navigationTitle("Nouveau lieu")
//            .toolbar {
//                ToolbarItem(placement: .cancellationAction) {
//                    Button("Annuler") {
//                        dismiss()
//                    }
//                }
//            }
//        }
//    }
//
//    private func saveLocalisation() {
//        guard let lat = Double(latitude),
//              let lon = Double(longitude) else { return }
//
//        let lieu = Lieu(nom: nom, latitude: lat, longitude: lon, description: textDescription)
//        context.insert(lieu)
//
//        dismiss()
//    }
//}
//
//#Preview {
//    StatefulPreviewWrapper(NavigationPath()) { path in
//        LocalisationView(id: 4, path: path)
//    }
//}
