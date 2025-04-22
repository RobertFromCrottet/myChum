//
//  UInt64.swift
//  Next
//
//  Created by Robert on 07/04/2025.
//

import Foundation

public extension UInt64 {
    func toMegabytes() -> String {
        let mb = Double(self) / 1024.0 / 1024.0
        return String(format: "%.1f MB", mb)
    }
}
