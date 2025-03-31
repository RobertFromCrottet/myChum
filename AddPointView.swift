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
    
    @Environment(\.dismiss) private var dismiss
    @Environment(\.modelContext) private var context
   
       @State private var name = ""
       @State private var latitude = ""
       @State private var longitude = ""
       @State private var textDescription = ""
    
    var body: some View {
        Text("Points remarquables")
            .font(.title)
            Form {
                Section(header: Text("Informations")) {
                    TextField("Nom", text: $name)
                    Group {
                        TextField("Latitude", text: $latitude)
                            .keyboardType(.decimalPad)
                        
                        TextField("Longitude", text: $longitude)
                            .keyboardType(.decimalPad)
                        TextField("Description", text: $textDescription)                   }
                }
                 Section {
                 Button("Enregistrer") {
                       // savePoint()
                   }  // Buttton
                    .disabled(name.isEmpty || latitude.isEmpty || longitude.isEmpty)
            } //section button save
      }  //Form
    }  //body
} //View
//    /*private*/private func savePoint() {
//        guard let lat = Double(latitude),
//              let lon = Double(longitude) else { return }
//
//        let Point = Point(nom: nom, latitude: lat, longitude: lon, description: textDescription)
//        context.insert(Point)
//
//        dismiss()
//    }
#Preview {
    StatefulPreviewWrapper(NavigationPath()) { path in
        AddPointView(id: 5, path: path)
    }
}
