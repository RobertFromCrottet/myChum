//
//  Header.swift
//  Horizon
//
//  Created by Robert on 28/03/2025.
//

import SwiftUI

struct HeaderView: View {
    var title: String = ""
    
    var body: some View {
        BannerText(text: "Hello Buddy", leftColor: .red, rightColor: .blue, textColor: .white, mySize: 40)
            .padding(.top,5)
    }
}
#Preview {
        HeaderView()
}
