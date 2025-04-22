//
//  RAMTools.swift
//  Next
//
//  Created by Robert on 12/04/2025.
//

import Foundation
import MachO
import Darwin

public enum RAMTools {
    
    public static func memoryUsedByApp() -> UInt64 {
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

    public static func totalMemoryUsed() -> UInt64 {
        var stats = vm_statistics64()
        var count = UInt32(MemoryLayout.size(ofValue: stats) / MemoryLayout<integer_t>.size)

        let hostPort: mach_port_t = mach_host_self()
        let result = withUnsafeMutablePointer(to: &stats) {
            $0.withMemoryRebound(to: integer_t.self, capacity: Int(count)) {
                host_statistics64(hostPort, HOST_VM_INFO64, $0, &count)
            }
        }

        if result != KERN_SUCCESS {
            return 0
        }

        let pageSize = vm_kernel_page_size
        let usedPages = stats.active_count + stats.inactive_count + stats.wire_count
        return UInt64(usedPages) * UInt64(pageSize)
    }

    public static func totalPhysicalMemory() -> UInt64 {
        return ProcessInfo.processInfo.physicalMemory
    }
}
