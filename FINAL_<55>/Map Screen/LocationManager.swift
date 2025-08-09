//
//  LocationManager.swift
//  FINAL_<55>
//
//  Created by Shaobo Chen on 11/19/24.
//

import Foundation
import MapKit
import UIKit
import CoreLocation

// MARK: - Location Manager Delegate
extension ViewController: CLLocationManagerDelegate {
    func setupLocationManager() {
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
    }
    
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        switch manager.authorizationStatus {
        case .authorizedWhenInUse, .authorizedAlways:
            manager.requestLocation()
        case .denied:
            print("Location access denied.")
            let alert = UIAlertController(
                title: "Location Access Denied",
                message: "Please enable location services in Settings to use this feature.",
                preferredStyle: .alert
            )
            alert.addAction(UIAlertAction(title: "Cancel", style: .cancel))
            alert.addAction(UIAlertAction(title: "Settings", style: .default, handler: { _ in
                if let appSettings = URL(string: UIApplication.openSettingsURLString) {
                    UIApplication.shared.open(appSettings)
                }
            }))
            present(alert, animated: true)
        case .restricted:
            print("Location access restricted.")
        case .notDetermined:
            manager.requestWhenInUseAuthorization()
        @unknown default:
            break
        }
    }

    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.first {
            print("Location fetched: \(location.coordinate.latitude), \(location.coordinate.longitude)")
            mapView.buttonLoading.isHidden = true
            mapView.buttonSearch.isHidden = false
            mapView.mapView.centerToLocation(location: location)

            // Sort toilets by proximity
            sortToiletsByProximity()
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("Failed to fetch location: \(error.localizedDescription)")
    }
}
