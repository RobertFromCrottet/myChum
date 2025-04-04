//
//  ContentView.swift
//  Horizon
//
//  Created by Robert on 31/03/2025.
//

import SwiftUI

struct ContentView: View {
    // MARK: -  for navigation
    let id: Int
    @Binding var path: NavigationPath
    
    var body: some View {
        VStack {
            PointsListView(id: 5, path: $path)
                .onAppear {
                    
                }
        }
        .padding()
    }
}
//
#Preview {
    StatefulPreviewWrapper(NavigationPath()) { path in
        ContentView(id: 5, path: path)
    }
}
