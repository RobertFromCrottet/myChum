//
//  myNavigationView.swift
//  Horizon
//
//  Created by Robert on 28/03/2025.
//

import SwiftUI


struct myNavigationView: View {
    // MARK: -  for navigation
    let id: UUID
    @Binding var path: NavigationPath
    
   // @Query private var allPoints: [MyPoint]
    var body: some View {
           BannerText(text:" Navigation", leftColor: .red, rightColor: .blue, textColor: .white, mySize: 40)
           Image("barre")
                .padding(80)
        // MARK: -  Buttons for navigation
            HStack(spacing: 30){
                ButtonNav(title: "Accueil", destination: .home(id: UUID()), path: $path,tint: .gold, framsiz: 180)
                ButtonNav(title: "Réglages", destination: .settings(id: UUID()), path: $path,tint: .blue, framsiz: 180)
                ButtonNav(title: "Utilisateurs", destination: .settings(id: UUID()), path: $path,tint: .orange, framsiz: 180)

                ButtonNav(title: "Points", destination: .pointsList(id: UUID()), path: $path,tint: .mint, framsiz: 180)
               
            
                ButtonNav(title: "Carte", destination: .map(id: UUID()), path: $path,tint: .green, framsiz: 180)
               
            }   // HStack

            Spacer()
                .navigationBarBackButtonHidden(true)
    }  // some View

}

//#Preview {
//    StatefulPreviewWrapper(NavigationPath()) { path in
//        myNavigationView(id: 4, path: path)
//    }
//}  //ppreview

