//
//  SettingsView.swift
//  Horizon
//
//  Created by Robert on 30/03/2025.
//

import SwiftUI

var photosFolderURL: URL {
    let documentDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
    return documentDirectory.appendingPathComponent("Photos")}
struct RAMSnapshot {
    var app: Double
    var system: Double
    var total: Double

    var free: Double {
        max(0, total - system)
    }
    static let empty = RAMSnapshot(app: 0, system: 0, total: 1)
}
struct SettingsView: View {
    
    // MARK: -  for navigation
    let id: UUID
    @Binding var path: NavigationPath
    @State private var showImportView = false
    @State private var showPhotoFolder = false
    
    @State private var ramText = ""
    @State private var showRAMAlert = false
    @State private var showRAMonitor = false
    @State private var appRAM: Double = 0
    @State private var sysRAM: Double = 0
    @State private var totalRAM: Double = 0
    @State private var ramSnapshot: RAMSnapshot?
    
    var body: some View {
        BannerText(text: "Réglages", leftColor: .red, rightColor: .blue, textColor: .white, mySize: 40)
        
        Section {
            VStack(alignment: .leading, spacing: 8) {
                Text("💡 Maxime du codeur :")
                    .font(.headline)
                    .foregroundColor(.red)
                    .multilineTextAlignment(.center)
                Text("« En essayant continuellement, on finit par réussir. Donc : plus ça rate, plus on a de chances que ça marche. »")
                    .font(.footnote)
                    .italic()
                    .foregroundColor(.secondary)
                    .multilineTextAlignment(.leading)
            }
            .padding(.vertical, 38)
        }
        
        Spacer()
        VStack {
            
            VStack {
                if let snapshot = ramSnapshot {
                    RAMonitorView(snapshot: snapshot)
                }
                
                HStack(alignment: .center, spacing: 16) {
                    Button("📸 Dossier Photos") {
                        showPhotoFolder = true
                    }
                    .buttercup(color: .orange)
                    
                    Text(photosFolderURL.path)
                        .font(.footnote)
                        .foregroundColor(.secondary)
                        .lineLimit(1)
                        .truncationMode(.middle)
                }
                .sheet(isPresented: $showPhotoFolder) {
                    PhotoFolderView(folderURL: photosFolderURL)
                }// isPresented
            }
        
                        Button("Import JSON") {
                           
                        }
                        .buttercup(color: .mint)

            Button("Utilisation de la RAM") {
                Task {
                    let appBytes = RAMTools.memoryUsedByApp()
                    let sysBytes = RAMTools.totalMemoryUsed()
                    let totalBytes = RAMTools.totalPhysicalMemory()

                    let snapshot = RAMSnapshot(
                        app: Double(appBytes) / (1024 * 1024),
                        system: Double(sysBytes) / (1024 * 1024),
                        total: Double(totalBytes) / (1024 * 1024)
                    )

                    ramSnapshot = snapshot
                    showRAMonitor = true
                }
            }
                    Spacer()
                        .sheet(isPresented: $showPhotoFolder) {
                            PhotoFolderView(folderURL: AppPaths.photosFolder)
                        }
                           
                } //Vstack
        ZStack{
            
        ButtonNav(title: "Navigation->", destination: .navigation(id: UUID()), path: $path,tint: .red, framsiz: 200)
            
        }

        .navigationBarBackButtonHidden(true)
        .toolbarBackground(.hidden, for:.navigationBar)
    }//body
    func showRAMSheet() {
        let appBytes = RAMTools.memoryUsedByApp()
        let sysBytes = RAMTools.totalMemoryUsed()
        let totalBytes = RAMTools.totalPhysicalMemory()

        appRAM = Double(appBytes) / (1024 * 1024)
        sysRAM = Double(sysBytes) / (1024 * 1024)
        totalRAM = Double(totalBytes) / (1024 * 1024)

        DispatchQueue.main.asyncAfter(deadline: .now() + 0.01) {
            showRAMonitor = true
        }
    }
}  //VIEW

