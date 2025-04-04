//
//  LieuModel.swift
//  Horizon
//
//  Created by Robert on 29/03/2025.
//

import Foundation
import SwiftUI
import SwiftData
import CoreLocation

@Model
class MyPoint {
var id: Int
    var name: String
    var latitude: Double
    var longitude: Double
    var textDescription: String
    var icon: String
    var image: Data?
    var country: String?
    var city: String?

    init(id: Int = 0,name: String, latitude: Double, longitude: Double, textDescription: String, icon: String = "mappin", image: Data? = nil, country: String = "", city: String = "") {
        self.id = id
        self.name = name
        self.latitude = latitude
        self.longitude = longitude
        self.textDescription = textDescription
        self.icon = icon
        self.image = image
        self.country = country
        self.city = city
    }
}
