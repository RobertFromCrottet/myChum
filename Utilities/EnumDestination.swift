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

    case home(id: Int)//1
    case navigation(id: Int) //2
    case map(id: PersistentIdentifier)//3
    case settings(id: Int) //4
    case point(id: Int) // 5
   case user(id: Int)  //6
    case newpoint(id: Int)
   case editPoint(id: Int)

    
}

