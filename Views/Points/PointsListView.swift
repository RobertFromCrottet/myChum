import SwiftUI
import SwiftData

struct PointsListView: View {
    // MARK: -  for navigation
    let id: UUID
    @Binding var path: NavigationPath
    // MARK: -  query
    @Environment(\.modelContext) private var context
    @Query var allPoints: [MyPoint]
    @Query(sort: \MyPoint.name, order: .forward)
    private var pointsQuery: [MyPoint]
    @State private var points: [MyPoint] = []
 
    // MARK: -  for sort
    @State private var sortOption: SortOption = .name
    
    private var injectedPoints: [MyPoint]?
    init(id: UUID, path: Binding<NavigationPath>, previewPoints: [MyPoint]? = nil) {
        self._path = path
        self.id = id
        self.injectedPoints = previewPoints
    }  // previewPoints
    
    
    enum SortOption: String, CaseIterable {
        case name = "Nom"
        case lat = "Latitude/longitude"
        case adresse = "Adresse"
        case city = "Ville"
        case country = "Pays"
        
        func descriptor() -> SortDescriptor<MyPoint> {
            switch self {
            case .name: return SortDescriptor(\.name)
             case .lat: return SortDescriptor(\.latitude)
                case .adresse: return SortDescriptor(\.adresse)
            case .city: return SortDescriptor(\.city)
            case .country: return SortDescriptor(\.country)
            }
        }
    }  // SortOption
    
    @State private var searchText: String = ""
    @State private var isSearching: Bool = false
    
    var body: some View {
//        NavigationStack {
            List {
                if isSearching {
                    TextField("Rechercher un point sur n'importe quelle caractéristique", text: $searchText)
                        .textFieldStyle(.roundedBorder)
                        .padding(.horizontal)
                        .onChange(of: searchText) { 
                            withAnimation {
                                sortPoints()
                            }
                        }
                    
                }
                // MARK: - Picker de tri
                Picker("Trier par", selection: $sortOption) {
                    ForEach(SortOption.allCases, id: \.self) { option in
                        Text(option.rawValue)
                    }
                }
                .pickerStyle(.segmented)
                .padding(.vertical)
                .onChange(of: sortOption, initial: false) {
                    sortPoints()
                }
                
                // MARK: - Lignes de points alignées
                ForEach(points) { point in
                    PointsCellView(id: self.id, path: $path, mypoint: point)
                        .font(.caption)
                        .padding(.vertical, 2)
                }
                .onDelete(perform: deletePoint)
            }
            
            .onAppear {
                let test = MyPoint(name: "Test", latitude: 0.0, longitude: 0.0, textDescription: "")
                print("✅ MyPoint test créé → \(test)")
                print("🍷 PointsListView est apparue")
                print("🆔 Contexte dans PointsListView :", ObjectIdentifier(context))
                print("🫙 pointsQuery.count =", pointsQuery.count)
                
                if pointsQuery.isEmpty {
                    importerPointsDepuisJSON(context: context)}
                print("👉 Tentative de sauvegarde...")
                do {
                    try context.save()
                    print("✅ Sauvegarde réussie !")
                } catch {
                    print("❌ Échec de sauvegarde :", error.localizedDescription)
                }
                print("Nombre de points dans pointsQuery : \(pointsQuery.count)")
                points = pointsQuery
                sortPoints()
            }  //on apper
            
            .toolbar(content: {
                ToolbarItem(placement: .principal) {
                    HStack {
                                                Image(systemName: "hand.point.right.fill")
                        Text("Liste des Points (\(pointsQuery.count))")
                    }
                    .font(.title)
                    .bold(true)
                    .foregroundColor(.red)
                }
            }) //toolbar
            
            .toolbarBackground(Color.lemonYellow, for: .navigationBar)
            .toolbarBackground(.visible, for:.navigationBar)
            .navigationDestination(for: MyPoint.self) { point in
                PointDetailView(id: UUID (), path: $path, point: point)
                    .navigationDestination(for: Destination.self) { destination in
                        destinationView(for: destination, path: $path, allPoints: allPoints)
                    }
            }  // navigationDestination
         
        ZStack {
            HStack {
                // Bouton custom déjà stylé, on le garde tel quel
                Button("Nouveau Point") {
                    path.append(Destination.newpoint(id: UUID()))
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
                    sortPoints()
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
        
        
//            ZStack {
//                    HStack {
//                        ButtonNav(title: "Nouveau Point", destination: .newpoint(id: UUID()), path: $path,tint: .mint, framsiz: 220)
//                            .padding(.leading, 20)
//                        Button("Chercher") {
//                            isSearching = true
//                            
//                        }
//                        .buttonStyle(.bordered)
//                        .tint(.orange)
//                        
//                        Button("Tout montrer") {
//                            isSearching = false
//                            searchText = ""
//                            sortPoints()
//                        }
//                        .buttonStyle(.bordered)
//                        .tint(.gray)
//                        
//                        Spacer()
//                        
//                        Button("Navigation →") {
//                            path.append(Destination.navigation(id: UUID()))
//                        }
//                        .buttonStyle(.borderedProminent)
//                        .tint(.blue)
//                        .clipShape(RoundedRectangle(cornerRadius: 10))
//                        .padding(.trailing, 10)
//                    }///Hstack
//            } // overlay
//        }
            .navigationBarBackButtonHidden(true)
        
        }  //body
   
    private func sortPoints() {
        var filtered = pointsQuery

        // Filtrage (recherche)
        if isSearching && !searchText.isEmpty {
            filtered = filtered.filter {
                $0.name.localizedCaseInsensitiveContains(searchText)
                || String(format: "%.4f", $0.latitude).contains(searchText)
                || String(format: "%.4f", $0.longitude).contains(searchText)
                || ($0.city ?? "").foldingForSearch.contains(searchText.foldingForSearch)
                || ($0.country ?? "").foldingForSearch.contains(searchText.foldingForSearch)
            }
        }

        // Tri sécurisé
        switch sortOption {
        case .name:
            points = filtered.sorted { $0.name < $1.name }
        case .lat:
            points = filtered.sorted { $0.latitude < $1.latitude }
        case .adresse:
            points = filtered.sorted { $0.adresse ?? "" < $1.adresse ?? ""  }
        case .city:
            points = filtered.sorted {
                ($0.city ?? "").localizedCaseInsensitiveCompare($1.city ?? "") == .orderedAscending
            }
        case .country:
            points = filtered.sorted {
                ($0.country ?? "").localizedCaseInsensitiveCompare($1.country ?? "") == .orderedAscending
            }
        }

        print("Résultats visibles : \(points.count)")
    }
    
    private func deletePoint(at offsets: IndexSet) {
        for index in offsets {
            let point = points[index]
            context.delete(point)
        }
        points.remove(atOffsets: offsets)
    }  //func delete
    
    
}  //VIEW
