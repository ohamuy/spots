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

class CustomPinViewController: UIViewController, MKMapViewDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
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
    
    let storage = Storage.storage().reference()
    var imageData: Data?
    let db = Firestore.firestore()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setDefault()
        
        coordinateData = nil
        
        let longPressRecognizer = UILongPressGestureRecognizer(target: self, action: #selector(self.addPin(_:)))
        longPressRecognizer.minimumPressDuration = 0.5
        
        locationMapView.delegate = self
        locationMapView.addGestureRecognizer(longPressRecognizer)
        locationMapView.mapType = MKMapType.standard
        
        storage.child("images/file.png").downloadURL(completion: {url, error in
            guard let url = url, error == nil else {
                return
            }
            
            let urlString = url.absoluteString
            print("url \(urlString)")
            let urlFinal = URL(string: urlString)
            let task = URLSession.shared.dataTask(with: urlFinal!, completionHandler: { data, _, error in
                guard let data = data, error == nil else {
                    return
                }
                
                DispatchQueue.main.async {
                    let image = UIImage(data: data)
                    self.imagePreview.image = image
                }
            })
            task.resume()
        })
    }
    
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
    
    //learned here: https://www.youtube.com/watch?v=Kfw9XCO6VGY
    @objc func addPin(_ longPress: UILongPressGestureRecognizer) {
        locationMapView.removeAnnotations(locationMapView.annotations)
        
        let location = longPress.location(in: locationMapView)
        coordinateData = locationMapView.convert(location, toCoordinateFrom: locationMapView)
        
        let annotation = MKPointAnnotation()
        annotation.coordinate = coordinateData!
        annotation.title = "latitude: " + String(format: "%0.02f", annotation.coordinate.latitude) + "longitude: " + String(format: "%0.02f", annotation.coordinate.latitude)
        locationMapView.addAnnotation(annotation)
    }
    
    //change preview as text field is changed
    @IBAction func titleTextFieldChanged(_ sender: UITextField) {
        titlePreview.text = sender.text
    }
    
    //change preview as text field is changed
    @IBAction func subtitleTextFieldChanged(_ sender: UITextField) {
        subtitlePreview.text = sender.text
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
        
        var genreRecord = genreInputField.text ?? "null_genre";
        genreRecord = Utilities.parseInputToRecord(input:  genreRecord);
        
        // *** var genreRecord ready for storage in DB
        print("Pin title: \(title)")
        print("Record version: \(genreRecord)");
        print("Dislay version: \(Utilities.parseRecordToDisplayText(record: genreRecord))")
        
        //add spot to firestore database
        let uid = Auth.auth().currentUser?.uid
        var docid = ""
        
        //FIX THIS LATER
        db.collection("spots").whereField("uid", isEqualTo: uid!)
            .getDocuments() { (querySnapshot, err) in
                if let err = err {
                    print("Error getting documents: \(err)")
                } else {
                    for document in querySnapshot!.documents {
                        docid = document.documentID
                        print("docid: \(docid)")
                        print("\(uid!)/\(docid).png")
                        self.storage.child("\(uid!)/\(docid).png").putData(self.imageData!, metadata: nil, completion: { _, error in
                            guard error == nil else {
                                print("Failed to Upload")
                                return
                            }
                        })
                    }
                }
        }
        
        //check if title, genre are filled
        
        
        
        //add image to storage
 
        
//        print("\(uid!)/\(docid).png")
//        storage.child("\(uid!)/\(docid).png").putData(imageData!, metadata: nil, completion: { _, error in
//            guard error == nil else {
//                print("Failed to Upload")
//                return
//            }
//        })
        
        clearPin()
    }
    
    func clearPin() {
        let genre = genreInputField.text ?? "null_genre"
        let confirm = UIAlertController(title: "Pin Created", message: "\(titleInputField.text!) was successfully added to your network \(Utilities.parseRecordToDisplayText(record: Utilities.parseInputToRecord(input: genre))).", preferredStyle: .alert)
        confirm.addAction(UIAlertAction(title: NSLocalizedString("OK", comment: "Confirm"), style: .default, handler: { _ in
            NSLog("Pin add confirmed, reset VC")
        }))
        self.present(confirm, animated: true, completion: nil)
        
        titleInputField.text = ""
        genreInputField.text = ""
        subtitleTextField.text = ""
        
        imagePreview.image = nil
        titlePreview.text = ""
        subtitlePreview.text = ""
    }
}
