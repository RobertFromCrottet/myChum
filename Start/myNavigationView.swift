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
    
    @State var isRotated: Bool = false
    
    // MARK: - body
    var body: some View {
        
        // MARK: - banner
           BannerText(text:" Navigation", leftColor: .red, rightColor: .blue, textColor: .white, mySize: 40)
           Image("barre")
            .rotationEffect(.degrees(isRotated ?180 : 0))
            .onAppear {
                withAnimation(.easeInOut(duration: 10)) {
                    self.isRotated.toggle()
                }
            }
            .onTapGesture {
                    withAnimation(.easeInOut(duration: 10)) {
                    self.isRotated.toggle()
                }
            }
            .padding(80)
        
        // MARK: -  Buttons for navigation
        VStack{
            // MARK: -  first row
            HStack(spacing: 30){
                ButtonNav(title: "Contacts", destination: .usersList(id: UUID()), path: $path,tint: .orange, framsiz: 180)
                ButtonNav(title: "Materiel", destination: .usersList(id: UUID()), path: $path,tint: .purple, framsiz: 180)
                ButtonNav(title: "Points", destination: .pointsList(id: UUID()), path: $path,tint: .mint, framsiz: 180)
                ButtonNav(title: "Carte", destination: .mapNav(id: UUID()), path: $path,tint: .green, framsiz: 180)
            }   // HStack
            
            // MARK: -  second row
            HStack(spacing: 30){
                ButtonNav(title: "Réglages", destination: .settings(id: UUID()), path: $path,tint: .gold, framsiz: 180)
                ButtonNav(title: "Scans", destination: .scanHome(id: UUID()), path: $path,tint: .blue, framsiz: 180)
            }   // HStack
        } // VStack
            Spacer()
        
        // MARK: - bottom button
        HStack(spacing: 30){
            Spacer()
            ButtonNav(title: "Accueil->", destination: .home(id: UUID()), path: $path,tint: .skyBlue, framsiz: 200)
                .padding(.horizontal, 20)
            }    // Hstack
        
        // MARK: - navigationBar
        .navigationBarBackButtonHidden(true)
    }  // some View

} //view

