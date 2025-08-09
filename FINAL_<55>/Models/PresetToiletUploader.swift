//
//  PresetToiletUploader.swift
//  FINAL_<55>
//
//  Created by haoning yin on 11/27/24.
//

import Foundation
import MapKit
import Firebase

class PresetToiletUploader {
    static let db = Firestore.firestore()
    
    static let toiletsToAdd = [
        Toilet(
            id: nil,
            name: "Boston Public Library - Brighton",
            address: "40 Academy Hill Road, Boston, MA 02135",
            location: GeoPoint(latitude: 42.3476, longitude: -71.1528),
            openingHours: "11:00 AM - 8:00 PM",
            type: ["Public", "Accessible"],
            rating: 0.0,
            reviews: []
        ),
        Toilet(
            id: nil,
            name: "Copley Place Mall",
            address: "100 Huntington Ave, Boston, MA 02116",
            location: GeoPoint(latitude: 42.3470, longitude: -71.0786),
            openingHours: "10:00 AM - 8:00 PM",
            type: ["Public", "Accessible", "Tampon"],
            rating: 0.0,
            reviews: []
        ),
        Toilet(
            id: nil,
            name: "Boston Public Library - Central",
            address: "700 Boylston St, Boston, MA 02116",
            location: GeoPoint(latitude: 42.3492, longitude: -71.0776),
            openingHours: "9:00 AM - 9:00 PM",
            type: ["Public", "Accessible"],
            rating: 0.0,
            reviews: []
        ),
        Toilet(
            id: nil,
            name: "South Station",
            address: "700 Atlantic Ave, Boston, MA 02110",
            location: GeoPoint(latitude: 42.3522, longitude: -71.0551),
            openingHours: "24 Hours",
            type: ["Public", "Accessible", "Password"],
            rating: 0.0,
            reviews: []
        ),
        Toilet(
            id: nil,
            name: "Quincy Market",
            address: "4 S Market St, Boston, MA 02109",
            location: GeoPoint(latitude: 42.3598, longitude: -71.0534),
            openingHours: "10:00 AM - 9:00 PM",
            type: ["Public", "Accessible", "Tampon"],
            rating: 0.0,
            reviews: []
        ),
        Toilet(
            id: nil,
            name: "Boston Public Library - Chinatown",
            address: "2 Boylston St, Boston, MA 02130",
            location: GeoPoint(latitude: 42.3194, longitude: -71.1111),
            openingHours: "10:00 AM - 9:00 PM",
            type: ["Public", "Accessible", "Tampon"],
            rating: 0.0,
            reviews: []
        ),
        Toilet(
            id: nil,
            name: "Boston Harbor Hotel",
            address: "70 Rowes Wharf, Boston, MA 02110",
            location: GeoPoint(latitude: 42.3571, longitude: -71.0499),
            openingHours: "24 Hours",
            type: ["Public", "Accessible", "Tampon"],
            rating: 0.0,
            reviews: []
        ),
        Toilet(
            id: nil,
            name: "City Toilet",
            address: "206 Atlantic Ave, Boston, MA 02110",
            location: GeoPoint(latitude: 42.3602, longitude: -71.0518),
            openingHours: "24 Hours",
            type: ["Public", "Accessible"],
            rating: 0.0,
            reviews: []
        ),
        Toilet(
            id: nil,
            name: "BCYF Paris Street",
            address: "112 Paris Street, Boston, MA 02128",
            location: GeoPoint(latitude: 42.3728, longitude: -71.0375),
            openingHours: "9:00 AM - 5:00 PM",
            type: ["Public", "Accessible", "Password"],
            rating: 0.0,
            reviews: []
        ),
        Toilet(
            id: nil,
            name: "Boston East Apartments",
            address: "126 Border St, Boston, MA 02129",
            location: GeoPoint(latitude: 42.3736, longitude: -71.0409),
            openingHours: "10:00 AM - 6:00 PM",
            type: ["Public", "Accessible", "Tampon"],
            rating: 0.0,
            reviews: []
        ),
        Toilet(
            id: nil,
            name: "Battery Wharf Boston Hotel",
            address: "3 Battery Wharf, Boston, MA 02109",
            location: GeoPoint(latitude: 42.3672, longitude: -71.0505),
            openingHours: "24 Hours",
            type: ["Public", "Accessible", "Tampon"],
            rating: 0.0,
            reviews: []
        ),
        Toilet(
            id: nil,
            name: "BCYF Nazzaro",
            address: "30 N Bennet St, Boston, MA 02113",
            location: GeoPoint(latitude: 42.3653, longitude: -71.0545),
            openingHours: "6:30 AM - 9:00 PM",
            type: ["Public", "Accessible", "Tampon", "Password"],
            rating: 0.0,
            reviews: []
        ),
        Toilet(
            id: nil,
            name: "Boston Public Library - NorthEnd",
            address: "25 Parmenter St, Boston, MA 02113",
            location: GeoPoint(latitude: 42.3640, longitude: -71.0549),
            openingHours: "10:00 AM - 6:00 PM",
            type: ["Public", "Accessible", "Tampon"],
            rating: 0.0,
            reviews: []
        ),
        Toilet(
            id: nil,
            name: "City Toilet",
            address: "35 Commercial St, Boston, MA 02155",
            location: GeoPoint(latitude: 42.4098, longitude: -71.0888),
            openingHours: "24 Hours",
            type: ["Public", "Accessible"],
            rating: 0.0,
            reviews: []
        ),
        Toilet(
            id: nil,
            name: "Boston Public Library - Egleston Square",
            address: "2044 Columbus Ave, Boston, MA 02119",
            location: GeoPoint(latitude: 42.3141, longitude: -71.0957),
            openingHours: "10:00 AM - 6:00 PM",
            type: ["Public", "Accessible", "Tampon"],
            rating: 0.0,
            reviews: []
        ),
        Toilet(
            id: nil,
            name: "Fan Pier Boston",
            address: "1 Marina Park Dr, Boston, MA 02210",
            location: GeoPoint(latitude: 42.3532, longitude: -71.0453),
            openingHours: "24 Hours",
            type: ["Public", "Accessible"],
            rating: 0.0,
            reviews: []
        )
    ]
    
    static func uploadToilet(_ toilet: Toilet, completion: @escaping (Bool) -> Void) {
        do {
            try db.collection("toilets").addDocument(from: toilet) { error in
                if let error = error {
                    print("upload failed: \(error.localizedDescription)")
                    completion(false)
                } else {
                    completion(true)
                }
            }
        } catch {
            print("coding failed: \(error.localizedDescription)")
            completion(false)
        }
    }

}
