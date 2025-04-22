//
//  PhotoCarouselView.swift
//  Next
//
//  Created by Robert on 08/04/2025.
//


import SwiftUI

struct PhotoCarouselView: View {
    let images: [Data]
    @State private var resizedImages: [Int: UIImage] = [:]

    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 12) {
                ForEach(images.indices, id: \.self) { index in
                    if let resized = resizedImages[index] {
                        Image(uiImage: resized)
                            .resizable()
                            .scaledToFill()
                            .frame(width: 200, height: 140)
                            .clipped()
                            .cornerRadius(10)
                            .shadow(radius: 2)
                    } else if let uiImage = UIImage(data: images[index]) {
                        let small = uiImage.resized(to: CGSize(width: 400, height: 300)) ?? uiImage
                        Image(uiImage: small)
                            .resizable()
                            .scaledToFill()
                            .frame(width: 200, height: 140)
                            .clipped()
                            .cornerRadius(10)
                            .shadow(radius: 2)
                            .onAppear {
                                resizedImages[index] = small
                            }
                    }
                }
            }
            .padding(.horizontal)
        }
    }
}
