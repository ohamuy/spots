//
//  SpotInfoViewController.swift
//  Spots
//
//  Created by Shannon Su on 12/8/20.
//  Copyright © 2020 SpotsDevelopers. All rights reserved.
//

import UIKit
import MapKit
import FirebaseStorage
import Firebase

class SpotInfoViewController: UIViewController{
    
    
    @IBOutlet var mapView: MKMapView!
    @IBOutlet var spotImg: UIImageView!
    @IBOutlet var spotTitle: UILabel!
    @IBOutlet var spotSubtitle: UILabel!
    var genreCol: UIColor!
    var clickedSpot: Spot!
    let storage = Storage.storage().reference()
    let db = Firestore.firestore()
    let uid = Auth.auth().currentUser?.uid
    
    //    let storage = Storage.storage(url: "gs://spots-45e6f.appspot.com")
    @IBOutlet var genreColor: ColorButton!
    
    override func viewDidLoad() {
        let coordinate = clickedSpot.coordinate
        let color = clickedSpot.genreColor
        let theSpot = Spot(label: clickedSpot.label!, locationName: clickedSpot.locationName, genre_record: clickedSpot.genre_record, coordinate: coordinate, docid: clickedSpot.docid ?? "null", genreColor: color)
        mapView.addAnnotation(theSpot)
        loadImg()
        spotTitle.text = clickedSpot.label
        spotSubtitle.text = clickedSpot.locationName
        Utilities.styleButton(backButton)
        
        genreColor.backgroundColor = color
        genreColor.layer.cornerRadius = 15.0
        genreColor.tintColor = color
        genreColor.titleLabel?.font = UIFont.boldSystemFont(ofSize: 15)

//        genreColor.backgroundColor =
        
    }
    override func viewWillAppear(_ animated: Bool) {
        let blank = UIImage()
        blank.withTintColor(UIColor.black)
        spotImg.image = blank
    }
    
    @IBOutlet var backButton: UIButton!
    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
        
        // center the mapView on the selected pin
        let region = MKCoordinateRegion(center: clickedSpot.coordinate, span: mapView.region.span)
        mapView.setRegion(region, animated: true)
    }
    func loadImg(){
//        print("in load image")
        let docid = clickedSpot.docid!
//        print("\(uid!)/\(docid).png")
//        storage.child("\(uid!)/\(docid).png").getData(maxSize: 1*1024*1024) { (imagedata, error) in
//            if let error = error {
//                print(error)
//                return
//            } else {
//                if let imgd = imagedata {
//                    self.spotImg.image = UIImage(data: imgd)
//                }
//            }
//
//        }
//        self.spotImg.image = downloaded 
        storage.child("\(uid!)/\(docid).png").downloadURL(completion: {url, error in
            guard let url = url, error == nil else {
                print("in guard")
                return
            }
            let urlString = url.absoluteString
            print("THE URL: \(urlString)")
            let urlFinal = URL(string: urlString)
            let task = URLSession.shared.dataTask(with: urlFinal!, completionHandler: { data, _, error in
                guard let data = data, error == nil else {
                    return
                }
                DispatchQueue.main.async {
                    let image = UIImage(data: data)
                    self.spotImg.image = image
                }
            })
            task.resume()
        })
    }
    @IBAction func back(_ sender: Any) {
//        SavedTabViewController.createGenre(self.presentedViewController as! SavedTabViewController)
        self.navigationController?.popViewController(animated: true)
    }
}

