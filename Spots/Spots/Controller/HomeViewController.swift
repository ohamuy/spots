//
//  HomeViewController.swift
//  Spots
//
//  Created by Oliver Hamuy on 11/27/20.
//  Copyright © 2020 SpotsDevelopers. All rights reserved.
//

import UIKit
import MapKit
import FirebaseStorage
import FirebaseAuth
import Firebase

class HomeViewController: UIViewController, UISearchBarDelegate, MKMapViewDelegate, UITableViewDelegate, UITableViewDataSource, UIImagePickerControllerDelegate, UINavigationControllerDelegate, CLLocationManagerDelegate {

    
    @IBOutlet var locationMapView: MKMapView!
    
    @IBOutlet weak var search: UISearchBar!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        search.delegate = self
        search.showsCancelButton = true
        checkLocationServices()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        updateMap()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
            if myTableView != nil{
               search.text = ""
               search.showsCancelButton = false
               myTableView.removeFromSuperview()
           }
    }
    
    let db = Firestore.firestore()
    var theData: APIResults?
    var searchInput: String = ""
    var newSearchInput: String = ""
    let APIKey = "AIzaSyDrjVeQhWVpIJhYrrVX9vyykLhq475jjkY"
    var myTableView: UITableView!
    let manager = CLLocationManager()
    let regionMeter: Double = 10000
    var userPins: [[String: Any]] = []
    
    //Set up location manager
    func setUpLocationManager() {
        manager.delegate = self
        manager.desiredAccuracy = kCLLocationAccuracyBest
    }
    
    //populates map with spots from firestore
    func updateMap() {
        if Auth.auth().currentUser != nil{
            self.userPins.removeAll()
            let uid = Auth.auth().currentUser!.uid
            
            db.collection("spots").whereField("uid", isEqualTo: uid)
                .getDocuments() { (querySnapshot, err) in
                    if let err = err {
                        print("Error getting documents: \(err)")
                    } else {
                        for document in querySnapshot!.documents {
                            //print("\(document.documentID) => \(document.data())")
                            self.userPins.append(document.data())
                        }
                        print(self.userPins)
                        print(self.userPins.count)
                        for index in 0 ..< self.userPins.count  {
                            //print("\(index) : \(self.userPins[index]["title"] ?? <#default value#>)")
                            
                            let annotation = MKPointAnnotation()
                            let centerCoordinate = CLLocationCoordinate2D(latitude: self.userPins[index]["latitude"] as! CLLocationDegrees, longitude: self.userPins[index]["longitude"] as! CLLocationDegrees)
                            annotation.coordinate = centerCoordinate
                            annotation.title = "\(self.userPins[index]["title"] ?? "")"
                            self.locationMapView.addAnnotation(annotation)
                        }
                    }
            }
        }
    }
    
    
    //Check if location services are available
    func checkLocationServices() {
        if CLLocationManager.locationServicesEnabled() {
            //Set Up location manager
            setUpLocationManager()
            checkAppLocationAuthorization()
        } else {
            let alert = UIAlertController(title: "Location Service Not Enabled", message: "Please enable location services to improve user experience", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        }
    }
    
    //Check Location services permission for the app
    func checkAppLocationAuthorization() {
        switch CLLocationManager.authorizationStatus() {
        case .authorizedWhenInUse:
            //Show user location on map
            locationMapView.showsUserLocation = true
            scaleMapToUserLocation()
            manager.startUpdatingLocation()
            break
        case .denied:
            //Show alert instructing how to enable them within settings
            break
        case .notDetermined:
            manager.requestWhenInUseAuthorization()
            break
        case .restricted:
            //Show alert that location is restricted
            break
        case .authorizedAlways:
            break
        @unknown default:
            //Show alert app is too old lol
            break
        }
    }
    
    //scale map to user location
    //Learned here: https://www.youtube.com/watch?v=WPpaAy73nJc
    func scaleMapToUserLocation() {
        if let location = manager.location?.coordinate {
            let region = MKCoordinateRegion.init(center: location, latitudinalMeters: regionMeter, longitudinalMeters: regionMeter)
            locationMapView.setRegion(region, animated: true)
        }
    }
    
    //Update position of person as they move on map
    //Learned here: https://www.youtube.com/watch?v=WPpaAy73nJc
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        //Updating the location of the user on the map
        guard let location = locations.last else {return}
        let center = CLLocationCoordinate2D(latitude: location.coordinate.latitude, longitude: location.coordinate.longitude)
        let region = MKCoordinateRegion.init(center: center, latitudinalMeters: regionMeter, longitudinalMeters: regionMeter)
        locationMapView.setRegion(region, animated: true)
    }
    
    //Need to worry about permissions
    //Learned here: https://www.youtube.com/watch?v=WPpaAy73nJc
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        //Changes authorization
        checkAppLocationAuthorization()
    }
    
    func fetchDataFromSearch(){
        if searchInput != ""{
            let url = URL(string: "https://maps.googleapis.com/maps/api/place/textsearch/json?query=\(newSearchInput)&location=\(locationMapView.annotations[0].coordinate.latitude),\(locationMapView.annotations[0].coordinate.longitude)&radius=\(regionMeter)&fields=formatted_address,name,geometry&key=\(APIKey)")
            do{
                let data = try Data(contentsOf: url!)
                theData = try JSONDecoder().decode(APIResults.self, from:data)
                print(theData ?? "nothing")
            }
            catch let error {
                print(error.localizedDescription)
            }
            
        }
    }
    
    func searchBarSearchButtonClicked(_ search: UISearchBar) {
        search.showsCancelButton = true
        if search.text != nil{
            searchInput = search.text!
            newSearchInput = searchInput.replacingOccurrences(of: " ", with: "+", options: .literal, range: nil)
        }
        fetchDataFromSearch()
        
        let displayX: CGFloat = locationMapView.frame.minX
        let displayY: CGFloat = locationMapView.frame.minY
        let displayWidth: CGFloat = locationMapView.frame.size.width
        let displayHeight: CGFloat = locationMapView.frame.size.height
        
        if theData != nil{
            if theData!.results.count > 0 {
                myTableView = UITableView(frame: CGRect(x: displayX, y: displayY, width: displayWidth, height: displayHeight))
                myTableView.register(UITableViewCell.self, forCellReuseIdentifier: "MyCell")
                myTableView.dataSource = self
                myTableView.delegate = self
                self.view.addSubview(myTableView)
            } else{
                let alert = UIAlertController(title: "Alert", message: "No Results.", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: NSLocalizedString("OK", comment: "Default action"), style: .default, handler: { _ in
                NSLog("The \"OK\" alert occured.")
                }))
                self.present(alert, animated: true, completion: nil)
            }
        } else {
            let alert = UIAlertController(title: "Alert", message: "No Results.", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: NSLocalizedString("OK", comment: "Default action"), style: .default, handler: { _ in
            NSLog("The \"OK\" alert occured.")
            }))
            self.present(alert, animated: true, completion: nil)
        }
    
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if theData != nil {
            return theData!.results.count
        }else{
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MyCell", for: indexPath as IndexPath)
        
        cell.accessoryType = .detailDisclosureButton
        
        if theData != nil {
            cell.textLabel!.text = "\(theData!.results[indexPath.row].name ?? "")"
            return cell
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, accessoryButtonTappedForRowWith indexPath: IndexPath) {
        if theData != nil {
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let linkingVC = storyboard.instantiateViewController(withIdentifier: "newPin") as! NewPinViewController
            linkingVC.newPin = theData!.results[indexPath.row]
            present(linkingVC, animated: true)
            
            
        }
    }
    
    func searchBarCancelButtonClicked(_ search: UISearchBar) {
        if myTableView != nil{
            search.text = ""
            search.showsCancelButton = false
            myTableView.removeFromSuperview()
        }
    }
    
}

