//
//  ScanHomeView.swift
//  Next
//
//  Created by Robert on 29/04/2025.
//


import SwiftUI

struct ScanHomeView: View {
    @Binding var path: NavigationPath

    var body: some View {
        VStack(spacing: 10) {
      
            BannerText(text: "Gestion des Scans", leftColor: .red, rightColor: .blue, textColor: .white, mySize: 40)
            Spacer()
            HStack {
                Spacer()
         
            ButtonNav(title: "Scanner un document", destination: .scan(id: UUID()), path: $path,tint: .mint, framsiz: 240)
            
                Spacer()
                ButtonNav(title: "Galerie des scans", destination: .scanGallery(id: UUID()), path: $path,tint: .mint, framsiz: 240)
                Spacer()
            } // HStack
                Spacer()
            CarteButton(title: "--> Navigation", color: .red) {
                path.append(Destination.navigation(id: UUID()))
            }
        }
        .padding()
        .navigationBarBackButtonHidden(true)
    }
}
