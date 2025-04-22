//
//  BagOfTricks.swift
//  Next
//
//  Created by Robert on 04/04/2025.
//


import Foundation
import SwiftUI

// MARK: - Accent + casse insensitive search
extension String {
    var foldingForSearch: String {
        self.folding(options: [.diacriticInsensitive, .caseInsensitive], locale: .current)
    }

    var capitalizedFirst: String {
        prefix(1).capitalized + dropFirst()
    }
}



// MARK: - Coordonnées formatées
extension Double {
    var formattedCoordinate: String {
        String(format: "%.4f", self)
    }
}

// MARK: - Date en français
extension Date {
    var formattedFrench: String {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "fr_FR")
        formatter.dateStyle = .medium
        formatter.timeStyle = .short
        return formatter.string(from: self)
    }
}

// MARK: - Icône automatique pour MyPoint
extension MyPoint {
    var symbol: String {
        switch icon?.lowercased() ?? "" {
        case "ville": return "building.2"
        case "montagne": return "mountain.2"
        case "plage": return "sun.max"
        default: return icon ?? "house"
        }
    }
}
