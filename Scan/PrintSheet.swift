//
//  PrintSheet.swift
//  Next
//
//  Created by Robert on 29/04/2025.
//


import SwiftUI
import UIKit
import PDFKit

struct PrintSheet: UIViewControllerRepresentable {
    let fileURL: URL

    func makeUIViewController(context: Context) -> UIViewController {
        let controller = UIViewController()

        if UIPrintInteractionController.isPrintingAvailable,
           let pdf = PDFDocument(url: fileURL) {
            let printInfo = UIPrintInfo(dictionary: nil)
            printInfo.outputType = .general

            let printController = UIPrintInteractionController.shared
            printController.printInfo = printInfo
            printController.printingItem = pdf.dataRepresentation()

            DispatchQueue.main.async {
                printController.present(animated: true, completionHandler: nil)
            }
        }

        return controller
    }

    func updateUIViewController(_ uiViewController: UIViewController, context: Context) {}
}
