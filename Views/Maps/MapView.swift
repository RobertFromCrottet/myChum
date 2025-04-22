

// MARK: - Imports

import SwiftUI
import MapKit
import SwiftData

// MARK: - Struct MaPosition

struct MaPosition: Identifiable {
    let id = UUID()
    let coordinate: CLLocationCoordinate2D
}  // Maposition

// MARK: - Enum TransportOption

enum TransportOption: String, CaseIterable, Hashable {
    case voiture = "🚗 Voiture"
    case marche = "🚶‍♂️ Marche"
    case transit = "🚌 TrPublic"

    var mkType: MKDirectionsTransportType {
        switch self {
        case .voiture: return .automobile
        case .marche: return .walking
        case .transit: return .transit
        }
    }
}     // enum TransportOption


// MARK: - View MapView

struct MapView: View {

    // MARK: - Initialisation

    init(id: UUID,
         path: Binding<NavigationPath>,
         fromPoint: Bool = false,
         initialCoordinate: CLLocationCoordinate2D? = nil) {

        self.id = id
        self._path = path
        self.fromPoint = fromPoint
        self.initialCoordinate = initialCoordinate
    }  // init
    // MARK: - Propriétés de base

    let id: UUID
    @Binding var path: NavigationPath

    // MARK: - Environnement et données

    @Environment(\.modelContext) private var context
    @Query private var allPoints: [MyPoint]
    private var visibleAnnotations: [MyPoint] { allPoints }

    // MARK: - Paramètres initiaux et états

    var fromPoint: Bool = false
    var initialCoordinate: CLLocationCoordinate2D? = nil

    @State private var itinerairePolyline: MKPolyline?
    @State private var derniereDestination: CLLocationCoordinate2D?
    @StateObject private var locationManager = LocationManager()
    @FocusState private var isSearchFieldFocused: Bool
    @State private var lastSearchName: String = ""
    @State private var showPointNames = true
    var center: CLLocationCoordinate2D?
    @State private var selectedStyle: MapStyleOption = .hybrid
    @State private var camera: MapCameraPosition = .automatic
    @State private var showMarkers = true
    @State private var showSearchSheet = false
    @State private var showButtons = true

    // MARK: - Ajout et suggestion de point

    @State private var showAddPointAlert = false
    @State private var pendingCoordinate: CLLocationCoordinate2D?
    @State private var suggestedName = ""
    @State private var suggestedCity = ""

    // MARK: - Transport et itinéraire

    @State private var selectedTransport: TransportOption = .voiture
    @State private var transportType: MKDirectionsTransportType = .automobile
    @State private var avoidHighways = false
    @State private var avoidTolls = false

    // MARK: - Localisation actuelle

    var maPositionActuelle: [MaPosition] {
        guard let coord = locationManager.currentLocation else { return [] }
        return [MaPosition(coordinate: coord)]
    }

    // MARK: - Recherche et alertes

    @State private var hasDestination: Bool = false
    @State private var searchText = ""
    @State private var isSearching = false
    @State private var showSaveAlert = false
    @State private var showAddCenterPointAlert = false
    @State private var centerPointName = ""
    @State private var showToast = false
    @State private var toastMessage = ""
    
    // MARK: - save point sur carte
    
    @State private var newPointName = ""
    @State private var pendingCenter: CLLocationCoordinate2D?
    @State private var showConfirmationAlert = false
    @State private var pendingPointCoordinate: CLLocationCoordinate2D?
    @State private var pendingPointName: String = ""
    @State private var pendingPointCity: String = ""
    @State private var pendingPointAdresse: String = ""

    // MARK: - Vue principale

