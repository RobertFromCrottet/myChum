//
//  AppPaths.swift
//  Next
//
//  Created by Robert on 12/04/2025.
//


import Foundation

enum AppPaths {
    static var photosFolder: URL {
        let docs = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        return docs.appendingPathComponent("Photos")
    }
}