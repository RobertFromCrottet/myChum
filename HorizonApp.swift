//
//  HorizonApp.swift
//  Horizon
//
//  Created by Robert on 28/03/2025.
//

import SwiftUI

@main
struct HorizonApp: App {
    var body: some Scene {
        WindowGroup {
           RootView()
        }
        .modelContainer(for:Point.self)
    }
}
