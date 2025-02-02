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
    
    @IBOutlet weak var tableViewDropdown: UITableView!
    @IBOutlet weak var selectGenre: UIButton!
    
    let db = Firestore.firestore()
    let uid = Auth.auth().currentUser?.uid
    var genreKeys: [String] = []
    var spotsList:Dictionary<String,[Spot]> = [ : ]
    var currentGenre = "all"
    var allArray: [Spot] = []
    let storage = Storage.storage().reference()
    var imageList = [String: [String]]()
    var allImage: [String] = []
    var switchColor = false
    var backgroundColor: UIColor = UIColor.systemGray2
    var genres: [String] = []
    var selectedGenre = "null"
    var colorsDict:Dictionary<String,UIColor> = [:]
    
    override func viewDidLoad() {
        super.viewDidLoad()
//        createGenre()
//        populateGenreTable()
        spotTable.dataSource = self
        spotTable.delegate = self
        spotTable.reloadData()
        
        tableViewDropdown.dataSource = self
        tableViewDropdown.delegate = self
        tableViewDropdown.register(UITableViewCell.self, forCellReuseIdentifier: "tableCell")
        tableViewDropdown.reloadData()
        Utilities.styleTableView(tableViewDropdown)
    }
//    override func viewWillDisappear(_ animated: Bool) {
//        genres = []
//        allArray = []
//        genreKeys = []
//        spotsList = [:]
//    }
    
    override func viewWillAppear(_ animated: Bool) {
        genres = []
        allArray = []
        genreKeys = []
        spotsList = [:]
        selectedGenre = "null"
        createGenre()
        populateGenreTable()
        spotTable.reloadData()
        tableViewDropdown.reloadData()

    }
    
    func populateGenreTable() {
        let uid = Auth.auth().currentUser?.uid
        db.collection("genres").whereField("uid", isEqualTo: uid!).getDocuments() { (snapshot, error) in
            if let err = error {
                debugPrint("Error fetching docs \(err)")
            } else {
                for document in snapshot! .documents {
                    let genreDisplay = Utilities.parseRecordToDisplayText(record: document.get("genre_record") as! String)
                    self.genres.append(genreDisplay)
                }
                DispatchQueue.main.async {
                    self.tableViewDropdown.reloadData()
                }
            }
        }
        spotTable.reloadData()
    }
    
    @IBAction func selectGenreTapped(_ sender: Any) {
        UIView.animate(withDuration: 0.3, animations: {
            self.tableViewDropdown.isHidden = !self.tableViewDropdown.isHidden
            self.view.layoutIfNeeded()
        })
    }
    
    func createGenre() {
        self.db.collection("genres").whereField("uid", isEqualTo: self.uid!).getDocuments() { (snapshot, error) in
            if let err = error {
                debugPrint("Error fetching docs \(err)")
            } else {
                for document in snapshot! .documents{
                    
                    let genre = document.get("genre_record") as! String
                  
                    let rgbArray = document.get("color") as? [String]
                    let red = Utilities.cgfloatConvert(input: rgbArray?[0] ?? "0")
                    let green = Utilities.cgfloatConvert(input: rgbArray?[1] ?? "0")
                    let blue = Utilities.cgfloatConvert(input: rgbArray?[2] ?? "0")
                    let theColor = UIColor(red: red/255, green: green/255, blue: blue/255, alpha: 1.0)
                    self.colorsDict[genre] = theColor
                   
                    self.genreKeys.append(genre)
                    self.spotsList[genre] = []
                    self.imageList[genre] = []
                    
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
                    let docid = document.documentID
                    let color = self.colorsDict[genre_record]
                    let addSpot = Spot(label: title , locationName: subtitle, genre_record: genre_record, coordinate: location, docid: docid, genreColor: color!)
                    self.spotsList[genre_record]?.append(addSpot)
                    self.allArray.append(addSpot)
                }
                DispatchQueue.main.async {
                    self.spotTable.reloadData()
                }
            }
        })
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableView == tableViewDropdown {
            return genres.count
        }
        if selectedGenre == "null" {
            return allArray.count
        }
        else{

            return spotsList[selectedGenre]!.count
        }
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if tableView == spotTable {
            let spotCell = spotTable.dequeueReusableCell(withIdentifier: "spotCell") as! spotCell
            
            switchColor = !switchColor
            if switchColor {
                spotCell.backgroundColor = UIColor.systemGray4
            } else {
                spotCell.backgroundColor = UIColor.systemGray5
            }
            
            if selectedGenre == "null" {
                spotCell.title?.text = self.allArray[indexPath.row].label
                spotCell.title?.textColor = UIColor.init(red: 71/255, green: 71/255, blue: 71/255, alpha: 1)
                spotCell.subtitle?.text = self.allArray[indexPath.row].locationName
                spotCell.subtitle?.textColor = UIColor.init(red: 71/255, green: 71/255, blue: 71/255, alpha: 1)
            }
            else{
                spotCell.title?.text = self.spotsList[selectedGenre]?[indexPath.row].label
                spotCell.title?.textColor = UIColor.init(red: 71/255, green: 71/255, blue: 71/255, alpha: 1)
                spotCell.subtitle?.text = self.spotsList[selectedGenre]?[indexPath.row].locationName
                spotCell.subtitle?.textColor = UIColor.init(red: 71/255, green: 71/255, blue: 71/255, alpha: 1)
            }
            return spotCell
        }
        else {
            let cell = UITableViewCell(style: .subtitle, reuseIdentifier: "tableCell")
            cell.textLabel!.text = genres[indexPath.row]
            return cell
        }
        //        return
    }
    
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if tableView == tableViewDropdown {
            let genre = genres[indexPath.row]
            selectedGenre = Utilities.parseInputToRecord(input: genre)
            UIView.animate(withDuration: 0.3, animations: {
                self.tableViewDropdown.isHidden = !self.tableViewDropdown.isHidden
                self.view.layoutIfNeeded()
            })
            self.spotTable.reloadData()
        }
        if tableView == spotTable{
            let spotInfoVC = storyboard!.instantiateViewController(identifier: "spotInfo") as SpotInfoViewController
            if selectedGenre == "null" {
                spotInfoVC.clickedSpot = self.allArray[indexPath.row]
            } else {
                spotInfoVC.clickedSpot = spotsList[selectedGenre]![indexPath.row]
            }
            navigationController?.pushViewController(spotInfoVC, animated: true)
        }
        
    }
    
    
    
}

class spotCell: UITableViewCell {
    
    @IBOutlet var subtitle: UILabel?
    @IBOutlet var title: UILabel?
    
}


