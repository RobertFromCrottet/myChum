import Foundation
import CoreLocation
import MapKit
import SwiftData

// MARK: - Conformité protocoles
extension MyPoint: Identifiable {}

// MARK: - Cartographie
extension MyPoint {
    var coordinate: CLLocationCoordinate2D {
        CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
    }
}
// MARK: - UI / Images
extension MyPoint {
    var previewImage: UIImage? {
        if let image, let uiImage = UIImage(data: image) {
            return uiImage
        } else if let first = images.first {
            return UIImage(data: first)
        } else {
            return nil
        }
    }
}

// MARK: - String + asDouble
extension String {
    /// Tente de convertir une chaîne en `Double`, en remplaçant `,` par `.`
    var asDouble: Double? {
        Double(self.replacingOccurrences(of: ",", with: "."))
    }
}

// MARK: - PhotoStorageManager + Utilitaires
extension PhotoStorageManager {
    static func hasImages(for uuid: UUID) -> Bool {
        let folderURL = FileManager.default
            .urls(for: .documentDirectory, in: .userDomainMask)[0]
            .appendingPathComponent("Photos")
            .appendingPathComponent(uuid.uuidString)

        if let files = try? FileManager.default.contentsOfDirectory(at: folderURL, includingPropertiesForKeys: nil) {
            return !files.isEmpty
        }
        return false
    }
}
extension MyPoint {
    var photosFolderURL: URL {
        AppPaths.photosFolder.appendingPathComponent(id.uuidString)
    }
}
