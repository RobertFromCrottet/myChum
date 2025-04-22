//
//  SymbolPickerView.swift
//  Next
//
//  Created by Robert on 07/04/2025.
//

import SwiftUI

struct SymbolPickerView: View {
    @Binding var selected: SFIcon

    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 16) {
                ForEach(SFIcon.allCases) { icon in
                    VStack {
                        Image(systemName: icon.rawValue)
                            .resizable()
                            .scaledToFit()
                            .frame(width: 32, height: 32)
                            .padding(8)
                            .background(selected == icon ? Color.blue.opacity(0.2) : Color.clear)
                            .clipShape(Circle())
                            .onTapGesture {
                                selected = icon
                            }

                        Text(icon.label)
                            .font(.caption2)
                    }
                }
            }
            .padding(.vertical, 4)
        }
    }
}
