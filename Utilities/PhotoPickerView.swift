//
//  PhotoPickerView.swift
//  Horizon
//
//  Created by Robert on 02/04/2025.
//

import SwiftUI
import PhotosUI

struct PhotoPickerView: View {
    @Binding var imageData: Data?
    
    @State private var selectedItem: PhotosPickerItem? = nil
    
    var body: some View {
        VStack {
            if let data = imageData, let uiImage = UIImage(data: data) {
                Image(uiImage: uiImage)
                    .resizable()
                    .scaledToFit()
                    .frame(height: 200)
                    .clipShape(RoundedRectangle(cornerRadius: 12))
                    .padding(.bottom, 8)
            } else {
                Rectangle()
                    .fill(Color.secondary.opacity(0.2))
                    .frame(height: 200)
                    .overlay(Text("Aucune image"))
                    .clipShape(RoundedRectangle(cornerRadius: 12))
                    .padding(.bottom, 8)
            }
            
            PhotosPicker("Choisir une photo", selection: $selectedItem, matching: .images)
                .buttonStyle(.borderedProminent)
                .onChange(of: selectedItem) {
                    if let item = $0 {
                        Task {
                            imageData = try? await item.loadTransferable(type: Data.self)
                        }
                    }
                }
        }
    }
}
