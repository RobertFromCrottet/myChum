//
//  RootView.swift
//  Horizon
//
//  Created by Robert on 28/03/2025.
//

import Foundation
import SwiftUI
import SwiftData

struct RootView: View {
    @State private var path = NavigationPath()
    @Query var allPoints: [MyPoint]
    
    var body: some View {
                   HomeView( path: $path)
                       .navigationDestination(for: Destination.self) { destination in
                           destinationView(for: destination, path: $path, allPoints: allPoints)
                       }
        .preferredColorScheme(.light)
    }
    
}
