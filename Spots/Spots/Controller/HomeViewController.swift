//
//  HomeViewController.swift
//  Spots
//
//  Created by Oliver Hamuy on 11/27/20.
//  Copyright © 2020 SpotsDevelopers. All rights reserved.
//

import UIKit
import MapKit

class HomeViewController: UIViewController, UISearchBarDelegate, MKMapViewDelegate, UITableViewDelegate, UITableViewDataSource, UIImagePickerControllerDelegate, UINavigationControllerDelegate, CLLocationManagerDelegate {


    override func viewDidLoad() {
        super.viewDidLoad()
        
        search.delegate = self
        search.showsCancelButton = true
        checkLocationServices()

    }
    
    @IBOutlet var locationMapView: MKMapView!
   
    @IBOutlet weak var search: UISearchBar!
    
    var theData: APIResults?
    var searchInput: String = ""
    var newSearchInput: String = ""
    let APIKey = "AIzaSyDrjVeQhWVpIJhYrrVX9vyykLhq475jjkY"
    let myArray: NSArray = ["First","Second","Third"]
    var myTableView: UITableView!
    let manager = CLLocationManager()
    let regionMeter: Double = 10000
 
    //Set up location manager
    func setUpLocationManager() {
        manager.delegate = self
        manager.desiredAccuracy = kCLLocationAccuracyBest
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
            let url = URL(string: "https://maps.googleapis.com/maps/api/place/textsearch/json?query=\(newSearchInput)&fields=formatted_address,name,geometry&key=\(APIKey)")
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
    
//    func updateSearchResults(for searchController: UISearchController) {
//        guard let text = searchController.searchBar.text else { return }
//        print(text)
//    }
    
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

        myTableView = UITableView(frame: CGRect(x: displayX, y: displayY, width: displayWidth, height: displayHeight))
        myTableView.register(UITableViewCell.self, forCellReuseIdentifier: "MyCell")
        myTableView.dataSource = self
        myTableView.delegate = self
        self.view.addSubview(myTableView)
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
            print(theData!.results[indexPath.row].geometry?.location ?? 0.0)
        //performSegue(withIdentifier: "showDetail", sender: nil)
            //let customPinVC: CustomPinViewController = CustomPinViewController()
                  // popupTableViewController.userInputRequest = newSearchInput
//            customPinVC.chosenSpot = theData!.results[indexPath.row]
           // navigationController?.pushViewController(customPinVC, animated: true)
            
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let linkingVC = storyboard.instantiateViewController(withIdentifier: "createPin")
            self.navigationController?.pushViewController(linkingVC, animated: true)
            
        }
    }
    
    func searchBarCancelButtonClicked(_ search: UISearchBar) {
        search.text = ""
        search.showsCancelButton = false
        myTableView.removeFromSuperview()
    }
    
    }



