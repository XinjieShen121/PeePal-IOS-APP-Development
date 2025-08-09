//
//  MKMapView+Extensions.swift
//  FINAL_<55>
//
//  Created by haoning yin on 11/26/24.
//

import MapKit

extension MKMapView {
    func centerToLocation(location: CLLocation, radius: CLLocationDistance = 10000) {
        let coordinateRegion = MKCoordinateRegion(
            center: location.coordinate,
            latitudinalMeters: radius,
            longitudinalMeters: radius
        )
        self.setRegion(coordinateRegion, animated: true)
    }
}

