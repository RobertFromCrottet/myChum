//
//  ElegantBackButtonModifier.swift
//  Next
//
//  Created by Robert on 08/04/2025.
//


import SwiftUI

struct ElegantBackButtonModifier: ViewModifier {
    @Environment(\.dismiss) private var dismiss

    var label: String = "Retour"
    var icon: String = "chevron.backward"

    func body(content: Content) -> some View {
        content
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button {
                        dismiss()
                    } label: {
                        Label(label, systemImage: icon)
                            .font(.headline)
                    }
                }
            }
            .navigationBarBackButtonHidden(true)
    }
}

extension View {
    func elegantBackButton(label: String = "Retour", icon: String = "chevron.backward") -> some View {
        self.modifier(ElegantBackButtonModifier(label: label, icon: icon))
    }
}