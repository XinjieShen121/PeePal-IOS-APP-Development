//
//  SearchTableViewManager.swift
//  FINAL_<55>
//
//  Created by Shaobo Chen on 11/20/24.
//

import Foundation
import UIKit
import CoreLocation
import MapKit

extension SearchViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return toilets.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: Configs.searchTableViewID, for: indexPath) as! SearchTableViewCell
        cell.configureCell(toilet: toilets[indexPath.row])
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedToilet = toilets[indexPath.row]

        // Center the map on the selected toilet's location
        let location = CLLocation(latitude: selectedToilet.location.latitude, longitude: selectedToilet.location.longitude)
        delegateToMapView.mapView.mapView.centerToLocation(location: location)

        // 查找
        if let annotations = delegateToMapView.mapView.mapView.annotations as? [MKPointAnnotation],
           let annotation = annotations.first(where: { $0.title == selectedToilet.name }) {
            delegateToMapView.mapView.mapView.selectAnnotation(annotation, animated: true)
        } else {
            print("Annotation not found for toilet: \(selectedToilet.name)")
        }
    }
}



