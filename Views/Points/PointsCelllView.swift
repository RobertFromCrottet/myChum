//
//  PointsCelllView.swift
//  Horizon
//
//  Created by Robert on 01/04/2025.
//

import SwiftUI
import CoreLocation
import SwiftData

struct PointsCellView: View {
    // MARK: -  for navigation
    let id: UUID
    @Binding var path: NavigationPath
    
    let mypoint: MyPoint
    
    var body: some View {
        
        NavigationLink(value: mypoint) {
            HStack(alignment: .top) {
//                VStack {
                    HStack  {
                        if let img = mypoint.previewImage {
                                        Image(uiImage: img)
                                            .resizable()
                                            .scaledToFill()
                                            .frame(width: 50, height: 50)
                                            .clipped()
                                            .cornerRadius(8)
                                    } else {
                                        Image(systemName: mypoint.symbol)
                                            .resizable()
                                            .scaledToFit()
                                            .frame(width: 36, height: 36)
                                            .padding(8)
                                            .background(Color(.systemGray5))
                                            .clipShape(RoundedRectangle(cornerRadius: 8))
                                            .foregroundColor(.gray)
                                    }
                        Text("\(mypoint.name)")
                            .font(.callout)
                            .foregroundStyle(.red)
                            .frame(maxWidth:350, alignment: .leading)
//                        VStack(alignment: .trailing) {
                            Text(String(format: "%.4f", mypoint.latitude))
                                .font(.caption)
                                .foregroundStyle(.blue)
                                .frame(maxWidth: 120, alignment: .leading)
                        Text("/   ")
                            Text(String(format: "%.4f", mypoint.longitude))
                                .font(.caption)
                                .foregroundStyle(.blue)
                                .frame(maxWidth: 120, alignment: .leading)
                            
                        Text(mypoint.city ?? "  ")
                                .font(.caption)
                                .foregroundStyle(.blue)
                                .frame(maxWidth: 300, alignment: .leading)
                        Text(mypoint.country ?? "  ")
                            .font(.caption)
                            .foregroundStyle(.blue)
                            .frame(maxWidth: 300, alignment: .leading)
                    }//Hstack
                    .font(.caption)
                    .background(.mint.opacity(0.1))
//                }   // VStack
            } // HStack
        } //NavigationLink
        
    }
}
