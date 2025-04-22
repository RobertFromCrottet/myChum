//
//  SFIcon 2.swift
//  Next
//
//  Created by Robert on 08/04/2025.
//


import Foundation

enum SFIcon: String, CaseIterable, Identifiable {
    case mappin, star, house, flag, leaf, camera, bolt, globe, figure,sailboat
    case buildingColumns = "building.columns"

    var id: String { rawValue }

    var label: String {
        switch self {
        case .mappin: return "Position"
        case .star: return "Favori"
        case .house: return "Maison"
        case .flag: return "Drapeau"
        case .leaf: return "Nature"
        case .camera: return "Photo"
        case .bolt: return "Énergie"
        case .globe: return "Monde"
        case .figure: return "Ballade"
        case .sailboat: return "Voile"
        case .buildingColumns: return "Bâtiment"
            
        }
    }
}
