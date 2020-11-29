//
//  HomeViewController.swift
//  Spots
//
//  Created by Oliver Hamuy on 11/27/20.
//  Copyright © 2020 SpotsDevelopers. All rights reserved.
//

import UIKit
import MapKit

class HomeViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBOutlet var mapView: MKMapView!
   
    
    @IBAction func pinButtonTapped(_ sender: Any) {
        let newSpotPin = Spot(title: "TestString", locationName: "TestString", category: WORK, coordinate: CLLocationCoordinate2DMake(41.890158, 12.492185))
        mapView.addAnnotation(newSpotPin)
    }
    
// Code for logout
 // Site for logout and login structure of changing view controllers   https://fluffy.es/how-to-transition-from-login-screen-to-tab-bar-controller/
//    let storyboard = UIStoryboard(name: "Main", bundle: nil)
//    let loginNavController = storyboard.instantiateViewController(identifier: "LoginNavigationController")
//
//    (UIApplication.shared.connectedScenes.first?.delegate as? SceneDelegate)?.changeRootViewController(loginNavController)

//Learned how to create user authentication here:
    //https://www.youtube.com/watch?v=1HN7usMROt8
}
