//func importerPointsDepuisFrance(context: ModelContext) {
//                            print("📥 Import depuis points_france.json")
//    print("📦 Contexte : \(ObjectIdentifier(context))")
//
//    guard let url = Bundle.main.url(forResource: "points_france", withExtension: "json", subdirectory: "ImportJson"),
//          let data = try? Data(contentsOf: url) else {
//        print("❌ Fichier points_france.json introuvable dans ImportJson")
//        return
//    }
//
//    do {
//        let decoded = try JSONDecoder().decode([MyPointDTO].self, from: data)
//        print("✅ \(decoded.count) points décodés")
//
//        for point in decoded {
//            let newPoint = MyPoint(
//                name: point.name,
//                latitude: point.latitude,
//                longitude: point.longitude,
//                textDescription: "",
//                icon: "mappin",
//                image: nil,
//                city: point.city,
//                country: point.country
//            )
//            context.insert(newPoint)
//        }
//
//        print("✅ Import terminé : \(decoded.count) points insérés.")
//    } catch {
//        print("❌ Erreur de décodage : \(error)")
//    }
//}