    var body: some View {
        VStack {
            ZStack {
                // MARK: - Choix de style et transport

                HStack {
                    Picker("Style", selection: $selectedStyle) {
                        ForEach(MapStyleOption.allCases) { option in
                            Text(option.label).tag(option)
                        }
                    }  // selected style
                    .padding(.leading)
                    
                    
                    if derniereDestination != nil {
                        Picker("Transport", selection: $selectedTransport) {
                            ForEach(TransportOption.allCases, id: \.self) { option in
                                Text(option.rawValue).tag(option)
                            } // all case
                        } //    $selectedTransport
                        .padding(.leading)
                        .transition(.opacity.combined(with: .move(edge: .top)))
                        .padding(.leading)
                    }  // if derniere destination
                    
                    // Toggle pour afficher les noms des points
                    Toggle("Afficher les noms", isOn: $showPointNames)
                        .font(.caption2)
                        .toggleStyle(.switch)
                        .frame(maxWidth: 400)
                        .padding(.trailing)
                       // .padding(.top, 4)
                    
                    Spacer()
                  
                } //Hstack/
                .pickerStyle(.segmented)
                .background(Color.lemonYellow)
                .clipShape(RoundedRectangle(cornerRadius: 10))
                
            } //ZStack
            .padding(.top)
            // MARK: - Barre de recherche

            if isSearching {
                HStack {
                    TextField("Votre Destination", text: $searchText)
                        .textFieldStyle(.roundedBorder)
                        .padding(.horizontal)
                        .focused($isSearchFieldFocused)
                }  //HStack                .transition(.move(edge: .top).combined(with: .opacity))
            } // if isSearching

            // MARK: - Curseur centré pour l'ajout
//
//            Image(systemName: "mappin.circle.fill")
//                .font(.system(size: 40))
//                .foregroundColor(.red)
//                .offset(y: -20)

            // MARK: - Carte
            
            Map(position: $camera) {
                            if let polyline = itinerairePolyline {
                                MapPolyline(polyline)
                                    .stroke(.indigo, lineWidth: 6)
                            }
                            if let destination = derniereDestination {
                                Annotation("Arrivée", coordinate: destination) {
                                    VStack(spacing: 2) {
                                        Image(systemName: "flag.checkered")
                                            .foregroundColor(.white)
                                            .font(.largeTitle)
                                        Text("Arrivée")
                                            .font(.caption2)
                                    }
                                    .padding(4)
                                }
                            }
                            ForEach(visibleAnnotations) { point in
                                Annotation(point.name, coordinate: CLLocationCoordinate2D(latitude: point.latitude, longitude: point.longitude)) {
                                    VStack(spacing: 2) {
                                        Image(systemName: point.symbol)
                                            .foregroundColor(.red)
                                        Text(point.name)
                                            .font(.caption2)
                                            .foregroundColor(.white)
                                        // 🧭 Distance affichée
                                        Text(locationManager.distance(to: CLLocationCoordinate2D(latitude: point.latitude, longitude: point.longitude)))
                                            .font(.caption2)
                                            .foregroundColor(.white)

                                        // 🥾 Durée estimée à pied
                                        Text(locationManager.estimatedWalkingTime(to: CLLocationCoordinate2D(latitude: point.latitude, longitude: point.longitude)))
                                            .font(.caption2)
                                            .foregroundColor(.white)
                                    }
                                    .padding(4)
                                }
                            }
                            ForEach(maPositionActuelle) { pos in
                                Annotation("", coordinate: pos.coordinate) {
                                    VStack(spacing: 2) {
                                        Image(systemName: "figure.walk.circle.fill")
                                            .foregroundColor(.blue)
                                            .font(.title2)
                                        Text("ma position")
                                            .font(.caption2)
                                        Text(locationManager.distance(to: pos.coordinate))
                                            .font(.caption2)
                                            .foregroundColor(.secondary)
                                        Text(locationManager.estimatedWalkingTime(to: pos.coordinate))
                                            .font(.caption2)
                                            .foregroundColor(.secondary)
                                    }
                                    .padding(4)
                                }
                            }
                            
                        }  //  Map(position: $camera)
            .mapStyle(selectedStyle.style)
            .onMapCameraChange { context in
                camera = .camera(context.camera)
            } // onMapCameraChange
            .onAppear {  // ... centrage carte initial ...
                                    if fromPoint, let coord = initialCoordinate {
                        withAnimation {
                            camera = .camera(MapCamera(centerCoordinate: coord, distance: 20000))
                        }
                    } else if let current = locationManager.currentLocation {
                        withAnimation {
                            camera = .camera(MapCamera(centerCoordinate: current, distance: 20000))
                        }
                        print("📡 Carte centrée sur localisation GPS : \(current.latitude), \(current.longitude)")
                    } else {
                        withAnimation {
                            camera = .camera(MapCamera(centerCoordinate: CLLocationCoordinate2D(latitude: 46.2710732, longitude: 4.8935231), distance: 20000))
                        }
                        print("📍 Carte centrée par défaut sur Sweet Home")
                    }
            }

            // MARK: - Alertes et feedbacks

            .alert("Créer un point ?", isPresented: $showAddPointAlert) {
                Button("Oui") {
                                   if let coord = pendingCoordinate {
                                       let defaultIcon = "mappin.and.ellipse"

                                       let point = MyPoint(
                                           name: suggestedName,
                                           latitude: coord.latitude,
                                           longitude: coord.longitude,
                                           textDescription: "",
                                           icon: "mappin",
                                           image: nil,
                                           city: suggestedCity,
                                           country: "",
                                           adresse: ""
                                       )
                                       context.insert(point)
                                   }
                               }
                               Button("Non", role: .cancel) {}
            } message: {
                Text("Souhaitez-vous créer un point \"\(suggestedName)\" à \(suggestedCity) ?")
            }

            if showToast {
                Text(toastMessage)
                    .font(.subheadline)
                    .padding()
                    .background(Color.green.opacity(0.9))
                    .cornerRadius(12)
                    .foregroundColor(.white)
                    .padding(.top, 50)
                    .transition(.move(edge: .top).combined(with: .opacity))
                    .onAppear {
                        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                            withAnimation {
                                showToast = false
                            }
                        }
                    }
            }

            // MARK: - Section d'itinéraire

            if selectedTransport == .voiture && derniereDestination != nil {
                VStack(alignment: .leading) {
                    // ... toggles éventuels ...
                }
                .padding()
                .background(.thinMaterial)
                .clipShape(RoundedRectangle(cornerRadius: 12))
                .padding(.horizontal)
                .transition(.opacity.combined(with: .slide))
            }

            // MARK: - Boutons principaux
            if showButtons {
                           HStack(spacing: 5) {
                               VStack(alignment: .leading) {
                                   CarteButton(title: "➕ Ajouter ici", color: .green) {
                                       demanderAjoutPointCentreCarte()
                                   }
                               } //Hstack
                               CarteButton(title: isSearching ? "🔍 OK" : "Aller à :", color: .yellow) {
                                   if isSearching {
                                       itinerairePolyline = nil
                                       lastSearchName = searchText

                                       rechercherLieu(nom: searchText) { coord in
                                           if let coord = coord {
                                               withAnimation {
                                                   camera = .camera(MapCamera(centerCoordinate: coord, distance: 20000))
                                               }
                                           }
                                           withAnimation {
                                               derniereDestination = coord
                                               hasDestination = coord != nil
                                           }
                                       }
                                       searchText = ""
                                   }
                                   withAnimation {
                                       isSearching.toggle()
                                       isSearchFieldFocused = isSearching
                                   }
                               }
                               if let destination = derniereDestination {
                                   CarteButton(title: "Je vous y emmène 🐎", color: .indigo) {
                                       calculerItineraireVers(destination: destination)
                                   }
                                   CarteButton(title: "📌 Ajouter à mes points", color: .green) {
                                       showSaveAlert = true
                                   }
                                   .alert("Enregistrer ce point ?", isPresented: $showSaveAlert) {
                                       Button("Oui") {
                                           ajouterPointDestination()
                                       }
                                       Button("Non", role: .cancel) {}
                                   } message: {
                                       Text("Souhaitez-vous ajouter « \(lastSearchName.isEmpty ? "Destination" : lastSearchName) » à vos points ?")
                                   }
                               }
                               Spacer()
                               CarteButton(title: "liste des points", color: .green){
                                   path.append(Destination.pointsList(id: UUID()))
                               }
                               CarteButton(title: "--> Navigation", color: .red) {
                                   path.append(Destination.navigation(id: UUID()))
                               }
                           }
                           .padding(.bottom,-5)
    
                       
//            if showButtons {
//                HStack(spacing: 5) {
//                    // ... boutons d'action ...
//                }
//                .padding(.bottom,-5)
            }
        }
        .sheet(isPresented: $showConfirmationAlert) {
            VStack(spacing: 16) {
                Text("Créer un point centré sur la carte")
                    .font(.headline)

                TextField("Nom du point", text: $pendingPointName)
                    .textFieldStyle(.roundedBorder)

                TextField("Ville", text: $pendingPointCity)
                    .textFieldStyle(.roundedBorder)

                TextField("Adresse", text: $pendingPointAdresse)
                    .textFieldStyle(.roundedBorder)

                HStack {
                    Button("Annuler") {
                        showConfirmationAlert = false
                    }
                    .foregroundColor(.red)

                    Spacer()

                    Button("Créer") {
                        if let coord = pendingPointCoordinate {
                            let point = MyPoint(
                                name: pendingPointName.isEmpty ? "Nouveau point" : pendingPointName,
                                latitude: coord.latitude,
                                longitude: coord.longitude,
                                textDescription: "",
                                icon: "mappin.and.ellipse",
                                image: nil,
                                city: pendingPointCity,
                                country: "",
                                adresse: pendingPointAdresse
                            )
                            context.insert(point)
                            print("📍 Point enregistré : \(point.name)")
                        }
                        showConfirmationAlert = false
                    }
                    .bold()
                }

                Spacer()
            }
            .padding()
            .presentationDetents([.medium])
        } // sheet enregistrer un point centre vue carte
        .navigationBarBackButtonHidden(true)
    } // body

    // MARK: - Fonctions : Itinéraire

    func calculerItineraireVers(destination: CLLocationCoordinate2D) {
            guard let start = locationManager.currentLocation else { return }
            let request = MKDirections.Request()
            request.source = MKMapItem(placemark: MKPlacemark(coordinate: start))
            request.destination = MKMapItem(placemark: MKPlacemark(coordinate: destination))
            request.transportType = selectedTransport.mkType

            let directions = MKDirections(request: request)
            directions.calculate { response, error in
                if let route = response?.routes.first {
                    itinerairePolyline = route.polyline
                    let rect = route.polyline.boundingMapRect
                    let horizontalPadding = rect.size.width * 0.3
                    let verticalPadding = rect.size.height * 0.5
                    let expandedRect = rect.insetBy(dx: -horizontalPadding, dy: -verticalPadding)
                    let region = MKCoordinateRegion(expandedRect)
                    let metersPerPoint = MKMetersPerMapPointAtLatitude(region.center.latitude)
                    let distanceMeters = metersPerPoint * max(expandedRect.size.width, expandedRect.size.height)
                    withAnimation {
                        camera = .camera(MapCamera(centerCoordinate: region.center, distance: distanceMeters))
                    }
                }
            }
        } // calculerItineraireVers
    // MARK: - Fonctions : Recherche

    func rechercherLieu(nom: String, completion: @escaping (CLLocationCoordinate2D?) -> Void) {
          let request = MKLocalSearch.Request()
          request.naturalLanguageQuery = nom
          if let currentLocation = locationManager.currentLocation {
              let region = MKCoordinateRegion(center: currentLocation, latitudinalMeters: 50000, longitudinalMeters: 50000)
              request.region = region
          }
          MKLocalSearch(request: request).start { response, error in
              if let coord = response?.mapItems.first?.placemark.coordinate {
                  completion(coord)
              } else {
                  completion(nil)
              }
          }
      } // rechercherLieu

    // MARK: - Fonctions : Ajout point destination

    func ajouterPointDestination() {
            guard let destination = derniereDestination else { return }
            let nouveauPoint = MyPoint(
                name: lastSearchName.isEmpty ? "Destination" : lastSearchName,
                latitude: destination.latitude,
                longitude: destination.longitude
            )
            context.insert(nouveauPoint)
            print("📌 Nouveau point ajouté : \(nouveauPoint.name)")
        } // ajouterPointDestination


    // MARK: - Fonctions : Double tap -> Reverse geocode

  func handleDoubleTap(at coordinate: CLLocationCoordinate2D) {
        pendingCoordinate = coordinate
        let location = CLLocation(latitude: coordinate.latitude, longitude: coordinate.longitude)
        CLGeocoder().reverseGeocodeLocation(location) { placemarks, error in
            if let placemark = placemarks?.first {
                suggestedName = placemark.name ?? "Point sans nom"
                suggestedCity = placemark.locality ?? "Inconnu"
            } else {
                suggestedName = "Point sans nom"
                suggestedCity = "Inconnu"
            }
            showAddPointAlert = true
        }
    } // handleDoubleTap

    // MARK: - Fonctions : Ajout point au centre carte
    func demanderAjoutPointCentreCarte() {
        guard let cam = camera.camera else {
            print("⚠️ Caméra non disponible.")
            return
        }

        let center = cam.centerCoordinate
        pendingPointCoordinate = center
        pendingPointName = ""
        pendingPointCity = ""
        pendingPointAdresse = ""
        showConfirmationAlert = true

        // ➕ Pré-remplir ville/adresse avec reverse geocoding
        let location = CLLocation(latitude: center.latitude, longitude: center.longitude)
        CLGeocoder().reverseGeocodeLocation(location) { placemarks, error in
            if let placemark = placemarks?.first {
                DispatchQueue.main.async {
                    pendingPointCity = placemark.locality ?? ""
                    pendingPointAdresse = placemark.name ?? ""
                }
            }
        }
    }// ajouterPointCentreCarte
    
} // view
