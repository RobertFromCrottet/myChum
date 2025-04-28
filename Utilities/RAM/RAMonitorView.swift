////
////  RAMonitorView.swift
////  Next
////
////  Created by Robert on 12/04/2025.
////
//
//

import SwiftUI

struct RAMonitorView: View {
    let snapshot: RAMSnapshot

    var usedRatio: Double {
        guard snapshot.total > 0 else { return 0 }
        return snapshot.system / snapshot.total
    }

    var body: some View {
        VStack(spacing: 30) {
            Text("Utilisation de la mémoire")
                .font(.title2)
                .bold()

            HStack(spacing: 100) {
                VStack {
                    Image(systemName: "memorychip")
                        .font(.largeTitle)
                        .foregroundColor(.indigo)
                    Text("Total")
                    Text("\(Int(snapshot.total)) MB")
                        .font(.headline)
                }

                VStack {
                    Image(systemName: "arrow.down.circle")
                        .font(.largeTitle)
                        .foregroundColor(.green)
                    Text("Libre")
                    Text("\(Int(snapshot.free)) MB")
                        .font(.headline)
                }

                VStack {
                    Image(systemName: "flame.fill")
                        .font(.largeTitle)
                        .foregroundColor(.red)
                    Text("Utilisée")
                    Text("\(Int(snapshot.system)) MB")
                        .font(.headline)
                }
            }

            ProgressView(value: usedRatio)
                .progressViewStyle(.linear)
                .tint(.red)
                .frame(height: 8)

            Text("Utilisation : \(Int(usedRatio * 100))%")
                .font(.caption)
                .foregroundColor(.secondary)
        }
        .padding()
        .background(.thinMaterial)
        .cornerRadius(20)
        .padding()
    }
}
//#Preview {
//    RAMonitorView(snapshot: RAMSnapshot)
//}
