//
//  Destination.swift
//  Horizon
//
//  Created by Robert on 28/03/2025.
//


import SwiftUI
import MapKit
import SwiftData

 // MARK: - Enum pour les  routes possibles dans l’app

enum Destination: Hashable {
    case home(id: UUID)
    case navigation(id: UUID)
    case map(id: UUID)
    case settings(id: UUID)
    case point(id: UUID)
    case user(id: UUID)
    case newpoint(id: UUID)
    case editPoint(id: UUID)
    case mapAt(id: UUID, latitude: Double, longitude: Double)
    case pointsList (id: UUID)// 👈 pour la liste entière sans id
}

//enum Destination: Hashable {
//
//    case home(id: Int)//1
//    case navigation(id: UUID) //2
//    case map(id: UUID)//3 PersistentIdentifier
//    case settings(id: Int) //4
//    case point(id: Int) // 5
//   case user(id: Int)  //6
//    case newpoint(id: Int)
//   case editPoint(id: UUID)
//    case mapAt(id: UUID,latitude: Double, longitude: Double) // 🆕    
//}

