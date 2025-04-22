//
//  File.swift
//  Next
//
//  Created by Robert on 11/04/2025.
//

import SwiftUI

extension Button {
    func buttercup(color: Color = .blue, isEnabled: Bool = true) -> some View {
        self
            .buttonStyle(ButtercupButtonStyle(color: color, isEnabled: isEnabled))
            .disabled(!isEnabled)
    }
}
