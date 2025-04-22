//
//  DistanceFrom.swift
//  Next
//
//  Created by Robert on 12/04/2025.
//

import Foundation
import SwiftUI
import MapKit
import CoreLocation

@MainActor
func distanceFromMyPosition(to coordinate: CLLocationCoordinate2D, using locationManager: LocationManager) -> String {
    guard let userLoc = locationManager.currentLocation else { return "—" }
    
    let userLocation = CLLocation(latitude: userLoc.latitude, longitude: userLoc.longitude)
    let destination = CLLocation(latitude: coordinate.latitude, longitude: coordinate.longitude)
    let distance = userLocation.distance(from: destination)

    if distance >= 1000 {
        return String(format: "%.1f km", distance / 1000)
    } else {
        return String(format: "%.0f m", distance)
    }
}
