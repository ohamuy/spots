//
//  Spot.swift
//  Spots
//
//  Created by David Easton on 11/29/20.
//  Copyright © 2020 SpotsDevelopers. All rights reserved.
//

import Foundation
import MapKit

class Spot: NSObject, MKAnnotation {
    let title: String?
    let locationName: String
    let category: Int
//    let network: Network?
    let coordinate: CLLocationCoordinate2D
    
    init(title:String, locationName:String, category:Int, coordinate: CLLocationCoordinate2D) {
        self.title = title
        self.locationName = locationName
        self.category = category
        self.coordinate = coordinate
    }
    
    var subtitle: String? {
        return locationName + " ("+category+")"
    }
}
