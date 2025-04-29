//
//  PDFKitView.swift
//  Next
//
//  Created by Robert on 29/04/2025.
//


import SwiftUI
import PDFKit

struct PDFKitView: UIViewRepresentable {
    let url: URL

    func makeUIView(context: Context) -> PDFView {
        let view = PDFView()
        view.document = PDFDocument(url: url)
        view.autoScales = true
        return view
    }

    func updateUIView(_ uiView: PDFView, context: Context) {}
}