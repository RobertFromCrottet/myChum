//
//  IconPreview.swift
//  Next
//
//  Created by Robert on 08/04/2025.
//


import SwiftUI

struct IconPreview: View {
    let iconName: String

    var body: some View {
        HStack(spacing: 16) {
            Image(systemName: iconName)
                .resizable()
                .scaledToFit()
                .frame(width: 40, height: 40)
                .padding(8)
                .background(.ultraThinMaterial)
                .clipShape(RoundedRectangle(cornerRadius: 12))
                .shadow(radius: 2)

            Text(iconName)
                .font(.body)
                .foregroundColor(.primary)
        }
        .padding(.vertical, 4)
    }
}