//
//  UserListView.swift
//  Next
//
//  Created by Robert on 29/04/2025.
//

import SwiftUI
import SwiftData


struct UsersListView: View {
    // MARK: -  for navigation
    let id: UUID
    @Binding var path: NavigationPath
    
    // MARK: -  query
    @Environment(\.modelContext) private var context
    @Query var allUsers: [MyUser]
    @Query(sort: \MyUser.name, order: .forward)
    private var usersQuery: [MyUser]
    @State private var users: [MyUser] = []
    
    // MARK: -  for sort
    @State private var sortOption: SortOption = .name
    enum SortOption: String, CaseIterable {
        case name = "Nom"
        case mail = "Email"
        case adresse = "Adresse"
        case city = "Ville"
        case country = "Pays"
        
        func descriptor() -> SortDescriptor<MyUser> {
            switch self {
            case .name: return SortDescriptor(\.name)
             case .mail: return SortDescriptor(\.email)
                case .adresse: return SortDescriptor(\.adress1)
            case .city: return SortDescriptor(\.city)
            case .country: return SortDescriptor(\.country)
            }
        }
    }  // SortOption
    
    @State private var searchText: String = ""
    @State private var isSearching: Bool = false
    var body: some View {
        List {
            if isSearching {
                TextField("Rechercher un Utilisateur sur n'importe quelle caractéristique", text: $searchText)
                    .textFieldStyle(.roundedBorder)
                    .padding(.horizontal)
                    .onChange(of: searchText) {
                        withAnimation {
                           // sortPoints()
                        }
                    }
                
            }
        }//list
        .toolbar(content: {
            ToolbarItem(placement: .principal) {
                HStack {
                                            Image(systemName: "hand.point.right.fill")
                    Text("Liste des Points (\(usersQuery.count))")
                }
                .font(.title)
                .bold(true)
                .foregroundColor(.red)
            }
        }) //toolbar
        ZStack {
            HStack {
                // Bouton custom déjà stylé, on le garde tel quel
                Button("Nouvel User") {
                 //   path.append(Destination.newpoint(id: UUID()))
                }
                .buttercup(color: .green)
                .padding(.leading, 20)
                
                // Chercher
                Button("Chercher") {
                    isSearching = true
                }
                .buttercup(color: .green)
                
                // Tout montrer
                Button("Tout montrer") {
                    isSearching = false
                    searchText = ""
                   // sortPoints()
                }
                .buttercup(color: .green)
                
                Spacer()
                
                // Navigation
                Button("Navigation →") {
                    path.append(Destination.navigation(id: UUID()))
                }
                .buttercup(color: .red)
                .padding(.trailing, 10)
            }
        }
    }
}
