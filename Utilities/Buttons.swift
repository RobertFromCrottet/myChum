//
//  Buttons.swift
//  Horizon
//
//  Created by Robert on 28/03/2025.
//

import Foundation
import SwiftUI

struct ButtonNav: View {
    var title: String
    var destination: Destination
    @Binding var path: NavigationPath
    var tint: Color = .blue
    var framsiz: CGFloat = 180
    
    var body: some View {
        Button(action: {
            path.append(destination)
        }) {
            Text(title)
                .frame(maxWidth: .infinity) // force le texte à s'étaler
        }
        .buttonStyle(.borderedProminent)
        .controlSize(.regular)
        .tint(tint)
        .frame(width: framsiz)
        .contentShape(Rectangle()) // améliore la zone cliquable
    }
}

struct CarteButton: View {
    var title: String
    var color: Color = .blue
    var action: () -> Void

    var body: some View {
        Button(action: action) {
            Text(title)
        }
        .buttonStyle(CarteButtonStyle(color: color))
        .controlSize(.regular)
    }
}

struct CarteButtonStyle: ButtonStyle {
    var color: Color = .blue
   // var minWidth: CGFloat = 100

    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .frame(minWidth: 180)
            .padding(.vertical, 5)
            .font(.caption)
            .foregroundColor(.white)
            .background(color)
            .cornerRadius(12)
            .opacity(configuration.isPressed ? 0.7 : 1)
            .scaleEffect(configuration.isPressed ? 0.97 : 1)
            .animation(.easeInOut(duration: 0.2), value: configuration.isPressed)
    }
}
