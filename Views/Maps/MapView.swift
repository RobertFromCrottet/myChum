////
////  MapModuleView.swift
////  Horizon
////
////  Created by Robert on 28/03/2025.
////
import SwiftUI
import MapKit
import SwiftData

struct MapView: View {
    // MARK: - navigation
    let id: PersistentIdentifier
    @Binding var path: NavigationPath

    // MARK: - données
    @Query private var allPoints: [MyPoint]

    private var selectedPoint: MyPoint? {
        allPoints.first(where: { $0.id == id })
    }

    private var visibleAnnotations: [MyPoint] {
        var points: [MyPoint] = []
        if let selected = selectedPoint {
            points.append(selected)
        }
        if showMarkers {
            points += allPoints.filter { $0.id != selectedPoint?.id }
        }
        return points
    }

    // MARK: - états
    @State private var selectedStyle: MapStyleOption = .hybrid
    @State private var camera: MapCameraPosition = .automatic
    @State private var showMarkers = true
    @State private var showSearchSheet = false
    @State private var showButtons = true

    var body: some View {
        VStack {
            // MARK: - Top Controls
            VStack {
                HStack {
                    Toggle("Afficher les lieux", isOn: $showMarkers)
                        .toggleStyle(.switch)
                        .background(Color.lemonYellow)
                        .clipShape(RoundedRectangle(cornerRadius: 10))

                    Label("Macon", systemImage: "mappin.and.ellipse")
                        .frame(width: 200)
                        .background(Color.lemonYellow)
                        .clipShape(RoundedRectangle(cornerRadius: 10))
                        .padding(.leading)

                    Picker("Style", selection: $selectedStyle) {
                        ForEach(MapStyleOption.allCases) { option in
                            Text(option.label).tag(option)
                        }
                    }
                    .pickerStyle(.segmented)
                    .background(Color.lemonYellow)
                    .clipShape(RoundedRectangle(cornerRadius: 10))
                }
                .frame(width: 650)
                .padding(10)
                .font(.caption2)
                .background(.regularMaterial)
                .clipShape(RoundedRectangle(cornerRadius: 10))
                .padding(.horizontal)
            }

            // MARK: - Map
            Map(position: $camera) {
                ForEach(visibleAnnotations) { point in
                    Annotation(point.name, coordinate: CLLocationCoordinate2D(latitude: point.latitude, longitude: point.longitude)) {
                        VStack(spacing: 2) {
                            Image(systemName: point.icon)
                                .foregroundColor(.red)
                            Text(point.name)
                                .font(.caption2)
                        }
                        .padding(4)
                    }
                }
            }
            .mapStyle(selectedStyle.style)
            .clipShape(RoundedRectangle(cornerRadius: 20))
            .onAppear {
                if let selected = selectedPoint {
                    withAnimation {
                        camera = .camera(
                            MapCamera(
                                centerCoordinate: CLLocationCoordinate2D(latitude: selected.latitude, longitude: selected.longitude),
                                distance: 20000
                            )
                        )
                    }
                }
            }

            // MARK: - Bottom Buttons
            if showButtons {
                HStack(spacing: 5) {
                    CarteButton(title: "Paris", color: .yellow) {
                        withAnimation {
                            camera = .camera(
                                MapCamera(centerCoordinate: .paris, distance: 20000)
                            )
                        }
                    }

                    CarteButton(title: "Recherche", color: .yellow) {
                        showSearchSheet = true
                    }

                    CarteButton(title: "Revenir à Crottet") {
                        withAnimation {
                            camera = .camera(
                                MapCamera(centerCoordinate: .crottet, distance: 25000)
                            )
                        }
                    }

                    Spacer()

//                    CarteButton(title: "--> Navigation", color: .red) {
//                        path.append(Destination.navigation(id: id))
//                    }
                }
                .padding()
            }
        }
        .navigationBarBackButtonHidden(true)
        .toolbarBackground(.hidden, for: .navigationBar)
    }
}
extension CLLocationCoordinate2D {
 //   static let crottet = CLLocationCoordinate2D(latitude: 46.2931, longitude: 4.8524)
    static let paris = CLLocationCoordinate2D(latitude: 48.8566, longitude: 2.3522)
}
//import SwiftUI
//import MapKit
//import SwiftData
//
//struct MapView: View {
//    // MARK: - navigation
//    let id: PersistentIdentifier
//    @Binding var path: NavigationPath
//
//    // MARK: - données
//    @Query private var allPoints: [MyPoint]
//
//    private var selectedPoint: MyPoint? {
//        allPoints.first(where: { $0.id == id })
//    }
//
//    private var visibleAnnotations: [MyPoint] {
//        var points: [MyPoint] = []
//        if let selected = selectedPoint {
//            points.append(selected)
//        }
//        if showMarkers {
//            points += allPoints.filter { $0.id != selectedPoint?.id }
//        }
//        return points
//    }
//
//    // MARK: - états
//    @State private var selectedStyle: MapStyleOption = .hybrid
//    @State private var camera: MapCameraPosition = .automatic
//    @State private var showMarkers = true
//    @State private var showSearchSheet = false
//    @State private var showButtons = true
//
//    var body: some View {
//        VStack {
//            // MARK: - Top Controls
//            VStack {
//                HStack {
//                    Toggle("Afficher les lieux", isOn: $showMarkers)
//                        .toggleStyle(.switch)
//                        .background(Color.lemonYellow)
//                        .clipShape(RoundedRectangle(cornerRadius: 10))
//
//                    Label("Macon", systemImage: "mappin.and.ellipse")
//                        .frame(width: 200)
//                        .background(Color.lemonYellow)
//                        .clipShape(RoundedRectangle(cornerRadius: 10))
//                        .padding(.leading)
//
//                    Picker("Style", selection: $selectedStyle) {
//                        ForEach(MapStyleOption.allCases) { option in
//                            Text(option.label).tag(option)
//                        }
//                    }
//                    .pickerStyle(.segmented)
//                    .background(Color.lemonYellow)
//                    .clipShape(RoundedRectangle(cornerRadius: 10))
//                }
//                .frame(width: 650)
//                .padding(10)
//                .font(.caption2)
//                .background(.regularMaterial)
//                .clipShape(RoundedRectangle(cornerRadius: 10))
//                .padding(.horizontal)
//            }
//
//            // MARK: - Map
//            Map(position: $camera) {
//                ForEach(visibleAnnotations) { point in
//                    Annotation(point.name, coordinate: CLLocationCoordinate2D(latitude: point.latitude, longitude: point.longitude)) {
//                        VStack(spacing: 2) {
//                            Image(systemName: point.icon)
//                                .foregroundColor(.red)
//                            Text(point.name)
//                                .font(.caption2)
//                        }
//                        .padding(4)
//                    }
//                }
//            }
//            .mapStyle(selectedStyle.style)
//            .clipShape(RoundedRectangle(cornerRadius: 20))
//            .onAppear {
//                if let selected = selectedPoint {
//                    withAnimation {
//                        camera = .camera(
//                            MapCamera(
//                                centerCoordinate: CLLocationCoordinate2D(latitude: selected.latitude, longitude: selected.longitude),
//                                distance: 20000
//                            )
//                        )
//                    }
//                }
//            }
//
//            // MARK: - Bottom Buttons
//            if showButtons {
//                HStack(spacing: 5) {
//                    CarteButton(title: "Paris", color: .yellow) {
//                        withAnimation {
//                            camera = .camera(
//                                MapCamera(centerCoordinate: .paris, distance: 20000)
//                            )
//                        }
//                    }
//
//                    CarteButton(title: "Recherche", color: .yellow) {
//                        showSearchSheet = true
//                    }
//
//                    CarteButton(title: "Revenir à Crottet") {
//                        withAnimation {
//                            camera = .camera(
//                                MapCamera(centerCoordinate: .crottet, distance: 25000)
//                            )
//                        }
//                    }
//
//                    Spacer()
//
//                    CarteButton(title: "--> Navigation", color: .red) {
//                        path.append(Destination.navigation(id: id))
//                    }
//                }
//                .padding()
//            }
//        }
//        .navigationBarBackButtonHidden(true)
//        .toolbarBackground(.hidden, for: .navigationBar)
//    }
//}
//import SwiftUI
//import MapKit
//import SwiftData
//
//struct MapView: View {
//    // MARK: -  navigation
//    let id: PersistentIdentifier
//    @Binding var path: NavigationPath
//
//    // MARK: -  data
//    @Query private var allPoints: [MyPoint]
//    
//    private var selectedPoint: MyPoint? {
//        allPoints.first(where: { $0.id == id })
//    }
//
//    private var visibleAnnotations: [MyPoint] {
//        var list: [MyPoint] = []
//        if let selected = selectedPoint {
//            list.append(selected)
//        }
//        if showMarkers {
//            list += allPoints.filter { $0.id != selectedPoint?.id }
//        }
//        return list
//    }
//
//    // MARK: -  UI states
//    @State private var showMarkers = true
//    @State private var showSearchSheet = false
//    @State private var showButtons = true
//    @State private var selectedStyle: MapStyleOption = .hybrid
//
//    @State private var camera: MapCameraPosition = .camera(
//        MapCamera(centerCoordinate: .crottet, distance: 30000)
//    )
//
//    var body: some View {
//        VStack {
//            // MARK: - Top Bar
//            VStack {
//                HStack {
//                    Toggle("Afficher les lieux", isOn: $showMarkers)
//                        .toggleStyle(.switch)
//                        .background(Color.lemonYellow)
//                        .clipShape(RoundedRectangle(cornerRadius: 10))
//                    
//                    Label("Macon", systemImage: "mappin.and.ellipse")
//                        .frame(width: 200)
//                        .background(Color.lemonYellow)
//                        .clipShape(RoundedRectangle(cornerRadius: 10))
//                        .padding(.leading)
//
//                    Picker("Style", selection: $selectedStyle) {
//                        ForEach(MapStyleOption.allCases) { option in
//                            Text(option.label).tag(option)
//                        }
//                    }
//                    .pickerStyle(.segmented)
//                    .background(Color.lemonYellow)
//                    .clipShape(RoundedRectangle(cornerRadius: 10))
//                }
//                .frame(width: 650)
//                .padding(10)
//                .font(.caption2)
//                .background(.regularMaterial)
//                .clipShape(RoundedRectangle(cornerRadius: 10))
//                .padding(.horizontal)
//            }
//
//            // MARK: - Map
//            Map(position: $camera) {
//                ForEach(visibleAnnotations) { point in
//                    Annotation(point.name, coordinate: CLLocationCoordinate2D(latitude: point.latitude, longitude: point.longitude)) {
//                        VStack(spacing: 2) {
//                            Image(systemName: point.icon)
//                                .foregroundColor(.red)
//                            Text(point.name)
//                                .font(.caption2)
//                        }
//                        .padding(4)
//                    }
//                }
//            }
//            .mapStyle(selectedStyle.style)
//            .clipShape(RoundedRectangle(cornerRadius: 20))
//            .onAppear {
//                if let selected = selectedPoint {
//                    withAnimation {
//                        camera = .camera(
//                            MapCamera(centerCoordinate: CLLocationCoordinate2D(latitude: selected.latitude, longitude: selected.longitude), distance: 20000)
//                        )
//                    }
//                }
//            }
//
//            // MARK: - Bottom Buttons
//            if showButtons {
//                HStack(spacing: 5) {
//                    CarteButton(title: "Paris", color: .yellow) {
//                        camera = .camera(MapCamera(centerCoordinate: .paris, distance: 20000))
//                    }
//
//                    CarteButton(title: "Recherche", color: .yellow) {
//                        showSearchSheet = true
//                    }
//
//                    CarteButton(title: "Revenir à Crottet") {
//                        withAnimation {
//                            camera = .camera(MapCamera(centerCoordinate: .crottet, distance: 25000))
//                        }
//                    }
//
//                    Spacer()
//
//                    CarteButton(title: "--> Navigation", color: .red) {
//                        path.append(Destination.navigation(id: 2))
//                    }
//                }
//                .padding()
//            }
//        }
//        .navigationBarBackButtonHidden(true)
//        .toolbarBackground(.hidden, for: .navigationBar)
//    }
//}
//extension CLLocationCoordinate2D {
// //   static let crottet = CLLocationCoordinate2D(latitude: 46.2931, longitude: 4.8524)
//    static let paris = CLLocationCoordinate2D(latitude: 48.8566, longitude: 2.3522)
//}
