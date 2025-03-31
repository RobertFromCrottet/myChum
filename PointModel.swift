//
//  LieuModel.swift
//  Horizon
//
//  Created by Robert on 29/03/2025.
//

import Foundation
import SwiftData
import CoreLocation

@Model
class Point: Identifiable {  // ex Lieu
    var id: UUID
    var name: String
    var latitude: Double
    var longitude: Double
    var textdescription: String?

    var coordonnée: CLLocationCoordinate2D {
        CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
    }

    init(name: String, latitude: Double, longitude: Double, description: String? = nil) {
        self.id = UUID()
        self.name = name
        self.latitude = latitude
        self.longitude = longitude
        self.textdescription = textdescription
    }
}
