//
//  HomeViewController.swift
//  Spots
//
//  Created by Oliver Hamuy on 11/27/20.
//  Copyright © 2020 SpotsDevelopers. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation
import FirebaseDatabase

class HomeViewController: UIViewController, CLLocationManagerDelegate {
    
    private let database = Database.database().reference()
    
    let locationManager = CLLocationManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
    }
    
    var currentLat:Double = 0.0
    var currentLong:Double = 0.0
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let myLocation = locations[0]
        currentLat = myLocation.coordinate.latitude
        currentLong = myLocation.coordinate.longitude
    }
    
    @IBOutlet var mapView: MKMapView!
   
    
    @IBAction func pinButtonTapped(_ sender: Any) {
        print("\(currentLat),\(currentLong)")
        let createPinAlert = UIAlertController(title: "New Spot", message: "Describe this spot", preferredStyle: .alert)
        createPinAlert.addTextField { (labelField) in
            labelField.placeholder = "Spot label"
        }
        createPinAlert.addTextField { (locationNameField) in
            locationNameField.placeholder = "Location name"
        }
        //changed so that the category is now a string
        createPinAlert.addTextField { (categoryField) in
                   categoryField.placeholder = "Category"
               }
//        createPinAlert.addTextField { (genreField) in
//            genreField.placeholder = "Genre"
//            genreField.keyboardType = .numberPad
//        }
//        createPinAlert.addTextField { (latitudeField) in
//            latitudeField.placeholder = "Latitude"
//            latitudeField.keyboardType = .numberPad
//        }
//        createPinAlert.addTextField { (longitudeField) in
//            longitudeField.placeholder = "Longitude"
//            longitudeField.keyboardType = .numberPad
//        }
        
        // done action
        let create = UIAlertAction(title: "Create", style: .default) { (_) in
            let label = createPinAlert.textFields?[0].text //?? "Untilted"
            let locationName = createPinAlert.textFields?[1].text
            let cat = createPinAlert.textFields?[2].text
//            let lat = createPinAlert.textFields?[3].text
//            let long = createPinAlert.textFields?[4].text
            let lat = self.currentLat
            let long = self.currentLong
            let location = CLLocationCoordinate2DMake(lat, long)
            let sendSpot = Spot(label: label!, locationName: locationName!, category: cat!, coordinate: location)
            self.mapView.addAnnotation(sendSpot)
            
            //adding the action that sends a notification once the done button is clicked so the saved spots VC knows what got added 
            NotificationCenter.default.post(name: Notification.Name("Spot Created"), object: sendSpot)
            
            print("tapped create")
            
            
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
    
//Figured out NSNotification center here:
    //https://www.youtube.com/watch?v=Kr3G9C22_-Q
}
