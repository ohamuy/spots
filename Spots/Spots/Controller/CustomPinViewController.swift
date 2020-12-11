//
//  CustomPinViewController.swift
//  Spots
//
//  Created by Oliver Hamuy on 12/9/20.
//  Copyright © 2020 SpotsDevelopers. All rights reserved.
//

import UIKit
import MapKit

class CustomPinViewController: UIViewController, MKMapViewDelegate {

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
    
    override func viewDidLoad() {
        super.viewDidLoad()
    
        setDefault()
        locationMapView.delegate = self
        let longPressRecognizer = UILongPressGestureRecognizer(target: self, action: #selector(self.addPin(_:)))
        longPressRecognizer.minimumPressDuration = 0.5
        locationMapView.addGestureRecognizer(longPressRecognizer)
        
        locationMapView.mapType = MKMapType.standard
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

    //ability to add pin to mapkit
    var lat : String = "13.1631"
    var lon : String = "72.5450"
    
    //learned here: https://www.youtube.com/watch?v=Kfw9XCO6VGY
    @objc func addPin(_ longPress: UILongPressGestureRecognizer) {
        let location = longPress.location(in: locationMapView)
        let coordinate = locationMapView.convert(location, toCoordinateFrom: locationMapView)
        
        let annotation = MKPointAnnotation()
        annotation.coordinate = coordinate
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
    
    //add image to preview when image is added
    //https://www.youtube.com/watch?v=yggOGEzueFk
    @IBAction func addImageTapped(_ sender: Any) {
        let vc = UIImagePickerController()
        vc.sourceType = .photoLibrary
        vc.delegate = self
        vc.allowsEditing = true
        present(vc, animated: true)
    }
    
}

extension CustomPinViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let image = info[UIImagePickerController.InfoKey(rawValue: "UIImagePickerControllerEditedImage")] as? UIImage {
            imagePreview.image = image
        }
        
        picker.dismiss(animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
}
