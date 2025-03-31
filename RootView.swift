//
//  RootView.swift
//  Horizon
//
//  Created by Robert on 28/03/2025.
//

import Foundation
import SwiftUI

struct RootView: View {
    @State private var path = NavigationPath()
    
    var body: some View {
        HomeView(id: 1, path: $path)
    }
}
