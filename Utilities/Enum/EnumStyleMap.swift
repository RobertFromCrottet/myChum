//
//  EnulStyleMap.swift
//  Next
//
//  Created by Robert on 03/04/2025.
//
import SwiftUI
import MapKit

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
