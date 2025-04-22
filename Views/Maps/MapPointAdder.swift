//
//  MapPointAdder.swift
//  Next
//
//  Created by Robert on 13/04/2025.
//


import Foundation
import MapKit
import SwiftData

struct MapPointAdder {
    
    static func ajouterPoint(
        named name: String,
        at coordinate: CLLocationCoordinate2D,
        context: ModelContext
    ) {
        let point = MyPoint(
            name: name.isEmpty ? "Nouveau point" : name,
            latitude: coordinate.latitude,
            longitude: coordinate.longitude,
            textDescription: "",
            icon: "mappin.and.ellipse",
            image: nil,
            city: "",
            country: "",
            adresse: ""
        )

        context.insert(point)
        print("📍 Point ajouté : \(point.name) (\(coordinate.latitude), \(coordinate.longitude))")
    }
}