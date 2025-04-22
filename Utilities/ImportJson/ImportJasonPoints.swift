//
//  ImportJasonPoints.swift
//  Horizon
//
//  Created by Robert on 01/04/2025.
//
import SwiftUI
import Foundation
import SwiftData

// Structure pour décodage JSON
struct MyPointData: Codable {
    let name: String
    let latitude: Double
    let longitude: Double
    let textDescription: String
}

// Fonction principale d'import
@MainActor
func importerPointsDepuisJSON(context: ModelContext) {
    print("📥 Début importation JSON...")
    print("📦 Contexte utilisé dans import :", ObjectIdentifier(context))
    guard let url = Bundle.main.url(forResource: "mypoints", withExtension: "json"),
          let data = try? Data(contentsOf: url) else {
        print("❌ Fichier JSON introuvable dans le bundle")
        return
    }
    
    do {
        let decodedPoints = try JSONDecoder().decode([MyPointData].self, from: data)
        
        if decodedPoints.isEmpty {
            print("⚠️ Fichier JSON vide")
            return
        }
        
        for item in decodedPoints {
            let newPoint = MyPoint(
                name: item.name,
                latitude: item.latitude,
                longitude: item.longitude,
                textDescription: item.textDescription,
                icon: "mappin",           // valeur par défaut
                image: nil,
                city: "",
                country: ""
            )
            context.insert(newPoint)
            print("➕ Ajouté : \(newPoint.name)")
        }
        
        try context.save()
        print("✅ Importation et sauvegarde réussie : \(decodedPoints.count) points")

    } catch {
        print("❌ Erreur de décodage JSON : \(error.localizedDescription)")
    }
}
