//
//  MyDocument.swift
//  Next
//
//  Created by Robert on 29/04/2025.
//

import Foundation

import SwiftData

@Model
class MyDocument {
    @Attribute(.unique) var id: UUID = UUID()
    var title: String
    var dateCreated: Date
    var filePath: String   // Chemin du fichier PDF dans Documents/
    
    // 🔗 Lien vers un utilisateur
    @Relationship var owner: MyUser?

    init(title: String, dateCreated: Date = Date(), filePath: String, owner: MyUser? = nil) {
        self.title = title
        self.dateCreated = dateCreated
        self.filePath = filePath
        self.owner = owner
    }
}
