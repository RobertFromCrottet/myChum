//
//  MyUser.swift
//  Next
//
//  Created by Robert on 28/04/2025.
//

import Foundation
import SwiftUI
import SwiftData
import CoreLocation

@Model
class MyUser{
    @Attribute(.unique) var id: UUID = UUID()
    var name: String
    var firstName: String = ""
    var adress1: String = ""
    var adress2: String = ""
    var zipCode: String = ""
    var city: String = ""
    var country: String = ""
    var phone: String = ""
    var email: String = ""
    var latitude: Double = 0
    var longitude: Double = 0
    var avatar: Data?
    var photo: Data?
    var birthday: Date?
    var sexe: String?
    var fullName: String {
        "\(firstName) \(name)"
    }
    
    init(id: UUID = UUID(),
         name: String,
         firstName: String = "",
         adress1: String = "",
         adress2: String = "",
         zipCode: String = "",
         city: String = "",
         country: String = "",
         phone: String = "",
         email: String = "",
         latitude: Double = 0,
         longitude: Double = 0,
         avatar: Data? = nil,
         photo: Data? = nil,
         birthday: Date? = nil,
         sexe: String? = nil) {
        
        self.id = id
        self.name = name
        self.firstName = firstName
        self.adress1 = adress1
        self.adress2 = adress2
        self.zipCode = zipCode
        self.city = city
        self.country = country
        self.phone = phone
        self.email = email
        self.latitude = latitude
        self.longitude = longitude
        self.avatar = avatar
        self.photo = photo
        self.birthday = birthday
        self.sexe = sexe
    }
    
}
//#Preview {
//    MyUser()
//}
