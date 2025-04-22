//
//  ButtercupButtonStyle.swift
//  Next
//
//  Created by Robert on 11/04/2025.
//


import SwiftUI

struct ButtercupButtonStyle: ButtonStyle {
    var color: Color = .blue
    var isEnabled: Bool = true

    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .frame(minWidth: 180)
            .padding(.vertical, 5)
            .padding(.horizontal, 25)
            .font(.caption)
            .foregroundColor(.white)
            .background(isEnabled ? color : .gray)
            .cornerRadius(12)
            .opacity(configuration.isPressed ? 0.5 : 1)
            .scaleEffect(configuration.isPressed ? 0.97 : 1)
            .animation(.easeInOut(duration: 0.2), value: configuration.isPressed)
    }
}