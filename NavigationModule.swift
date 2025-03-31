//
//  NavigationModule.swift
//  Horizon
//
//  Created by Robert on 28/03/2025.
//

import Foundation
import SwiftUI

//case home(id: Int)//1
//case navigation(id: Int) //2
//case map(id: Int) //3
//case settings(id: Int) //4
//case point(id: Int) // 5

/// Fonction qui retourne la bonne vue selon la destination
func destinationView(for destination: Destination, path: Binding<NavigationPath>) -> AnyView {
    
    switch destination {
        
    case .home(let id):
        return AnyView(HomeView(id: id, path: path))  //1
    case .navigation(let id):
        return AnyView(NavigationView(id: id, path: path)) //2
    case .map(let id):
        return AnyView(MapView(id: id, path: path))  //3
    case .settings(let id):
        return AnyView(SettingsView(id: id, path: path)) //4
    case .point(let id):
        return AnyView(AddPointView(id: id, path: path))  //5
    case .user(let id):
        return AnyView(UserView(id: id, path: path))  //6
        
    }   //SWITCH
}
