//
//  Coordinate.swift
//  Weather
//
//  Created by Hyungmin Lee on 2023/10/16.
//

import Foundation
import CoreLocation

struct Coordinate: Hashable {
    let latitude: String
    let longitude: String
    
    init(latitude: String, longitude: String) {
        self.latitude = latitude
        self.longitude = longitude
    }
    
    init(coordinate: CLLocationCoordinate2D) {
        self.latitude = String(coordinate.latitude)
        self.longitude = String(coordinate.longitude)
    }
}
