//
//  SpotInfoViewController.swift
//  Spots
//
//  Created by Shannon Su on 12/8/20.
//  Copyright © 2020 SpotsDevelopers. All rights reserved.
//

import UIKit
import MapKit

class SpotInfoViewController: UIViewController{
    
    @IBOutlet var mapView: MKMapView!
    var clickedSpot: Spot!
    
    override func viewDidLoad() {
        let latitude = clickedSpot.coordinate.latitude
        let longitude = clickedSpot.coordinate.longitude
        let theSpot = Spot(label: clickedSpot.label!, locationName: clickedSpot.locationName, category: clickedSpot.category, coordinate: CLLocationCoordinate2DMake(latitude, longitude))
        mapView.addAnnotation(theSpot)
    }
}
