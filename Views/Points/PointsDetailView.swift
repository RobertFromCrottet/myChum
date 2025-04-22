
import SwiftUI
import SwiftData
import PhotosUI
import MapKit

struct PointDetailView: View {
    // MARK: -  for navigation
    let id: Int
    @Binding var path: NavigationPath
    @State var point: MyPoint
    
    @Environment(\.dismiss) private var dismiss
    @Environment(\.modelContext) private var context
    // MARK: -  for var declaration
    @State private var region = MKCoordinateRegion(
        center: CLLocationCoordinate2D(latitude: 46.0, longitude: 4.8),
        span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01)
    )
    @State private var latitudeString = ""
    @State private var longitudeString = ""

    
    @State private var icon: String = ""
    @State private var selectedPhoto: PhotosPickerItem?

    @State private var showMiniaturePreview = false

    var body: some View {
        // MARK: -  for view detail point
        Form {
//            TextField("UUID", text: point.UUId)
                
            HStack  {
                
                Text("Nom :")
                    .font(.caption)
                    .frame(width:100)
                    .bold(true)
                // .padding(EdgeInsets(top: 0, leading:10, bottom: 0, trailing: 0))
                TextField("Nom", text: $point.name)
                    .font(.caption)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .frame(width: 300)
                    .foregroundColor(.blue)
                //                    .padding()
                Text("Coordonnées GPS :")
                    .font(.caption)
                    .frame(width: 200)
                    .bold(true)
                 .padding(EdgeInsets(top: 0, leading: 60, bottom: 0, trailing: 0))
                TextField("Latitude", text: $latitudeString)
                    .keyboardType(.decimalPad)
                    .onChange(of: latitudeString) { newValue in
                        if let val = newValue.asDouble {
                            point.latitude = val
                        }
                    }
                    .font(.caption)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .frame(width: 150)
                    .foregroundColor(.blue)
                //                    .padding()
                Text(" / ")
                TextField("Longitude", text: $longitudeString)
                    .keyboardType(.decimalPad)
                    .onChange(of: longitudeString) { newValue in
                        if let val = newValue.asDouble {
                            point.longitude = val
                        }
                    }
                    .keyboardType(.decimalPad)
                    .font(.caption)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .frame(width: 150)
                    .foregroundColor(.blue)
                //                    .padding()
                
            }  //name
            HStack    {
                Text("Adresse :")
                    .font(.caption)
                    .bold(true)
                    .frame(width:100)
                    .padding(EdgeInsets(top: 0, leading:60, bottom: 0, trailing: 0))
                TextField("Adresse", text: Binding(
                    get: { point.adresse ?? "" },
                    set: { point.adresse = $0 }
                ))
                .font(.caption)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .frame(width: 300)
                .foregroundColor(.blue)
                .padding()
                Text("Ville :")
                    .font(.caption)
                    .frame(width:80)
                    .bold(true)
                    .padding(EdgeInsets(top: 0, leading:-20, bottom: 0, trailing: 0))
                TextField("Ville", text: Binding(
                    get: { point.city ?? "" },
                    set: { point.city = $0 }
               
                ))
                .font(.caption)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .frame(width: 300)
                .foregroundColor(.blue)
                .padding()
                Text("Pays :")
                    .font(.caption)
                    .frame(width:180)
                    .bold(true)
                    .padding(EdgeInsets(top: 0, leading: -50, bottom: 0, trailing: 0))
                TextField("Pays", text: Binding(
                    get: { point.country ?? "" },
                    set: { point.country = $0 }
                ))
                .font(.caption)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .frame(width: 300)
                .foregroundColor(.blue)
                .padding(EdgeInsets(top: 0, leading: -50, bottom: 0, trailing: 0))
                
            }
            HStack{
                Map(coordinateRegion: .constant(MKCoordinateRegion(
                    center: CLLocationCoordinate2D(latitude: point.latitude,
                                                   longitude: point.longitude),
                    span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01)
                )), annotationItems: [point]) { location in
                    MapAnnotation(coordinate: CLLocationCoordinate2D(
                        latitude: location.latitude,
                        longitude: location.longitude
                    )) {
                        Image(systemName: location.icon ?? "mappin")
                            .font(.title)
                            .foregroundColor(.red)
                    }
                } //map
                .frame(width:  600,height: 300)
                .cornerRadius(12)
                VStack {
                    
                    
                    Text("Description:")
                        .font(.caption)
                        .frame(width: 200)
                        .bold(true)//section
                    TextField("Description", text: $point.textDescription)
                        .font(.caption)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .frame(width: 300)
                        .foregroundColor(.blue)
                        .padding(.leading, 20)
                }  //Vstack
                
            }
            //            Section(header: Text("Photo")) {
            .onAppear {
                latitudeString = String(format: "%.6f", point.latitude)
                longitudeString = String(format: "%.6f", point.longitude)
            }
            if PhotoStorageManager.hasImages(for: point.id) {
                PointFileGalleryView(uuid: point.id)
            } else {
                Text("📭 Images enregistrées : \(point.images.count)")
                    .font(.caption2)
                    .foregroundColor(.secondary)
            }
            PhotoSectionViewFixed(point: $point)
        }


              // MARK: -  for button bottom's view
        ZStack {
            HStack {
                // Retour
                Button("Retour") {
                   // path.append(.pointsList(id: UUID()))
                    path.append(Destination.pointsList(id: UUID()))
                }
                .buttercup(color: .red)
                .padding(.leading, 20)

                // Voir sur la carte
                Button("Voir sur la carte") {
                    path.append(Destination.mapAt(id: point.id, latitude: point.latitude, longitude: point.longitude))
                }
                .buttercup(color: .mint)
                .padding(.leading, 20)

                // Nouveau Point
                Button("Nouveau Point") {
                    path.append(Destination.newpoint(id: UUID()))
                }
                .buttercup(color: .mint)
                .padding(.leading, 20)
              
                Spacer()

                // Navigation →
                Button("Navigation →") {
                    path.append(Destination.navigation(id: UUID()))
                }
                .buttercup(color: .blue)
                .padding(.trailing, 10)
            }
        }// overlay
        // MARK: -  for top's view
        .toolbar {
            ToolbarItem(placement: .principal) {
                Text("\(Image(systemName :"hand.point.right.fill"))   Detail du point : \(point.name) ")
                    .font(.system(size: 36, weight: .bold))
                    .foregroundColor(.red)
                   // .background(Color.lemonYellow, for: .navigationBar)
            }
            ToolbarItem(placement: .navigationBarLeading) {

                
            }
        }  //
        .sheet(isPresented: $showMiniaturePreview) {
            if let imageData = point.image,
               let uiImage = UIImage(data: imageData) {
                VStack {
                    Image(uiImage: uiImage)
                        .resizable()
                        .scaledToFit()
                        .padding()

                    Button("Fermer") {
                        showMiniaturePreview = false
                    }
                    .padding()
                }
                .presentationDetents([.medium, .large])
            }
        }
        .navigationBarBackButtonHidden(true)
    }  //body
}  // view

//
//  PhotoSectionView.swift
//  Next
//
//  Created by Robert on 11/04/2025.
//

