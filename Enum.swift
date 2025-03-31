//
//  Destination.swift
//  Horizon
//
//  Created by Robert on 28/03/2025.
//


import SwiftUI
import MapKit

 // MARK: - Enum pour les  routes possibles dans l’app

enum Destination: Hashable {

    case home(id: Int)//1
    case navigation(id: Int) //2
    case map(id: Int) //3
    case settings(id: Int) //4
    case point(id: Int) // 5
   case user(id: Int)
    
}

// MARK: - Enum pour les styles de carte
enum MapStyleOption: String, CaseIterable, Identifiable {
    case standard, hybrid, imagery
    var id: String { self.rawValue }

    var style: MapStyle {
        switch self {
        case .standard: return .standard
        case .hybrid: return .hybrid
        case .imagery: return .imagery
        }
    }

    var label: String {
        switch self {
        case .standard: return "Standard"
        case .hybrid: return "Hybride"
        case .imagery: return "Satellite"
        }
    }
}
