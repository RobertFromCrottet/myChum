//
//  OCRManager.swift
//  Next
//
//  Created by Robert on 29/04/2025.
//


//
//  OCRManager.swift
//  Next
//
//  Created by Robert on 01/05/2025.
//

import Foundation
import Vision
import UIKit

class OCRManager {
    
    static let shared = OCRManager()
    
    private init() { }
    
    /// Analyse une image et retourne le texte détecté.
    func recognizeText(from image: UIImage, completion: @escaping (Result<String, Error>) -> Void) {
        guard let cgImage = image.cgImage else {
            completion(.failure(OCRManagerError.invalidImage))
            return
        }
        
        let request = VNRecognizeTextRequest { (request, error) in
            if let error = error {
                completion(.failure(error))
                return
            }
            
            guard let observations = request.results as? [VNRecognizedTextObservation] else {
                completion(.failure(OCRManagerError.noTextFound))
                return
            }
            
            let recognizedTexts = observations.compactMap { $0.topCandidates(1).first?.string }
            let fullText = recognizedTexts.joined(separator: "\n")
            
            completion(.success(fullText))
        }
        
        request.recognitionLanguages = ["fr-FR", "en-US"]  // Ajoute ici les langues que tu veux utiliser
        request.recognitionLevel = .accurate
        request.usesLanguageCorrection = true
        
        let requestHandler = VNImageRequestHandler(cgImage: cgImage, options: [:])
        
        DispatchQueue.global(qos: .userInitiated).async {
            do {
                try requestHandler.perform([request])
            } catch {
                completion(.failure(error))
            }
        }
    }
}

// MARK: - Erreurs spécifiques OCR
enum OCRManagerError: Error {
    case invalidImage
    case noTextFound
}