//
//  ScanGalleryView.swift
//  Next
//
//  Created by Robert on 29/04/2025.
//

import SwiftUI
import PDFKit
import UniformTypeIdentifiers

struct ScanGalleryView: View {
    @State private var pdfs: [URL] = []
    @State private var selectedPDF: URL?
    @State private var showingShareSheet = false
    @State private var showingPrintSheet = false
    @State private var showingDeleteAlert = false
    @State private var selectedOCRUrl: URL?
    @State private var showOCRSheet = false
    @State private var recognizedText: String = ""
    let scanDirectory = FileManager.scanDirectory

    var body: some View {
        NavigationView {
            List {
                if pdfs.isEmpty {
                    Text("Aucun scan trouvé.")
                        .foregroundColor(.secondary)
                } else {
                    ForEach(pdfs, id: \.self) { fileURL in
                        HStack {
                            Text(fileURL.lastPathComponent)
                                        .font(.caption)

                                    Spacer()

                                    ShareLink(items: [fileURL]) {
                                        Image(systemName: "square.and.arrow.up")
                                            .imageScale(.medium)
                            }
                            Spacer()
                            Menu {
                                Button("🔍 OCR du document") {
                                    selectedOCRUrl = fileURL
                                    showOCRSheet = true
                                }
                                .buttercup(color: .mint)
                                Button("Partager", systemImage: "square.and.arrow.up") {
                                    selectedPDF = fileURL
                                    showingShareSheet = true
                                }

                                Button("Imprimer", systemImage: "printer") {
                                    selectedPDF = fileURL
                                    showingPrintSheet = true
                                }

                                Button("Supprimer",  systemImage: "trash",role: .destructive) {
                                    selectedPDF = fileURL
                                    showingDeleteAlert = true
                                }
                            } label: {
                                Image(systemName: "ellipsis.circle")
                                    .font(.title3)
                                    .foregroundColor(.gray)
                            }
                        }
                    }
                }
            }
            .navigationTitle("📂 Mes scans")
            .onAppear(perform: loadPDFs)
            .sheet(isPresented: $showingShareSheet) {
                if let fileURL = selectedPDF {
                    ShareLink(items: [fileURL]) {
                        Label("Partager", systemImage: "square.and.arrow.up")
                    }
                }
            }
            .sheet(isPresented: $showingPrintSheet) {
                if let fileURL = selectedPDF {
                    PrintSheet(fileURL: fileURL)
                }
            }
            .sheet(isPresented: $showOCRSheet) {
                if let selectedOCRUrl = selectedOCRUrl {
                    OCRResultView(fileURL: selectedOCRUrl, recognizedText: $recognizedText)
                }
            }
            .alert("Supprimer ce fichier ?", isPresented: $showingDeleteAlert) {
                Button("Supprimer", role: .destructive) {
                    deleteSelectedPDF()
                }
                Button("Annuler", role: .cancel) { }
            }
        }
    }

    func loadPDFs() {
        if !FileManager.default.fileExists(atPath: scanDirectory.path) {
            try? FileManager.default.createDirectory(at: scanDirectory, withIntermediateDirectories: true)
        }
        if let files = try? FileManager.default.contentsOfDirectory(at: scanDirectory, includingPropertiesForKeys: nil) {
            pdfs = files.filter { $0.pathExtension.lowercased() == "pdf" }
        }
    }

    func deleteSelectedPDF() {
        if let fileURL = selectedPDF {
            try? FileManager.default.removeItem(at: fileURL)
            loadPDFs()
        }
    }
}
