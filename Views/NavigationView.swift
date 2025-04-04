//
//  NavigationView.swift
//  Horizon
//
//  Created by Robert on 28/03/2025.
//

import SwiftUI

struct NavigationView: View {
    // MARK: -  for navigation
    let id: Int
    @Binding var path: NavigationPath
   // @Query private var allPoints: [MyPoint]
    var body: some View {
           BannerText(text:" Navigation", leftColor: .red, rightColor: .blue, textColor: .white, mySize: 40)
           Image("barre")
                .padding(80)
        // MARK: -  Buttons for navigation
            HStack(spacing: 30){
                ButtonNav(title: "Accueil", destination: .home(id: 1), path: $path,tint: .gold, framsiz: 180)
                ButtonNav(title: "Réglages", destination: .settings(id: 4), path: $path,tint: .blue, framsiz: 180)
                ButtonNav(title: "Utilisateurs", destination: .settings(id: 6), path: $path,tint: .orange, framsiz: 180)
//                if let firstID = allPoints.first?.id {
//                    ButtonNav(title: "Carte", destination: .map(id: firstID), path: $path, tint: .green, framsiz: 180)
//                } else {
//                    Text("Aucun point disponible pour la carte")
//                        .foregroundStyle(.secondary)
//                }
//                ButtonNav(title: "Carte", destination: .map(id: 3), path: $path,tint: .green, framsiz: 180)
                ButtonNav(title: "Points", destination: .point(id: 5), path: $path,tint: .mint, framsiz: 180)
            }   // HStack

            Spacer()
                .navigationBarBackButtonHidden(true)
    }  // some View

}

#Preview {
    StatefulPreviewWrapper(NavigationPath()) { path in
        NavigationView(id: 4, path: path)
    }
}  //ppreview

