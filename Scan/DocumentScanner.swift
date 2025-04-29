//
//  DocumentScanner.swift
//  Next
//
//  Created by Robert on 29/04/2025.
//


import SwiftUI
import VisionKit
import PDFKit

struct DocumentScanner: UIViewControllerRepresentable {
    var onScanComplete: (URL?) -> Void

    func makeCoordinator() -> Coordinator {
        Coordinator(onScanComplete: onScanComplete)
    }

    func makeUIViewController(context: Context) -> VNDocumentCameraViewController {
        let scanner = VNDocumentCameraViewController()
        scanner.delegate = context.coordinator
        return scanner
    }

    func updateUIViewController(_ uiViewController: VNDocumentCameraViewController, context: Context) {}

    class Coordinator: NSObject, VNDocumentCameraViewControllerDelegate {
        let onScanComplete: (URL?) -> Void

        init(onScanComplete: @escaping (URL?) -> Void) {
            self.onScanComplete = onScanComplete
        }

        func documentCameraViewController(_ controller: VNDocumentCameraViewController, didFinishWith scan: VNDocumentCameraScan) {
            let pdf = PDFDocument()
            for i in 0..<scan.pageCount {
                let image = scan.imageOfPage(at: i)
                let pdfPage = PDFPage(image: image)
                pdf.insert(pdfPage!, at: pdf.pageCount)
            }

            let url = ScanManager.save(pdf: pdf)
            controller.dismiss(animated: true) {
                self.onScanComplete(url)
            }
        }

        func documentCameraViewControllerDidCancel(_ controller: VNDocumentCameraViewController) {
            controller.dismiss(animated: true) {
                self.onScanComplete(nil)
            }
        }

        func documentCameraViewController(_ controller: VNDocumentCameraViewController, didFailWithError error: Error) {
            print("Erreur scanner : \(error)")
            controller.dismiss(animated: true) {
                self.onScanComplete(nil)
            }
        }
    }
}