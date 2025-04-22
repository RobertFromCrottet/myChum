//
//  RAMCockpitView.swift
//  Next
//
//  Created by Robert on 07/04/2025.
//


import SwiftUI
import Darwin.Mach


struct RAMDashboardView: View {
    @State private var appMemory: UInt64 = 0
    @State private var totalMemory: UInt64 = ProcessInfo.processInfo.physicalMemory

    let timer = Timer.publish(every: 2.0, on: .main, in: .common).autoconnect()

    var progress: Double {
        guard totalMemory > 0 else { return 0 }
        return min(Double(appMemory) / Double(totalMemory), 1.0)
    }

    var body: some View {
        VStack(spacing: 24) {
            // --- Ring (cercle coloré) ---
            ZStack {
                Circle()
                    .stroke(Color.gray.opacity(0.2), lineWidth: 20)

                Circle()
                    .trim(from: 0, to: progress)
                    .stroke(
                        AngularGradient(
                            gradient: Gradient(colors: [.green, .yellow, .orange, .red]),
                            center: .center
                        ),
                        style: StrokeStyle(lineWidth: 20, lineCap: .round)
                    )
                    .rotationEffect(.degrees(-90))
                    .animation(.easeInOut(duration: 0.5), value: progress)

                VStack {
                    Text("RAM utilisée")
                        .font(.caption)
                        .foregroundStyle(.secondary)

                    Text(appMemory.toMegabytes())
                        .font(.title.bold())
                        .monospacedDigit()

                    Text("sur \(totalMemory.toMegabytes())")
                        .font(.footnote)
                        .foregroundStyle(.secondary)
                }
            }
            .frame(width: 180, height: 180)

            // --- Cockpit texte + barre ---
            VStack(spacing: 8) {
                HStack {
                    Text("App utilisée :")
                    Spacer()
                    Text(appMemory.toMegabytes())
                        .monospacedDigit()
                }

                HStack {
                    Text("RAM totale device :")
                    Spacer()
                    Text(totalMemory.toMegabytes())
                        .monospacedDigit()
                }

                ProgressView(value: Double(appMemory), total: Double(totalMemory))
                    .progressViewStyle(.linear)
                    .frame(height: 6)
            }
            .padding()
            .background(.ultraThinMaterial)
            .cornerRadius(12)
        }
        .padding()
        .onAppear { updateMemory() }
        .onReceive(timer) { _ in updateMemory() }
    }


    private func updateMemory() {
        appMemory = memoryUsedByApp()
        
        func memoryUsedByApp() -> UInt64 {
            var info = mach_task_basic_info()
            var count = mach_msg_type_number_t(MemoryLayout.size(ofValue: info) / MemoryLayout<Int32>.size)

            let kerr: kern_return_t = withUnsafeMutablePointer(to: &info) {
                $0.withMemoryRebound(to: integer_t.self, capacity: Int(count)) {
                    task_info(mach_task_self_, task_flavor_t(MACH_TASK_BASIC_INFO), $0, &count)
                }
            }

            if kerr == KERN_SUCCESS {
                return UInt64(info.resident_size)
            } else {
                return 0
            }
        }

       
    }
}
#Preview {
    RAMDashboardView()
}
