//
//  ScanDocumentView.swift
//  Next
//
//  Created by Robert on 29/04/2025.
//


import SwiftUI
import VisionKit
import PDFKit
import UniformTypeIdentifiers
import VisionKit

struct ScanDocumentView: View {
    @State private var showScanner = false
    @State private var scannedPDFs: [URL] = []
    @State private var selectedPDF: URL? = nil
    @State private var showShareSheet = false

    var body: some View {
        NavigationView {
            VStack {
                Button {
                    showScanner = true
                } label: {
                    Label("📸 Scanner un document", systemImage: "doc.viewfinder")
                        .padding()
                        .frame(maxWidth: .infinity)
                }
                .buttonStyle(.borderedProminent)
                .padding()

                if scannedPDFs.isEmpty {
                    Text("Aucun document scanné")
                        .foregroundColor(.gray)
                        .padding()
                } else {
                    List {
                        ForEach(scannedPDFs, id: \.self) { pdf in
                            HStack {
                                Image(systemName: "doc.richtext")
                                    .foregroundColor(.blue)
                                Text(pdf.lastPathComponent)
                                    .lineLimit(1)
                                Spacer()
                                Button {
                                    selectedPDF = pdf
                                    showShareSheet = true
                                } label: {
                                    Image(systemName: "square.and.arrow.up")
                                }
                            }
                            .contentShape(Rectangle())
                            .onTapGesture {
                                selectedPDF = pdf
                            }
                        }
                    }
                }
            }
            .navigationTitle("Documents scannés")
            .sheet(isPresented: $showScanner) {
                DocumentScanner { result in
                    if let url = result {
                        scannedPDFs.insert(url, at: 0)
                    }
                    showScanner = false
                }
            }
            .sheet(item: $selectedPDF) { pdfURL in
                PDFKitView(url: pdfURL)
            }
            .sheet(isPresented: $showShareSheet) {
                if let url = selectedPDF {
                    ShareSheet(items: [url])
                }
            }
            .onAppear {
                scannedPDFs = ScanManager.listScans()
            }
        } // navigation view
    }  // body
    
} // vieew
