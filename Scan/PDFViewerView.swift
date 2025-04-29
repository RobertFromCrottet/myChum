//
//  PDFViewerView.swift
//  Next
//
//  Created by Robert on 29/04/2025.
//

import SwiftUI
import PDFKit

struct PDFViewerView: View {
    let url: URL

    var body: some View {
        if let pdf = PDFDocument(url: url) {
            PDFKitRepresentedView(pdfDocument: pdf)
        } else {
            Text("❌ Impossible de charger le PDF")
        }
    }
}

struct PDFKitRepresentedView: UIViewRepresentable {
    let pdfDocument: PDFDocument

    func makeUIView(context: Context) -> PDFView {
        let pdfView = PDFView()
        pdfView.document = pdfDocument
        pdfView.autoScales = true
        return pdfView
    }

    func updateUIView(_ uiView: PDFView, context: Context) {}
}
