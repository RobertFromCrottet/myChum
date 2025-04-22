//
//  NavigationModule.swift
//  Horizon
//
//  Created by Robert on 28/03/2025.
//

import Foundation
import SwiftUI
import SwiftData
import MapKit

/// Fonction qui retourne la bonne vue selon la destination
func destinationView(for destination: Destination, path: Binding<NavigationPath>, allPoints: [MyPoint]) -> AnyView {
    switch destination {
    
    case .home:
        return AnyView(HomeView( path: path))

    case .navigation:
        return AnyView(myNavigationView(id: UUID(), path: path))

    case .settings:
        return AnyView(SettingsView(id: UUID(), path: path))

    case .user:
        return AnyView(UserView(id: UUID(), path: path))

    case .point:
        return AnyView(PointsListView(id: UUID(), path: path))
        
    case .pointsList:
        return AnyView(PointsListView(id: UUID(),path: path))

    case .map(let id):
        return AnyView(MapView(id: id, path: path, fromPoint: false, initialCoordinate: nil))

    case .mapAt(let id, let lat, let lon):
        let coordinate = CLLocationCoordinate2D(latitude: lat, longitude: lon)
        return AnyView(MapView(id: id, path: path, fromPoint: true, initialCoordinate: coordinate))

    case .newpoint:
        return AnyView(AddPointView()) // si AddPointView gère la création

    case .editPoint(let uuid):
        if let point = allPoints.first(where: { $0.id == uuid }) {
            return AnyView(AddPointView(existingPoint: point))
        } else {
            return AnyView(Text("Point introuvable"))
        }
    }
}
