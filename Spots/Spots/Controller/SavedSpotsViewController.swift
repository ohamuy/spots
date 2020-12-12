//
//  SavedSpotsViewController.swift
//  Spots
//
//  Created by Shannon Su on 12/8/20.
//  Copyright © 2020 SpotsDevelopers. All rights reserved.
//

import UIKit
import MapKit
import FirebaseAuth
import FirebaseStorage
import Firebase
import FirebaseFirestore

class SavedSpotsViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    //values that will be imported from elsewhere
    var spotsList:Dictionary<String,[Spot]> = [ : ]
    var keys:Dictionary<Int,String> = [ : ]
    var spotsArray:[Spot] = []
    
    //dummy variable for the selection of the dropdown menu
    let ddOut:String = "all"
    
    //user id
    let uid = Auth.auth().currentUser?.uid
    
    //stuff for retrieval from firestore
    let db = Firestore.firestore()
    var spotCollection:CollectionReference!
    var genreCollection:CollectionReference!
    //the UITableView
    @IBOutlet var spotsTable: UITableView!
    
    @IBOutlet var genreLabel: UILabel!
    // pseudo code
    // pull list of genres from database ?
    // search for things with the uid of the current user with those
    
    override func viewDidLoad() {
        super.viewDidLoad()
        spotsTable.register(UINib(nibName: "SpotsTableViewCell", bundle: Bundle.main), forCellReuseIdentifier: "spotCell")
        spotCollection =  db.collection("spots")
        genreCollection = db.collection("genres")
        loadGenres()
        loadDatabase()
        spotsTable.reloadData()
    }
    
    func loadGenres(){
        print("in loadgenres")
        spotCollection.whereField("uid", isEqualTo: uid).getDocuments(completion: { (snapshot, error) in
            if let err = error {
                debugPrint("Error fetching docs \(err)")
            } else {
                var i = 0
                for document in snapshot! .documents{
                   
                    let genre = document.data()["genre_record"] as! String
                    self.keys[i] = genre
                    i += 1
                    var theArray = self.spotsList[genre]
                    self.spotsList[genre] = []
                    print(self.keys)
                }
            }
        })
        
    }
    
    func loadDatabase() {
        spotCollection.whereField("uid", isEqualTo: uid).getDocuments(completion: { (snapshot, error) in
            if let err = error {
                debugPrint("Error fetching docs \(err)")
            } else {
                for document in snapshot! .documents{
                    guard let snap = snapshot else { return }
                    //                    print("\(document.data()["title"] as! String)")
                    let title = document.data()["title"] as! String
                    let subtitle = document.data()["subtitle"] as! String
                    let genre = document.data()["genre_record"] as! String
                    let lat = document.data()["latitude"] as! CLLocationDegrees
                    let long = document.data()["longitude"] as! CLLocationDegrees
                    let location = CLLocationCoordinate2DMake(lat , long )
                    let addSpot = Spot(label: title , locationName: subtitle, category: 0, coordinate: location)
                    self.spotsList[genre]!.append(addSpot)
                    //                    self.spotsArray.append(addSpot)
                    print("completed add",title)
                }
            }
        })
        
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if ddOut == "all" {
            return spotsList.values.count
        }
        else {
            return spotsList[ddOut]?.count ?? 0
        }
    }
    
    //    setting up table cells
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // Create a custom cell to return
        let spotCell = spotsTable.dequeueReusableCell(withIdentifier: "spotCell") as! SpotsTableViewCell

        // indexPath has two properties, `section` and `row`.
        let theKey = keys[indexPath.section]
        spotCell.backgroundColor = UIColor.green
        spotCell.spotTitle.text = spotsList[theKey!]![indexPath.row].label
        spotCell.spotSubtitle.text = spotsList[theKey!]![indexPath.row].locationName
        //        spotCell.spotImage =
        return spotCell
    }
    
    //when an item is selected, a new view controller that shows details about that spot will be pushed forward
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let spotInfoVC = storyboard!.instantiateViewController(identifier: "spotInfo") as SpotInfoViewController
        let theKey = keys[indexPath.section]
        spotInfoVC.clickedSpot = spotsList[theKey!]![indexPath.row]
        navigationController?.pushViewController(spotInfoVC, animated: true)
    }
}
