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




//import SwiftUI
//
//struct RAMonitorView: View {
//    @State private var snapshot = RAMSnapshot.empty
//
//    var body: some View {
//        VStack(spacing: 20) {
//            Text("Utilisation mémoire")
//                .font(.title2)
//                .bold()
//
//            RAMDisplay(snapshot: snapshot, onRefresh: updateSnapshot)
//        }
//        .padding()
//        .onAppear {
//            updateSnapshot()
//        }
//    }
//
//    func updateSnapshot() {
//        let appBytes = RAMTools.memoryUsedByApp()
//        let sysBytes = RAMTools.totalMemoryUsed()
//        let totalBytes = RAMTools.totalPhysicalMemory()
//
//        snapshot = RAMSnapshot(
//            app: Double(appBytes) / (1024 * 1024),
//            system: Double(sysBytes) / (1024 * 1024),
//            total: Double(totalBytes) / (1024 * 1024)
//        )
//    }
//}
//struct RAMDisplay: View {
//    let snapshot: RAMSnapshot
//    let onRefresh: () -> Void
//
//    var body: some View {
//        VStack(spacing: 20) {
//            ZStack {
//                Circle()
//                    .stroke(Color.gray.opacity(0.2), lineWidth: 30)
//
//                Circle()
//                    .trim(from: 0, to: CGFloat(snapshot.system / snapshot.total))
//                    .stroke(Color.orange.opacity(0.4), lineWidth: 30)
//                    .rotationEffect(.degrees(-90))
//
//                Circle()
//                    .trim(from: 0, to: CGFloat(snapshot.app / snapshot.total))
//                    .stroke(Color.mint, style: StrokeStyle(lineWidth: 30, lineCap: .round))
//                    .rotationEffect(.degrees(-90))
//
//                VStack {
//                    Text(String(format: "%.1f Mo", snapshot.app))
//                        .font(.title)
//                        .bold()
//                    Text("sur \(Int(snapshot.total)) Mo")
//                        .font(.footnote)
//                        .foregroundColor(.secondary)
//                }
//            }
//            .frame(width: 200, height: 200)
//
//            VStack(spacing: 8) {
//                infoLine("App", systemImage: "app.fill", value: snapshot.app, color: .mint)
//                infoLine("Système", systemImage: "cpu", value: snapshot.system, color: .orange)
//                infoLine("Libre", systemImage: "memorychip", value: snapshot.free, color: .green)
//            }
//
//            Button("🔁 Rafraîchir") {
//                onRefresh()
//            }
//            .padding(.top)
//        }
//    }
//
//    func infoLine(_ label: String, systemImage: String, value: Double, color: Color) -> some View {
//        HStack {
//            Label(label, systemImage: systemImage)
//                .foregroundColor(color)
//            Spacer()
//            Text(String(format: "%.1f Mo", value))
//                .font(.footnote.monospaced())
//        }
//        .padding(.horizontal)
//    }
//}
