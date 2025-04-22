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
    @Attribute(.unique) var id: UUID = UUID()
    var name: String
    var latitude: Double
    var longitude: Double
    var textDescription: String
    @Attribute var icon: String? = "mappin"
    @Attribute var image: Data?
    @Attribute var images: [Data] = []
    var country: String?
    var city: String?
var adresse: String?
    
    init(
        name: String = "",
        latitude: Double = 0.0,
        longitude: Double = 0.0,
        textDescription: String = "",
        icon: String? = "mappin",
        image: Data? = nil,
        images: [Data] = [],
        city: String = "",
        country: String = "",
        adresse: String = ""
    ) {
        self.id = UUID()
        self.name = name
        self.latitude = latitude
        self.longitude = longitude
        self.textDescription = textDescription
        self.icon = icon
        self.image = image
        self.images = images
        self.city = city
        self.country = country
        self.adresse = adresse
    }
}
