//
//  DefaultToilets.swift
//  FINAL_<55>
//
//  Created by haoning yin on 11/26/24.
//

import Foundation
import FirebaseFirestore

struct DefaultToilets {
    static let toilets: [Toilet] = [
        Toilet(
            id: nil,
            name: "Public Restroom 1",
            address: "123 Main Street, Boston, MA",
            location: GeoPoint(latitude: 42.3601, longitude: -71.0589),
            openingHours: "Monday - Sunday, 8 a.m. - 10 p.m.",
            type: ["Public", "Accessible"],
            rating: 4.5,
            reviews: []
        ),
        Toilet(
            id: nil,
            name: "Public Restroom 2",
            address: "456 Elm Street, Cambridge, MA",
            location: GeoPoint(latitude: 42.3736, longitude: -71.1097),
            openingHours: "Monday - Friday, 9 a.m. - 5 p.m.",
            type: ["Public", "Password"],
            rating: 4.0,
            reviews: []
        ),
        Toilet(
            id: nil,
            name: "Ladies Room",
            address: "789 Oak Avenue, Somerville, MA",
            location: GeoPoint(latitude: 42.3876, longitude: -71.0995),
            openingHours: "Monday - Sunday, 7 a.m. - 9 p.m.",
            type: ["Public", "Tampon", "Accessible"],
            rating: 4.8,
            reviews: []
        )
    ]
}


