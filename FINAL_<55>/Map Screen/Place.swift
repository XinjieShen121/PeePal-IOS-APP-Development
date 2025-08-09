//
//  Place.swift
//  FINAL_<55>
//
//  Created by Shaobo Chen on 11/20/24.
//

import MapKit

class Place: NSObject, MKAnnotation {
    var title: String?
    var coordinate: CLLocationCoordinate2D
    var info: String

    init(title: String, coordinate: CLLocationCoordinate2D, info: String) {
        self.title = title
        self.coordinate = coordinate
        self.info = info
    }
    
    // 導航到地圖的 MKMapItem
    var mapItem: MKMapItem? {
        let placemark = MKPlacemark(coordinate: coordinate)
        let mapItem = MKMapItem(placemark: placemark)
        mapItem.name = title
        return mapItem
    }
}
