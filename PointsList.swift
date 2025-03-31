//
//  PointsList.swift
//  Horizon
//
//  Created by Robert on 31/03/2025.
//

import SwiftUI

struct PointsList: View {
    // MARK: -  for navigation
    let id: Int
    @Binding var path: NavigationPath
    
    @Environment(\.dismiss) private var dismiss
    @Environment(\.modelContext) private var context
    
    var body: some View {
        Text("Liste des points remarquables")
    }
}

#Preview {
    StatefulPreviewWrapper(NavigationPath()) { path in
        PointsList(id: 5, path: path)
    }
}
