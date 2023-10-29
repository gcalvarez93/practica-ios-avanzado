//
//  MapAnnotation.swift
//  DragonBall
//
//  Created by Gabriel Castro on 29/10/23.
//

import UIKit
import MapKit

class MapAnnotation: NSObject, MKAnnotation {
    var title: String?
    var info: String?
    var coordinate: CLLocationCoordinate2D

    init(title: String? = nil, info: String? = nil, coordinate: CLLocationCoordinate2D) {
        self.title = title
        self.info = info
        self.coordinate = coordinate
    }
}
