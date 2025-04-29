//
//  OCRTestView.swift
//  Next
//
//  Created by Robert on 29/04/2025.
//


import SwiftUI
import PhotosUI

struct OCRTestView: View {
    @State private var selectedItem: PhotosPickerItem?
    @State private var selectedImage: UIImage?
    @State private var recognizedText: String = ""
    @State private var showAlert = false
    @State private var errorMessage = ""

    var body: some View {
        VStack(spacing: 20) {
            if let selectedImage = selectedImage {
                Image(uiImage: selectedImage)
                    .resizable()
                    .scaledToFit()
                    .frame(height: 200)
                    .cornerRadius(10)
            }
            
            PhotosPicker(selection: $selectedItem, matching: .images) {
                Label("Choisir une image", systemImage: "photo")
            }
            .onChange(of: selectedItem) { oldValue, newValue in
                if let newValue {
                    Task {
                        if let data = try? await newValue.loadTransferable(type: Data.self),
                           let uiImage = UIImage(data: data) {
                            self.selectedImage = uiImage
                            recognizeText(from: uiImage)
                        }
                    }
                }
            }
            
            ScrollView {
                Text(recognizedText.isEmpty ? "Aucun texte reconnu pour l’instant." : recognizedText)
                    .padding()
            }
            .background(Color.secondary.opacity(0.1))
            .cornerRadius(8)
            .padding()

            Spacer()
        }
        .padding()
        .alert("Erreur", isPresented: $showAlert) {
            Button("OK", role: .cancel) { }
        } message: {
            Text(errorMessage)
        }
    }
    
    func recognizeText(from image: UIImage) {
        OCRManager.shared.recognizeText(from: image) { result in
            DispatchQueue.main.async {
                switch result {
                case .success(let text):
                    recognizedText = text
                case .failure(let error):
                    errorMessage = error.localizedDescription
                    showAlert = true
                }
            }
        }
    }
}