import SwiftUI
import SwiftData

struct PointsListView: View {
    // MARK: -  for navigation
    let id: Int
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
    init(id: Int, path: Binding<NavigationPath>, previewPoints: [MyPoint]? = nil) {
        self._path = path
        self.id = id
        self.injectedPoints = previewPoints
    }  // previewPoints
    
    
    enum SortOption: String, CaseIterable {
        case name = "Nom"
        case lat = "Latitude/longitude"
        case city = "Ville"
        case country = "Pays"
        
        func descriptor() -> SortDescriptor<MyPoint> {
            switch self {
            case .name: return SortDescriptor(\.name)
             case .lat: return SortDescriptor(\.latitude)
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
                    TextField("Rechercher un point sur n'importe quelle caractéristique", text: $searchText)
                        .textFieldStyle(.roundedBorder)
                        .padding(.horizontal)
                        .onChange(of: searchText) { _ in
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
                        if pointsQuery.isEmpty {
                            importerPointsDepuisJSON(context: context)}
                        print("Nombre de points dans pointsQuery : \(pointsQuery.count)")
            points = pointsQuery
            sortPoints()
        }  //on apper
       
        .toolbar {
            ToolbarItem(placement: .principal) {
                Text("\(Image(systemName :"hand.point.right.fill"))   Liste des points remarquables (\(pointsQuery.count))")
                    .font(.system(size: 36, weight: .bold))
                    .foregroundColor(.red)
            }  //ToolbarItem

        }  //toolbar
        
        .toolbarBackground(Color.lemonYellow, for: .navigationBar)
        .toolbarBackground(.visible, for:.navigationBar)
        .navigationDestination(for: MyPoint.self) { point in
            PointDetailView(id: 5, path: $path, point: point)
                .navigationDestination(for: Destination.self) { destination in
                    destinationView(for: destination, path: $path, allPoints: allPoints)
                }
        }  // navigationDestination
        
        ZStack {
            HStack {
                HStack {
                    ButtonNav(title: "Nouveau Point", destination: .newpoint(id: 5), path: $path,tint: .mint, framsiz: 220)
                        .padding(.leading, 20)
                    Button("Chercher") {
                           isSearching = true
                    
                       }
                       .buttonStyle(.bordered)
                       .tint(.orange)

                       Button("Tout montrer") {
                           isSearching = false
                           searchText = ""
                           sortPoints()
                       }
                       .buttonStyle(.bordered)
                       .tint(.gray)
 
                    Spacer()
                    
                    Button("Navigation →") {
                        path.append(Destination.navigation(id: 2))
                    }
                    .buttonStyle(.borderedProminent)
                    .tint(.blue)
                    .clipShape(RoundedRectangle(cornerRadius: 10))
                    .padding(.trailing, 10)
                }///Hstack
            }
        } // overlay
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

#Preview {
    StatefulPreviewWrapper(NavigationPath()) { path in
        PointsListView(
            id: 5,
            path: path,
            previewPoints: [
                MyPoint(
                    name: "Tour Eiffel",
                    latitude: 48.8584,
                    longitude: 2.2945,
                    textDescription: "Un monument iconique"
                )
            ]
        )
    }
}
