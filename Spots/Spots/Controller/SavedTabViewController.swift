//
//  SavedTabViewController.swift
//  Spots
//
//  Created by user180094 on 12/13/20.
//  Copyright © 2020 SpotsDevelopers. All rights reserved.
//

import UIKit
import MapKit
import FirebaseAuth
import FirebaseStorage
import Firebase
import FirebaseFirestore

class SavedTabViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    @IBOutlet weak var spotTable: UITableView!
    
    @IBOutlet weak var genreLabel: UILabel!
    
    let db = Firestore.firestore()
    let uid = Auth.auth().currentUser?.uid
    var genreKeys: [String] = []
    var spotsList:Dictionary<String,[Spot]> = [ : ]
    //var list:Dictionary<String,[Spot]> = [ : ]
    var currentGenre = "all"
    var allArray: [Spot] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        createGenre()
        //fetchSaved()
        spotTable.dataSource = self
        spotTable.delegate = self

        spotTable.register(UITableViewCell.self, forCellReuseIdentifier: "spotCell")
        
        spotTable.reloadData()
        
    }
    
    //override func viewWillAppear(_ animated: Bool) {

        //super.viewWillAppear(animated)
        
    //}


    

    func createGenre() {

            self.db.collection("genres").whereField("uid", isEqualTo: self.uid!).getDocuments() { (snapshot, error) in
                if let err = error {
                    debugPrint("Error fetching docs \(err)")
                } else {
                    for document in snapshot! .documents{
                        
                        let genre = document.get("genre_record")
                        self.genreKeys.append(genre as! String)
                        self.spotsList[genre as! String] = []
                        print(self.genreKeys)
                        
                    }
                    self.fetchSaved()
                }
            }
        
        }
    
    
    func fetchSaved() {
            self.db.collection("spots").whereField("uid", isEqualTo: self.uid as Any).getDocuments(completion: { (snapshot, error) in
            if let err = error {
                debugPrint("Error fetching docs \(err)")
            } else {
                for document in snapshot! .documents{
                    let title = document.get("title") as! String
                    let subtitle = document.get("subtitle") as! String
                    let lat = document.get("latitude") as! CLLocationDegrees
                    let long = document.get("longitude") as! CLLocationDegrees
                    let location = CLLocationCoordinate2DMake(lat , long )
                    let genre_record = document.get("genre_record") as? String ?? "null"
                    let addSpot = Spot(label: title , locationName: subtitle, genre_record: genre_record, coordinate: location)
                    self.spotsList[genre_record]?.append(addSpot)
                    print("completed add",title)
                    self.allArray.append(addSpot)
                }
                print(self.spotsList)
                print(self.allArray)
                DispatchQueue.main.async {
                    self.spotTable.reloadData()
                }
            }
        })
    }
     
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if currentGenre == "all" {
            print(allArray.count)
            return allArray.count
        }
        else{
            return spotsList[currentGenre]!.count
        }
                
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let spotCell = UITableViewCell(style: .subtitle, reuseIdentifier: "spotCell")
        //let spotCell = UITableViewCell.dequeueReusableCell(withIdentifier: "spotCell") as! SpotsTableViewCell
        
        spotCell.backgroundColor = UIColor.green
        
       // spotCell.textLabel!.text = spotsList["null"]?[indexPath.row].label
        
        spotCell.textLabel!.text = self.allArray[indexPath.row].label
        //spotCell.subtitle.text = self.allArray[indexPath.row].locationName
        return spotCell
    }
    
}
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */


