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
    let id: Int
    @Binding var path: NavigationPath
    
    let mypoint: MyPoint
    
    var body: some View {
        
        NavigationLink(value: mypoint) {
            HStack(alignment: .top) {
//                VStack {
                    HStack  {
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

#Preview {
    StatefulPreviewWrapper(NavigationPath()) { path in
        PointsCellView(
            id: 5,
            path: path,
            mypoint: MyPoint(
                name: "Tour Eiffel",
                latitude: 48.8584,
                longitude: 2.2945,
                textDescription: "Un monument iconique"
            )
        )
    }
}
