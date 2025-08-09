//
//  MapAnnotationDelegate.swift
//  FINAL_<55>
//
//  Created by Shaobo Chen on 11/20/24.
//

import Foundation
import MapKit
import FirebaseFirestore

extension ViewController: MKMapViewDelegate {
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        guard !(annotation is MKUserLocation) else { return nil }
        
        let identifier = "ToiletAnnotation"
        var annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: identifier) as? MKMarkerAnnotationView
        
        if annotationView == nil {
            annotationView = MKMarkerAnnotationView(annotation: annotation, reuseIdentifier: identifier)
            annotationView?.canShowCallout = true
            let infoButton = UIButton(type: .detailDisclosure)
            annotationView?.rightCalloutAccessoryView = infoButton
        } else {
            annotationView?.annotation = annotation
        }
        
        return annotationView
    }
    
    func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        guard let annotation = view.annotation as? MKPointAnnotation,
              let selectedToilet = toilets.first(where: { $0.name == annotation.title }) else {
            return
        }
        
        // 點擊 info button 打開外部地圖
        let coordinate = CLLocationCoordinate2D(
            latitude: selectedToilet.location.latitude,
            longitude: selectedToilet.location.longitude
        )
        let placemark = MKPlacemark(coordinate: coordinate)
        let mapItem = MKMapItem(placemark: placemark)
        mapItem.name = selectedToilet.name
        mapItem.openInMaps(launchOptions: [
            MKLaunchOptionsDirectionsModeKey: MKLaunchOptionsDirectionsModeDriving
        ])
    }
    
    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
        guard let annotation = view.annotation as? MKPointAnnotation,
              let selectedToilet = toilets.first(where: { $0.name == annotation.title }) else {
            return
        }
        
        // 點擊標題或空白部分跳轉到詳細頁面
        let detailVC = ToiletDetailViewController(toilet: selectedToilet)
        navigationController?.pushViewController(detailVC, animated: true)
    }
}










