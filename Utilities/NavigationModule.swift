//
//  NavigationModule.swift
//  Horizon
//
//  Created by Robert on 28/03/2025.
//

import Foundation
import SwiftUI
import SwiftData

/// Fonction qui retourne la bonne vue selon la destination
func destinationView(for destination: Destination, path: Binding<NavigationPath>, allPoints: [MyPoint]) -> AnyView {
    
    switch destination {
    // MARK: - for greetingsView
    case .home:
        return AnyView(HomeView( path: path))
    // MARK: -  for navigationView
    case .navigation(let id):
        return AnyView(NavigationView(id: id, path: path))
    // MARK: -  for first line buttons
    case .settings(let id):
        return AnyView(SettingsView(id: id, path: path))
    case .user(let id):
        return AnyView(UserView(id: id, path: path))
    case .point(let id):
        return AnyView(PointsListView(id: id, path: path))
    case .map(let id):
        return AnyView(MapView(id: id, path: path))
    // MARK: -  for MyPoints gestion
    case .newpoint(let id):
        let newPoint = MyPoint(name: "", latitude: 0.0, longitude: 0.0, textDescription: "", icon: "mappin")
        return AnyView(AddPointView(id: id, path: path, point: newPoint))
        
    case .editPoint(let id):
        if let point = allPoints.first(where: { $0.id == id }) {
            return AnyView(AddPointView(id: id, path: path, point: point))
        } else {
            return AnyView(Text("Point introuvable"))
        }
    }
}
