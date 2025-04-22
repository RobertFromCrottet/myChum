//
//  DistanceTools.swift
//  Next
//
//  Created by Robert on 12/04/2025.
//

//  DistanceTools.swift
//  Horizon
//
//  Created by Robert and my Friend GPT on 13/04/2025.
//

import Foundation
import CoreLocation
import MapKit

@MainActor
extension LocationManager {
    /// Calcule la distance entre l'utilisateur et une coordonnée
    func distance(to coordinate: CLLocationCoordinate2D, unit: UnitLength = .meters) -> String {
        guard let userLoc = currentLocation else { return "—" }

        let userLocation = CLLocation(latitude: userLoc.latitude, longitude: userLoc.longitude)
        let destination = CLLocation(latitude: coordinate.latitude, longitude: coordinate.longitude)
        let distanceMeters = userLocation.distance(from: destination)

        switch unit {
        case .meters:
            if distanceMeters >= 1000 {
                return String(format: "%.1f km", distanceMeters / 1000)
            } else {
                return String(format: "%.0f m", distanceMeters)
            }
        case .feet:
            let feet = distanceMeters * 3.28084
            return String(format: "%.0f ft", feet)
        default:
            let formatter = MeasurementFormatter()
            let distance = Measurement(value: distanceMeters, unit: UnitLength.meters)
            return formatter.string(from: distance.converted(to: unit))
        }
    }

    /// Estime le temps à pied (vitesse moyenne : 1.39 m/s)
    func estimatedWalkingTime(to coordinate: CLLocationCoordinate2D, walkingSpeed: Double = 1.39) -> String {
        guard let userLoc = currentLocation else { return "—" }

        let userLocation = CLLocation(latitude: userLoc.latitude, longitude: userLoc.longitude)
        let destination = CLLocation(latitude: coordinate.latitude, longitude: coordinate.longitude)
        let distanceMeters = userLocation.distance(from: destination)

        let seconds = distanceMeters / walkingSpeed
        let minutes = Int(seconds / 60)
        let hours = Int(minutes / 60)
        return "\(hours) h \(minutes % 60) min à pied"
    }
    
    
}
