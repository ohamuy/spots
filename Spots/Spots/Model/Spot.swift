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
    let label: String?
    let locationName: String
    let genre_record: String
    let coordinate: CLLocationCoordinate2D
    let genreColor: UIColor
    let docid:String?
    
    init(label:String, locationName:String, genre_record:String, coordinate: CLLocationCoordinate2D, docid:String, genreColor: UIColor) {
        self.label = label
        self.docid = docid
        self.locationName = locationName
        self.genre_record = genre_record
        self.coordinate = coordinate
        self.genreColor = genreColor
    }
}
