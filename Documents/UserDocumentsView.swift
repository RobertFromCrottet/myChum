//
//  UserDocumentsView.swift
//  Next
//
//  Created by Robert on 29/04/2025.
//


import SwiftUI
import SwiftData

struct UserDocumentsView: View {
    @Bindable var user: MyUser
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("📚 Documents de \(user.fullName)")
                .font(.title2)
                .bold()
            
//            if user.documents.isEmpty {
//                Text("Aucun document pour l'instant...")
//                    .font(.caption)
//                    .foregroundColor(.secondary)
//            } else {
//                List {
//                    ForEach(user.documents) { document in
//                        VStack(alignment: .leading) {
//                            Text(document.title)
//                                .font(.headline)
//                            Text(document.dateCreated.formatted(date: .long, time: .omitted))
//                                .font(.caption)
//                                .foregroundColor(.secondary)
//                        }
//                    }
//                }
//            }
            
            Spacer()
        }
        .padding()
        .navigationTitle("Documents")
    }
}
