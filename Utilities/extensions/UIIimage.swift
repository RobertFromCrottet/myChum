//
//  UIIimage.swift
//  Next
//
//  Created by Robert on 11/04/2025.
//

import Foundation
import UIKit

extension UIImage {
    func resized(to maxSize: CGSize) -> UIImage? {
        let aspectWidth = maxSize.width / size.width
        let aspectHeight = maxSize.height / size.height
        let aspectRatio = min(aspectWidth, aspectHeight)

        let newSize = CGSize(width: size.width * aspectRatio, height: size.height * aspectRatio)

        UIGraphicsBeginImageContextWithOptions(newSize, false, 0.0)
        draw(in: CGRect(origin: .zero, size: newSize))
        let resizedImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()

        return resizedImage
    }
}
