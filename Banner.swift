//
//  Banner.swift
//  Horizon
//
//  Created by Robert on 28/03/2025.
//

import Foundation
import SwiftUI

struct BannerText: View {

    var text: String
    var leftColor: Color
    var rightColor: Color
    var textColor: Color
    var mySize: CGFloat
    
    var body: some View {
        Text(text)
            .font(.system(size: 40))
            .bold()
            .italic()
            .frame(maxWidth: .infinity, maxHeight: 60)
            .background(
                LinearGradient(colors: [leftColor, rightColor],
                               startPoint: .topLeading,
                               endPoint: .bottomTrailing)
                //.opacity(0.8)
                .shadow(.drop(radius: 2, y: 2)),
                ignoresSafeAreaEdges: .top)
            .foregroundStyle(textColor)
            .cornerRadius(15)
    }
}

#Preview {
BannerText(text: "Hello i'm the boss",leftColor:.red, rightColor: .blue, textColor: .white, mySize: 40)
}
