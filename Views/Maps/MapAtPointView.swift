//
//  MapAtPointView.swift
//  Next
//
//  Created by Robert on 08/04/2025.
//


import SwiftUI
import MapKit

struct MapAtPointView: View {
    let center: CLLocationCoordinate2D

    @State private var region: MKCoordinateRegion
    @State private var position: MapCameraPosition = .region(MKCoordinateRegion(
        center: CLLocationCoordinate2D(latitude: 46.0, longitude: 4.9),
        span: MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05)
    ))
    
    init(center: CLLocationCoordinate2D) {
        self.center = center
        _region = State(initialValue: MKCoordinateRegion(
            center: center,
            span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01)
        ))
    }

    var body: some View {
        VStack {}
//            Map(coordinateRegion: $region, showsUserLocation: true)
            Map(position: $position) {
//            .edgesIgnoringSafeArea(.all)
            }
            Text("📍 lat: \(center.latitude), lon: \(center.longitude)")
                .font(.caption)
                .padding(.bottom, 8)
//            print("📍 Go to MapAt: \(point.latitude), \(point.longitude)")
       
        .navigationTitle("Carte centrée")
        .onAppear {
            // En bonus, on peut forcer à recentrer (sécurité)
            region.center = center
        }
    }
}
