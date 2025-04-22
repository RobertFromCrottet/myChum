//
//  SystemStats.swift
//  Next
//
//  Created by Robert on 07/04/2025.
//


import Foundation
import SwiftUI

public struct SystemStats {
    public static var appMemoryUsage: UInt64 {
        memoryUsedByApp()
    }

    public static var totalRAM: UInt64 {
        ProcessInfo.processInfo.physicalMemory
    }

    public static var uptime: TimeInterval {
        ProcessInfo.processInfo.systemUptime
    }

    public static func uptimeFormatted() -> String {
        let interval = uptime
        let formatter = DateComponentsFormatter()
        formatter.allowedUnits = [.day, .hour, .minute]
        formatter.unitsStyle = .abbreviated
        return formatter.string(from: interval) ?? "-"
    }

    public static var isBatteryMonitoringAvailable: Bool {
        #if os(iOS)
        return true
        #else
        return false
        #endif
    }

    // ✅ Utilisation sûre avec Swift Concurrency
    @MainActor
    public static func batteryLevel() -> Float? {
        #if os(iOS)
        UIDevice.current.isBatteryMonitoringEnabled = true
        return UIDevice.current.batteryLevel
        #else
        return nil
        #endif
    }
}
