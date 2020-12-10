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
        let createPinAlert = UIAlertController(title: "New Spot", message: "Describe this spot", preferredStyle: .alert)
        createPinAlert.addTextField { (labelField) in
            labelField.placeholder = "Spot label"
        }
        createPinAlert.addTextField { (locationNameField) in
            locationNameField.placeholder = "Location name"
        }
        createPinAlert.addTextField { (genreField) in
            genreField.placeholder = "Genre"
            genreField.keyboardType = .numberPad
        }
        createPinAlert.addTextField { (latitudeField) in
            latitudeField.placeholder = "Latitude"
            latitudeField.keyboardType = .numberPad
        }
        createPinAlert.addTextField { (longitudeField) in
            longitudeField.placeholder = "Longitude"
            longitudeField.keyboardType = .numberPad
        }
        
        // done action
        let create = UIAlertAction(title: "Create", style: .default) { (_) in
            let label = createPinAlert.textFields?[0].text //?? "Untilted"
            let locationName = createPinAlert.textFields?[1].text
            let genre = createPinAlert.textFields?[2].text
            let lat = createPinAlert.textFields?[3].text
            let long = createPinAlert.textFields?[4].text
            
//            let newSpotPin = Spot(label: label, locationName: locationName, category: genre, coordinate: CLLocationCoordinate2DMake(41.890158, 12.492185))
//            mapView.addAnnotation(newSpotPin)
        }
        let dismiss = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        
        createPinAlert.addAction(create)
        createPinAlert.addAction(dismiss)
        
        present(createPinAlert, animated: true, completion: nil)
        
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
