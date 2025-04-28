
import SwiftUI
import MapKit

struct SheetMAPView: View {
    @Binding var point: MyPoint
    var initialCoordinate: CLLocationCoordinate2D? = nil
    
    @Environment(\.dismiss) var dismiss
    @State private var camera = MapCameraPosition.automatic
    @State private var centerCoordinate = CLLocationCoordinate2D(latitude: 46.0, longitude: 4.8)

    var body: some View {
        ZStack {
            // --- Carte ---
            Map(position: $camera)
                .mapStyle(.hybrid)
                .onMapCameraChange { context in
                    centerCoordinate = context.camera.centerCoordinate
                }
                .ignoresSafeArea()
                .onAppear {
                    if let initial = initialCoordinate {
                        camera = .camera(MapCamera(centerCoordinate: initial, distance: 500))
                        centerCoordinate = initial
                    }
                }

            // --- Affichage Live des coordonnées ---
            VStack {
                Text("Lat: \(centerCoordinate.latitude, specifier: "%.5f")  Lon: \(centerCoordinate.longitude, specifier: "%.5f")")
                    .font(.caption)
                    .padding(6)
                    .background(.ultraThinMaterial)
                    .cornerRadius(8)
                    .padding(.top, 60)

                Spacer()
            }

            // --- Croix rouge au centre ---
            Image(systemName: "plus.circle.fill")
                .font(.largeTitle)
                .foregroundColor(.white)
                .opacity(0.8)

    

            // --- Boutons Annuler et Valider ---
            VStack {
                Spacer()
                HStack(spacing: 20) {
                    CarteButton(title: "Annuler", color: .red) {
                        dismiss()
                    }
//                    CarteButton(title: "Recentrer", color: .mint) {
//                        if let initial = initialCoordinate {
//                            camera = .camera(MapCamera(centerCoordinate: initial, distance: 500))
//                            centerCoordinate = initial
//                        }
//                    }
                    CarteButton(title: "Valider la position", color: .blue) {
                        point.latitude = centerCoordinate.latitude
                        point.longitude = centerCoordinate.longitude
                        dismiss()
                    }
                }
                .padding(.bottom, 30)
            }
        }
    }
}



//import SwiftUI
//import MapKit
//
//struct SheetMAPView: View {
//    @Binding var point: MyPoint
//    @Environment(\.dismiss) var dismiss
//    @State private var camera = MapCameraPosition.automatic
//    @State private var centerCoordinate = CLLocationCoordinate2D(latitude: 0, longitude: 0)
//    var initialCoordinate: CLLocationCoordinate2D? = nil
//    
//    var body: some View {
//        ZStack {
//            Map(position: $camera)
//                .mapStyle(.imagery)
//                .onMapCameraChange { context in
//                    centerCoordinate = context.camera.centerCoordinate
//                }
//                .ignoresSafeArea(edges: .all)
//            Text("Lat: \(centerCoordinate.latitude, specifier: "%.5f")  Lon: \(centerCoordinate.longitude, specifier: "%.5f")")
//                    .font(.caption)
//                    .padding(6)
//                    .background(.ultraThinMaterial)
//                    .cornerRadius(8)
//                    .padding(.top, 60)
//
//                Spacer()
//            // La croix rouge au centre
//            Image(systemName: "plus.circle.fill")
//                .font(.largeTitle)
//                .foregroundColor(.white)
//                .opacity(0.8)
//
//            // Bouton en bas
//            VStack {
//                Spacer()
//                HStack(spacing: 20) {
//                       CarteButton(title: "Annuler", color: .red) {
//                           dismiss()
//                       }
//                    CarteButton(title: "Recentrer", color: .mint) {
//                        if let initial = initialCoordinate {
//                            camera = .camera(MapCamera(centerCoordinate: initial, distance: 2000))
//                            centerCoordinate = initial
//                            dismiss()
//                        }
//                    }
//                       CarteButton(title: "Valider la position", color: .blue) {
//                           point.latitude = centerCoordinate.latitude
//                           point.longitude = centerCoordinate.longitude
//                           dismiss()
//                       }
//                   }
//                
//                .padding(.bottom, 30)
//            }
//        }
//
// 
//        .onAppear {
//            camera = .camera(MapCamera(centerCoordinate: CLLocationCoordinate2D(latitude: point.latitude, longitude: point.longitude), distance: 1000))
//        }
//        
//    }
//}
