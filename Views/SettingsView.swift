//
//  SettingsView.swift
//  Horizon
//
//  Created by Robert on 30/03/2025.
//

import SwiftUI

struct SettingsView: View {
    
    // MARK: -  for navigation
    let id: Int
    @Binding var path: NavigationPath
    
    var body: some View {
        BannerText(text: "Réglages", leftColor: .red, rightColor: .blue, textColor: .white, mySize: 40)
            HStack(spacing: 30){
//                ButtonNav(title: "Utilisteurs->", destination: .user(id: 6), path: $path,tint: .gold, framsiz: 200)
                VStack {
                    Spacer()
                }
                ButtonNav(title: "Navigation->", destination: .navigation(id: 2), path: $path,tint: .red, framsiz: 200)
                
            }    // Hstack
            .padding(400)
//        } //NavigationStack
        Spacer()
        
        .navigationBarBackButtonHidden(true)
        .toolbarBackground(.hidden, for:.navigationBar)
    }// body
    
}  //VIEW

#Preview {
    StatefulPreviewWrapper(NavigationPath()) { path in
        SettingsView(id: 4, path: path)
    }
}  //ppreview
