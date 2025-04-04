//
//  UserView.swift
//  Horizon
//
//  Created by Robert on 31/03/2025.
//

import SwiftUI

struct UserView: View {
    // MARK: -  for navigation
    let id: Int
    @Binding var path: NavigationPath
    
    @Environment(\.dismiss) private var dismiss
    @Environment(\.modelContext) private var context
    
    
    
    var body: some View {
        BannerText(text: "Utilisateurs", leftColor: .red, rightColor: .blue, textColor: .white, mySize: 40)
        Text("hello user")
        HStack(spacing: 30){
            

            ButtonNav(title: "Navigation->", destination: .navigation(id: 2), path: $path,tint: .red, framsiz: 200)
        }    // Hstack
//        .navigationBarBackButtonHidden(true)
//        .toolbarBackground(.hidden, for:.navigationBar)
    }  //body
} //View

#Preview {
    StatefulPreviewWrapper(NavigationPath()) { path in
        UserView(id: 6, path: path)
    }
}
