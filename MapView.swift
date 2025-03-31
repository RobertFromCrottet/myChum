//
//  MapModuleView.swift
//  Horizon
//
//  Created by Robert on 28/03/2025.
//

import SwiftUI
import MapKit

struct MapView: View {
    // MARK: -  for navigation
    let id: Int
    @Binding var path: NavigationPath
    
    // MARK: -  options style map
    @State private var selectedStyle: MapStyleOption = .hybrid
    
    // MARK: -  position of camera
    @State private var camera: MapCameraPosition = .camera(
        MapCamera(centerCoordinate: .crottet, distance: 30000)
    )
    
    @State private var cameraPosition = MapCameraPosition.region(
        MKCoordinateRegion(
            center: CLLocationCoordinate2D(latitude: 48.8566, longitude: 2.3522),
            span: MKCoordinateSpan(latitudeDelta: 0.1, longitudeDelta: 0.1)
        )
    )
    // MARK: -  var
    @State private var showMarkers = true
    
    
    // MARK: - search location
    @State private var showSearchSheet = false
    @State private var showButtons = true
    
    
    var body: some View {

        VStack {
            VStack {
                // MARK: - top Buttons
                HStack {
                    Toggle("Afficher les lieux", isOn: $showMarkers)
                        .toggleStyle(.switch)
                        .background(Color.lemonYellow)
                        .clipShape(RoundedRectangle(cornerRadius: 10))
                    Label("Macon", systemImage: "mappin.and.ellipse")
                    //.font(.caption2)
                        .frame(width: 200)
                        .background(Color.lemonYellow)
                        .clipShape(RoundedRectangle(cornerRadius: 10))
                                        .padding(.leading)
                    // MARK: -  setting picker
                    Picker("Style", selection: $selectedStyle) {
                        ForEach(MapStyleOption.allCases) { option in
                            Text(option.label).tag(option)
                        }   // foreach
                    } //picker
                    .pickerStyle(.segmented)
                    .background(Color.lemonYellow)
                    .clipShape(RoundedRectangle(cornerRadius: 10))
                }   // Hstack
                .frame(width: 650)
                .padding(10)   // de la frame
                .font(.caption2)
                .background(.regularMaterial)
                .clipShape(RoundedRectangle(cornerRadius: 10))
                .padding(.horizontal)
                .padding(.top,0)
            }   //Vstack
            
            // MARK: -  setting Map
            Map(position: $camera) {
                //                sweetHomeMarker()
            }  // camera
            .mapStyle(selectedStyle.style)
            .clipShape(RoundedRectangle(cornerRadius: 20))
            
            // MARK: -  SHOW Button's bottom
            if showButtons {
                HStack(spacing: 5) {
                    CarteButton( title: "Paris", color: .yellow)  {
                        // goToParis()
                    }
                    CarteButton(title: "Recherche", color: .yellow) {
                        showSearchSheet = true
                    }
                    CarteButton(title:"Revenir à Crottet") {
                        withAnimation {
                            camera = .camera(MapCamera(centerCoordinate: .crottet, distance: 25000))
                        }
                    }
                    Spacer()
                    CarteButton(title: "--> Navigation", color: .red) {
                        path.append(Destination.navigation(id: 2))
                    }
                }  // Hstack
                .padding()
            }  //showbutton
        }  //Vstack
        .navigationBarBackButtonHidden(true)
        .toolbarBackground(.hidden, for:.navigationBar)
      
    }   //body
    
}  //View

#Preview {
    StatefulPreviewWrapper(NavigationPath()) { path in
        MapView(id: 3, path: path)
    }
}  
//private func goToParis() {
//    cameraPosition = .camera(
//        MapCamera(centerCoordinate: CLLocationCoordinate2D(latitude: 48.864716, longitude: 2.349014), distance: 20000)
//    )
//}
