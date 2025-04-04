//
//  ImportJasonPoints.swift
//  Horizon
//
//  Created by Robert on 01/04/2025.
//

import SwiftUI
import Foundation
import SwiftData

struct MyPointData: Codable {
    let name: String
    let latitude: Double
    let longitude: Double
    let textDescription: String
}

@MainActor
func importerPointsDepuisJSON(context: ModelContext) {
    guard let url = Bundle.main.url(forResource: "mypoints", withExtension: "json"),
          let data = try? Data(contentsOf: url) else {
        print("❌ Fichier JSON introuvable")
        return
    }
    
    do {
        let decodedPoints = try JSONDecoder().decode([MyPointData].self, from: data)
        for item in decodedPoints {
            let newPoint = MyPoint(
                name: item.name,
                latitude: item.latitude,
                longitude: item.longitude,
                textDescription: item.textDescription
            )
            context.insert(newPoint)
        }
        try context.save()
        print("✅ Importation terminée : \(decodedPoints.count) points")
    } catch {
        print("❌ Erreur de décodage JSON : \(error)")
    }
}
