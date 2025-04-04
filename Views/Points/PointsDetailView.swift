
import SwiftUI
import SwiftData

struct PointDetailView: View {
    // MARK: -  for navigation
    let id: Int
    @Binding var path: NavigationPath
    
    @Environment(\.dismiss) private var dismiss
    @Environment(\.modelContext) private var context

    @Bindable var point: MyPoint

    var body: some View {
        Form {
            Section(header: Text("Nom")) {
                TextField("Nom", text: $point.name)
            }

            Section(header: Text("Coordonnées")) {
                TextField("Latitude", value: $point.latitude, format: .number)
                    .keyboardType(.decimalPad)
                TextField("Longitude", value: $point.longitude, format: .number)
                    .keyboardType(.decimalPad)
            }
            Section(header: Text("Localisation")) {
                TextField("Ville", text: Binding(
                    get: { point.city ?? "" },
                    set: { point.city = $0 }
                ))
                
                TextField("Pays", text: Binding(
                    get: { point.country ?? "" },
                    set: { point.country = $0 }
                ))
            }
            Section(header: Text("Description")) {
                TextField("Description", text: $point.textDescription)
            }
            Section {
                HStack {
                    Spacer(minLength: 250)
                    
                    Button(role: .destructive) {
                        // Action de suppression ici
                    } label: {
                        Label("Supprimer", systemImage: "trash")
                            .frame(maxWidth: .infinity)
                    }
                    .buttonStyle(.bordered)
                }
                .padding(.vertical)
            }
//            Section {
//                // Place un espace pour pousser le bouton en bas
//                        Spacer(minLength: 200)
//
//                        Button(role: .destructive) {
//                            // Action de suppression ici
//                        } label: {
//                            Label("Supprimer ce point", systemImage: "trash")
//                                .frame(maxWidth: .infinity, alignment: .center)
//                        }
//                        .frame(maxWidth: .infinity)
//                        .padding(.vertical)
//            }
        }
        .toolbar {
            ToolbarItem(placement: .navigationBarLeading) {
                Button("Retour") {
                    dismiss()
                    
                }
            }
        }
        .navigationBarBackButtonHidden(true)
        .navigationTitle("Détail du point : \(point.name)  ")
    }
}
//#Preview {
//    StatefulPreviewWrapper(NavigationPath()) { path in
//        PointDetailView(id: 5, path: path)
//    }
//}

///
///
///
///
///
///
///
///
//////
////  PointsDetailView.swift
////  Horizon
////
////  Created by Robert on 01/04/2025.
////
//
//import SwiftUI
//
//struct PointsDetailView: View {
//    // MARK: -  for navigation
//    //    let id: Int
//    //    @Binding var path: NavigationPath
//    @Environment(\.modelContext) private var context
//    @Environment(\.dismiss) private var dismiss
//    
//    @State private var isEditing = false
//    
//    @State private var name: String = ""
//    @State private var latitude: Double = 0.0
//    @State private var longitude: Double = 0.0
////    @State private var textDescription: String
//    
//    let points: MyPoint
//    init(points: MyPoint) {
//        self.points = points
//        self._name = State.init(initialValue: points.name)
//        self._latitude = State.init(initialValue: points.latitude)
//        self._longitude = State.init(initialValue: points.longitude)
//        self._textDescription = State.init(initialValue: points.textDescription)
//        
//    } // init points
//    
//    var body: some View {
//        Form{
//            if isEditing {
//                Group {
//                    Section(header: Text("Edit Point")) {
//                        TextField("Name", text: $name)
////                        TextField("Latitude", Double.init(String(format: "%.6f", latitude))).onChange(of: $latitude)
////                        TextField("Longitude", Double.init(String(format: "%.6f", latitude))).onChange(of: $latitude)                        TextField("Description", text: $textDescription ?? "")
//                    } // section
//                } //Group
//                
//                .textFieldStyle(.roundedBorder)
//                Button("Enregistrer"){
//                  //  guard let publishedYear = publishedYear else { return }
//                    points.name = name
//                    points.latitude = latitude
//                    points.longitude = longitude
//                    points.textDescription = textDescription
//                    do {
//                        try context.save()
//                    } // do
//                    catch {
//                        print(error.localizedDescription)
//                    }   ///catch
//                    
//                    dismiss()
//                        
//                }  // button enregistrer
//                .bold()
//                .foregroundStyle(.red)
//                .buttonStyle(.bordered)
//                .background(
//                            RoundedRectangle(
//                                cornerRadius: 20,
//                                style: .continuous
//                            )
//                            .stroke(.red, lineWidth: 2)
//                        )  // background
//                
//            }  //ISeditinng
//        } //Form
//    } //body
//}  // View
//
