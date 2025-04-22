//
//  DevToolsView.swift
//  Next
//
//  Created by Robert on 09/04/2025.
//

import MapKit
import SwiftUI
import SwiftData

enum DevToolRoute: Hashable {
    case importPoints
    case map(id: UUID)
    case home
}


struct DevToolsView: View {
    @Environment(\.modelContext) private var context
    @Query var points: [MyPoint]
    @State private var path = NavigationPath()
    var body: some View {
        NavigationStack(path: $path) {
            List {
                Section(header: Text("📦 Données")) {
                    Button("📥 Importer les 2500 points") {
                        path.append(DevToolRoute.importPoints)
                    }

                    Button("🗑️ Supprimer tous les points") {
                        for point in points {
                            context.delete(point)
                        }
                    }
                }

                Section(header: Text("🛠 Tests")) {
                    Button("➕ Ajouter un point factice") {
                        let dummy = MyPoint(
                            name: "Test Point",
                            latitude: 45.0,
                            longitude: 3.0,
                            textDescription: "Point généré manuellement",
                            icon: "bolt",
                            image: nil,
                            city: "TestCity",
                            country: "France",
                            adresse: "250 rue des champs"                        )
                        context.insert(dummy)
                    }

                    Button("🗺️ Voir la carte") {
                        path.append(DevToolRoute.map(id: UUID()))
                    }

                    Button("🧭 Navigation vers Home") {
                        path.append(DevToolRoute.home)
                    }
                }
            }
            .navigationTitle("🧰 DevTools")
            .navigationDestination(for: DevToolRoute.self) { route in
                switch route {
                case .importPoints:
                    AnyView(LoadPointsView()) // ✅

                case .map(let id):
                    AnyView(MapView(id: id, path: $path)) // ✅

                case .home:
                    AnyView(HomeView(path: $path)) // ✅
                }
            }
        }
    }
}
