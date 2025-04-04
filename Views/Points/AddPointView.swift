//
//  AddPointView.swift
//  Horizon
//
//  Created by Robert on 30/03/2025.
//

import SwiftUI
import SwiftData

struct AddPointView: View {
    
    // MARK: -  for navigation
    let id: Int
    @Binding var path: NavigationPath
    @Bindable var point: MyPoint
    
    @Environment(\.dismiss) private var dismiss
    @Environment(\.modelContext) private var context
    
    @State private var name = ""
    @State private var latitude = ""
    @State private var longitude = ""
    @State private var textDescription = ""
    @State private var icon: String = "mappin"
    @State private var imageData: Data?
    @State private var city = ""
    @State private var country = ""
    @State private var showPhotoPicker = false

    var body: some View {
        Text("Saisie d'un Point")
            .font(.title)
        Form {
            VStack(alignment: .leading) {
                Section(header: Text("Informations")) {
                    
                    TextField("Nom", text: $name)
                    
                    TextField("Latitude", text: $latitude)
                        .keyboardType(.decimalPad)
                    TextField("Longitude", text: $longitude)
                        .keyboardType(.decimalPad)
                    TextField("Ville", text: $city)
                    TextField("Pays", text: $country)
                    TextField("Description", text: $textDescription)
                }
                Spacer()
                Section(header: Text("Icône et image")) {
                    // Icône SF Symbol
                    HStack {
                        TextField("Icône (ex: star.fill)", text: $icon)
                        Image(systemName: icon)
                            .foregroundColor(.orange)
                    }
                    
                    
                    // Affichage de l’image si dispo
                    if let imageData,
                       let uiImage = UIImage(data: imageData) {
                        Image(uiImage: uiImage)
                            .resizable()
                            .scaledToFit()
                            .frame(height: 150)
                            .cornerRadius(10)
                    }
                    // Bouton pour picker une photo
                    Button("Choisir une photo") {
                        showPhotoPicker = true
                    }
                    .sheet(isPresented: $showPhotoPicker) {
                        PhotoPickerView(imageData: $imageData)
                    }
                }
            } //  Section
            Spacer(minLength: 200)
            //            overlay{
            HStack{
                Button("Enregistrer →") {
                    savePoint()
                }
//                .disabled(point.latitude == 0.0 || point.longitude == 0.0)
                .buttonStyle(.borderedProminent)
                .tint(.green)
                .clipShape(RoundedRectangle(cornerRadius: 10))
                .padding(.leading, 20)
                Spacer(minLength: 200)
                
                Button("Navigation →") {
                    path.append(Destination.navigation(id: 2))
                }
                .buttonStyle(.borderedProminent)
                .tint(.blue)
                .clipShape(RoundedRectangle(cornerRadius: 10))
                .padding(.trailing, 20)
            } //Hstack
            //            }   // overlay
        } //vstack
        //Form
    }  //body
    private func savePoint() {
        guard let lat = Double(latitude),
              let lon = Double(longitude) else {
            // Tu peux afficher une alerte si besoin ici
            return
        }
        
        let point = MyPoint(
            name: name,
            latitude: lat,
            longitude: lon,
            textDescription: textDescription,
            icon: icon,
            image: imageData,
            country: country,
            city: city
        )
        
        context.insert(point)
        try? context.save()
        
        dismiss()
    }  // savePoint
}
//} //View

//#Preview {
//    StatefulPreviewWrapper(NavigationPath()) { path in
//        AddPointView(id: 5, path: path)
//    }
//}
#Preview {
    let previewPoint = MyPoint(name: "Aperçu", latitude: 48.8566, longitude: 2.3522, textDescription: "Point pour preview", icon: "mappin")
    return AddPointView(id: 99, path: .constant(NavigationPath()), point: previewPoint)
}
