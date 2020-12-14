//
//  CustomPinViewController.swift
//  Spots
//
//  Created by Oliver Hamuy on 12/9/20.
//  Copyright © 2020 SpotsDevelopers. All rights reserved.
//

import UIKit
import MapKit
import FirebaseStorage
import FirebaseAuth
import Firebase

class CustomPinViewController: UIViewController, MKMapViewDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate, CLLocationManagerDelegate {
    
    @IBOutlet weak var pageTitle: UILabel!
    @IBOutlet weak var locationTitle: UILabel!
    @IBOutlet weak var previewTitle: UILabel!
    @IBOutlet weak var addImageButton: UIButton!
    @IBOutlet weak var finishButton: UIButton!
    
    @IBOutlet weak var titleInputField: UITextField!
    @IBOutlet weak var genreInputField: UITextField!
    @IBOutlet weak var subtitleTextField: UITextField!
    
    @IBOutlet weak var titlePreview: UILabel!
    @IBOutlet weak var subtitlePreview: UILabel!
    @IBOutlet weak var imagePreview: UIImageView!
    
    @IBOutlet weak var locationMapView: MKMapView!
    
    var coordinateData: CLLocationCoordinate2D?
    var currentAnnotation: MKPointAnnotation?
    
    let storage = Storage.storage().reference()
    var imageData: Data?
    let db = Firestore.firestore()
    let manager = CLLocationManager()
    let regionMeter: Double = 10000
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setDefault()
        setLongPress()
        checkLocationServices()
        coordinateData = nil
        currentAnnotation = nil
    }
    
    //Add styling to all labels, buttons and fields
    func setDefault () {
        Utilities.styleLabel(pageTitle)
        Utilities.styleLabel(locationTitle)
        Utilities.styleLabel(previewTitle)
        Utilities.styleButton(addImageButton)
        Utilities.styleButton(finishButton)
        Utilities.styleTextFieldAppContent(titleInputField)
        Utilities.styleTextFieldAppContent(genreInputField)
        Utilities.styleTextFieldAppContent(subtitleTextField)
    }
    
    //Allow for long press to add pin to map view
    func setLongPress() {
        locationMapView.delegate = self
        let longPressRecognizer = UILongPressGestureRecognizer(target: self, action: #selector(self.addPin(_:)))
        longPressRecognizer.minimumPressDuration = 0.5
        locationMapView.addGestureRecognizer(longPressRecognizer)
        
        locationMapView.mapType = MKMapType.standard
    }
   
    //recenters to user's location
    @IBAction func centerPressed(_ sender: Any) {
        locationMapView.userTrackingMode = .follow
    }
    
    //Adds a pin when a long press is recongized
    //learned here: https://www.youtube.com/watch?v=Kfw9XCO6VGY
    @objc func addPin(_ longPress: UILongPressGestureRecognizer) {
        locationMapView.removeAnnotations(locationMapView.annotations)
        
        let location = longPress.location(in: locationMapView)
        coordinateData = locationMapView.convert(location, toCoordinateFrom: locationMapView)
        
        let annotation = MKPointAnnotation()
        annotation.coordinate = coordinateData!
        annotation.title = "latitude: " + String(format: "%0.02f", annotation.coordinate.latitude) + "longitude: " + String(format: "%0.02f", annotation.coordinate.latitude)
        
        locationMapView.addAnnotation(annotation)
        
        currentAnnotation = annotation
    }
    
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
    
    //change preview as text field is changed
    @IBAction func titleTextFieldChanged(_ sender: UITextField) {
        titlePreview.text = sender.text
    }
    
    //change preview as text field is changed
    @IBAction func subtitleTextFieldChanged(_ sender: UITextField) {
        subtitlePreview.text = sender.text
    }
    
    @IBAction func resetDataButtonTapped(_ sender: Any) {
        let confirm = UIAlertController(title: "Confirm Reset", message: "Are you sure you want to clear the pin in-progress?", preferredStyle: .alert)
        confirm.addAction(UIAlertAction(title: NSLocalizedString("Cancel", comment: "Confirm"), style: .default, handler: { _ in
            NSLog("Pin clear aborted")
            return
        }))
        confirm.addAction(UIAlertAction(title: NSLocalizedString("Yes", comment: "Confirm"), style: .default, handler: { _ in
            NSLog("Pin clear confirmed, reset VC")
            self.clearPin(mode: RESET)
        }))
        self.present(confirm, animated: true, completion: nil)
    }
    
    //sets image to image preview after selecting it from libary
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let image = info[UIImagePickerController.InfoKey(rawValue: "UIImagePickerControllerEditedImage")] as? UIImage {
            imagePreview.image = image
        }
        
        guard let image = info[UIImagePickerController.InfoKey.editedImage] as? UIImage else {
            return
        }
        
        if image.pngData() != nil {
            imageData = image.pngData()!
        }
        
        picker.dismiss(animated: true, completion: nil)
    }
    
    //Cancel image picker, no image was selected
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
    
    //add image to preview when image is added
    //https://www.youtube.com/watch?v=yggOGEzueFk
    @IBAction func addImageTapped(_ sender: Any) {
        let vc = UIImagePickerController()
        vc.sourceType = .photoLibrary
        vc.delegate = self
        vc.allowsEditing = true
        present(vc, animated: true)
    }
    
    func clearPin(mode: Int) {
        if mode == CONFIRM {
            let genre = genreInputField.text ?? "null_genre"
            let confirm = UIAlertController(title: "Pin Created", message: "\(titleInputField.text!) was successfully added to your network \(Utilities.parseRecordToDisplayText(record: Utilities.parseInputToRecord(input: genre))).", preferredStyle: .alert)
            confirm.addAction(UIAlertAction(title: NSLocalizedString("OK", comment: "Confirm"), style: .default, handler: { _ in
                NSLog("Pin add confirmed, reset VC")
            }))
            self.present(confirm, animated: true, completion: nil)
        }
        else if mode == RESET {
            print("Pin data reset")
            // DEVNOTE: do anything else? confirm moved to button handler
        }
        else {
            print("Err: invalid mode on clear of custom pin data!")
        }
        
        titleInputField.text = ""
        genreInputField.text = ""
        subtitleTextField.text = ""
        
        imagePreview.image = nil
        titlePreview.text = ""
        subtitlePreview.text = ""
        
        coordinateData = nil
        if currentAnnotation != nil {
            locationMapView.removeAnnotation(currentAnnotation!)
            currentAnnotation = nil
        }
    }
    
    
    //adds spot to firebase
    @IBAction func finishTapped(_ sender: Any) {
        // check if coordinate data exists
        if coordinateData == nil {
            let noTitleErrorMsg = UIAlertController(title: "Where was that?", message: "We didn't catch the location of that spot. Press and hold on the map to drop a pin.", preferredStyle: .alert)
            noTitleErrorMsg.addAction(UIAlertAction(title: NSLocalizedString("OK", comment: "Go back"), style: .default, handler: { _ in
                NSLog("Err: no coords on pin save")
            }))
            self.present(noTitleErrorMsg, animated: true, completion: nil)
            return
        }
        
        // check if title exists
        let title = titleInputField.text ?? ""
        if title.isEmpty {
            let noTitleErrorMsg = UIAlertController(title: "Title Required", message: "Every spot need a name. Add something to the title field, then try again.", preferredStyle: .alert)
            noTitleErrorMsg.addAction(UIAlertAction(title: NSLocalizedString("OK", comment: "Go back"), style: .default, handler: { _ in
                NSLog("Err: no title on pin save")
            }))
            self.present(noTitleErrorMsg, animated: true, completion: nil)
            return
        }
        
        //get uid and docid for query
        let uid = Auth.auth().currentUser?.uid
        let annotation = locationMapView.annotations
        var docid = ""
        var subtitle = ""
        
        //check if subtitle exists
        if (subtitleTextField.text == "") {
            subtitle = "null"
        } else {
            subtitle = subtitleTextField.text!
        }
        
        //add content to database
        guard let locValue: CLLocationCoordinate2D = manager.location?.coordinate else { return }
        let userLat = Double(round(10000*locValue.latitude)/10000)
        let userLong = Double(round(10000*locValue.longitude)/10000)
        let annZeroLat = Double(round(10000*annotation[0].coordinate.latitude)/10000)
        let annZeroLong = Double(round(10000*annotation[0].coordinate.longitude)/10000)
        let annOneLat = Double(round(10000*annotation[1].coordinate.latitude)/10000)
        let annOneLong = Double(round(10000*annotation[1].coordinate.longitude)/10000)
        
        
        var index = 0
        
        if annZeroLat == userLat && annZeroLong == userLong {
            index = 1
        } else if annOneLat == userLat && annOneLong == userLong {
            index = 0
        }
        db.collection("spots").addDocument(data: [
            "uid" : uid!,
            "title" : titleInputField.text!,
            "subtitle" : subtitle,
            "genre_record" : "null", //CHANGE THIS LATER TO BE GENRE RECORD
            "longitude" : annotation[index].coordinate.longitude,
            "latitude" : annotation[index].coordinate.latitude
        ])
        
        
        
        if (imagePreview.image != nil ) {
            db.collection("spots").whereField("uid", isEqualTo: uid!)
                .getDocuments() { (querySnapshot, err) in
                    if let err = err {
                        print("Error getting documents: \(err)")
                    } else {
                        for document in querySnapshot!.documents {
                            docid = document.documentID
                            self.storage.child("\(uid!)/\(docid).png").putData(self.imageData!, metadata: nil, completion: { _, error in
                                guard error == nil else {
                                    print("Failed to Upload")
                                    return
                                }
                            })
                        }
                    }
            }
        }
        
        clearPin(mode: CONFIRM)
    }
}

//CODE TO REQUEST IMAGES FROM THE DATABASE
//        storage.child("images/file.png").downloadURL(completion: {url, error in
//            guard let url = url, error == nil else {
//                return
//            }
//
//            let urlString = url.absoluteString
//            print("url \(urlString)")
//            let urlFinal = URL(string: urlString)
//            let task = URLSession.shared.dataTask(with: urlFinal!, completionHandler: { data, _, error in
//                guard let data = data, error == nil else {
//                    return
//                }
//
//                DispatchQueue.main.async {
//                    let image = UIImage(data: data)
//                    self.imagePreview.image = image
//                }
//            })
//            task.resume()
//        })
