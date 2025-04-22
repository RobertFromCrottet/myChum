//
//  LocationInfo.swift
//  Next
//
//  Created by Robert on 13/04/2025.
//


import Foundation
import CoreLocation

struct LocationInfo {
    let name: String
    let city: String
    let country: String
    let address: String
}

struct LocationInfoService {
    static func reverseGeocode(coordinate: CLLocationCoordinate2D, completion: @escaping (LocationInfo?) -> Void) {
        let location = CLLocation(latitude: coordinate.latitude, longitude: coordinate.longitude)
        CLGeocoder().reverseGeocodeLocation(location) { placemarks, error in
            guard let placemark = placemarks?.first else {
                completion(nil)
                return
            }

            let name = placemark.name ?? "Point sans nom"
            let city = placemark.locality ?? ""
            let country = placemark.country ?? ""
            let address = [placemark.name, placemark.locality, placemark.country]
                .compactMap { $0 }
                .joined(separator: ", ")

            completion(LocationInfo(name: name, city: city, country: country, address: address))
        }
    }
}