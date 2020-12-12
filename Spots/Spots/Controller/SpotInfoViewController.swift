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
    var clickedSpot: Spot!
    let storage = Storage.storage().reference()
    
    override func viewDidLoad() {
        let latitude = clickedSpot.coordinate.latitude
        let longitude = clickedSpot.coordinate.longitude
        let theSpot = Spot(label: clickedSpot.label!, locationName: clickedSpot.locationName, category: clickedSpot.category, coordinate: CLLocationCoordinate2DMake(latitude, longitude))
        mapView.addAnnotation(theSpot)
        loadImg()
        spotTitle.text = clickedSpot.label
        spotSubtitle.text = clickedSpot.locationName
    }
    func loadImg(){
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
        self.spotImg.image = image
        }
        })
        task.resume()
        })
    }
}

