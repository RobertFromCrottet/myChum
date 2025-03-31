////
////  LocalisationList.swift
////  Horizon
////
////  Created by Robert on 29/03/2025.
////
//
//// LocalisationListView.swift
//// Horizon
//
//import SwiftUI
//import SwiftData
//
//struct LocalisationListView: View {
//    @Environment(\.modelContext) private var context
//    @Query private var lieux: [Lieu] // Ton modèle SwiftData
//
//    var body: some View {
//        NavigationStack {
//         
//                List {
//                    ForEach(lieux, id: \.id) { lieu in
//                        VStack(alignment: .leading) {
//                            Text(lieu.nom)
//                                .font(.headline)
//
//                            Text("Lat: \(lieu.latitude), Lon: \(lieu.longitude)")
//                                .font(.caption)
//                                .foregroundColor(.secondary)
//
//                            if let desc = lieu.textDescription, !desc.isEmpty {
//                                Text(desc)
//                                    .font(.subheadline)
//                            }
//                        }
//                        .padding(.vertical, 8)
//                    }
//                }
//
//            .navigationTitle("Mes Localisations")
//            .toolbar {
//                EditButton()
//            }
//        }
//    }
//}
//
//#Preview {
//    StatefulPreviewWrapper(NavigationPath()) { path in
//        LocalisationListView()
//    }
//}
