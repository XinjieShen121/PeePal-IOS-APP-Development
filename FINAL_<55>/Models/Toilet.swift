//
//  Toilet.swift
//  FINAL_<55>
//
//  Created by haoning yin on 11/26/24.
//

import Foundation
import FirebaseFirestore
import FirebaseFirestoreSwift

struct Toilet: Codable {
    @DocumentID var id: String?
    var name: String
    var address: String
    var location: GeoPoint
    var openingHours: String
    var type: [String]
    var rating: Double
    var reviews: [Review]? // Optional reviews field
    var userRating: Double? 
}

struct Review: Codable {
    var name: String
    var rating: Double
}

