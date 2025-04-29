//
//  OCRResultView.swift
//  Next
//
//  Created by Robert on 29/04/2025.
//


import SwiftUI
import PDFKit

struct OCRResultView: View {
    var fileURL: URL
    @Binding var recognizedText: String
    @Environment(\.dismiss) private var dismiss

    @State private var isProcessing = true

    var body: some View {
        NavigationView {
            Group {
                if isProcessing {
                    ProgressView("Analyse du document...")
                } else {
                    ScrollView {
                        Text(recognizedText.isEmpty ? "Aucun texte reconnu." : recognizedText)
                            .padding()
                    }
                }
            }
            .navigationTitle("OCR Resultat")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Fermer") {
                        dismiss()
                    }
                }
            }
            .onAppear {
                performOCR()
            }
        }
    }

    func performOCR() {
        guard let pdfDocument = PDFDocument(url: fileURL),
              let page = pdfDocument.page(at: 0) else {
            isProcessing = false
            return
        }
        
        let pageRect = page.bounds(for: .mediaBox)
        let renderer = UIGraphicsImageRenderer(size: pageRect.size)
        let img = renderer.image { ctx in
            UIColor.white.set()
            ctx.fill(pageRect)
            page.draw(with: .mediaBox, to: ctx.cgContext)
        }

        OCRManager.shared.recognizeText(from: img) { result in
            DispatchQueue.main.async {
                switch result {
                case .success(let text):
                    recognizedText = text
                case .failure:
                    recognizedText = "Erreur lors de l'analyse."
                }
                isProcessing = false
            }
        }
    }
}