//
//  OCRManager.swift
//  Next
//
//  Created by Robert on 29/04/2025.
//


// OCRManager.swift
// Gestion de la reconnaissance de texte depuis une image
// Compatible iOS 16+, macOS 13+

import Foundation
import Vision
import UIKit

enum EnumOCRManager {
    // Reconnaissance de texte à partir d'une UIImage
    static func recognizeText(from image: UIImage) async throws -> String {
        guard let cgImage = image.cgImage else {
            throw NSError(domain: "OCR", code: -1, userInfo: [NSLocalizedDescriptionKey: "Image non valide"])
        }

        let request = VNRecognizeTextRequest()
        request.recognitionLevel = .accurate
        request.usesLanguageCorrection = true

        let handler = VNImageRequestHandler(cgImage: cgImage, options: [:])
        try handler.perform([request])

        let results = request.results ?? []
        let recognizedTexts = results.compactMap { observation in
            observation.topCandidates(1).first?.string
        }

        return recognizedTexts.joined(separator: "\n")
    }

    // Reconnaissance à partir de plusieurs images (ex: pages PDF converties)
    static func recognizeText(from images: [UIImage]) async throws -> String {
        var fullText = ""
        for image in images {
            let text = try await recognizeText(from: image)
            fullText += text + "\n\n"
        }
        return fullText.trimmingCharacters(in: .whitespacesAndNewlines)
    }
} 
