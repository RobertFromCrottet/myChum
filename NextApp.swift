//
//  NextApp.swift
//  Next
//
//  Created by Robert on 02/04/2025.
//

import SwiftUI

@main
struct NextApp: App {
    var body: some Scene {
        WindowGroup {
            
            
            NavigationStack {
                
                RootView()
                
            } //NavigationStack
            .preferredColorScheme(.light)
        }
        .modelContainer(for: MyPoint.self)
    }
}
