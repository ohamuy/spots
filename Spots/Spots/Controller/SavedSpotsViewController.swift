//
//  SavedSpotsViewController.swift
//  Spots
//
//  Created by Shannon Su on 12/8/20.
//  Copyright © 2020 SpotsDevelopers. All rights reserved.
//

import UIKit

class SavedSpotsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource{
    
    //values that will be imported from elsewhere
    var numCategories:Int!
    var spotsList:Dictionary<String,[Spot]>!
    var keys:[String] = []
    
    override func viewDidLoad() {
        //extracting the keys and making it into an array
        for i in spotsList.keys {
            keys.append(i)
        }
        
        NotificationCenter.default.addObserver(self, selector: #selector(notificationReceived), name: Notification.Name("spot created"), object: nil)
        
    }
    
    @objc func notificationReceived(_ notification: NSNotification){
        let theSpot = notification.object as? Spot
        let category = theSpot!.category
        print("\(category)")
    }
    
    //the UITableView
    @IBOutlet var spotsTable: UITableView!
    
    //counts the number of keys to return how many sections there should be
    func numberOfSections(in tableView: UITableView) -> Int {
        let numCat = keys.count
        return numCat
    }
    
    //makes the header of the section the name of the category
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return keys[section]
    }
    
    //counts the number of elements in each section to see how many rows there are
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return spotsList[keys[section]]?.count ?? 0
    }
    
    //used a bunch of pastel colors but this can be changed later
    let colorPalette = [ UIColor(red: 255/255, green: 103/255, blue: 147/255, alpha: 1), UIColor(red: 255/255, green: 161/255, blue: 101/255, alpha: 1),  UIColor(red: 255/255, green: 255/255, blue: 172/255, alpha: 1), UIColor(red: 190/255  , green: 255/255, blue: 132/255, alpha: 1), UIColor(red: 171/255, green: 255/255, blue: 255/255, alpha: 1), UIColor(red: 197/255, green: 179/255, blue: 255/255, alpha: 1)]
    
    //setting up table cells
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // Create a cell to return
        let spotCell = spotsTable.dequeueReusableCell(withIdentifier: "cell")!
        // indexPath has two properties, `section` and `row`.
        let spotArray = spotsList[keys[indexPath.section]]
        let label = spotArray?[indexPath.row].label
        spotCell.textLabel?.text = label
        spotCell.backgroundColor = colorPalette[indexPath.section]
        return spotCell
    }
    
    //when an item is selected, a new view controller that shows details about that spot will be pushed forward
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let spotInfoVC = storyboard!.instantiateViewController(identifier: "spotInfo") as SpotInfoViewController
        let spotArray = spotsList[keys[indexPath.section]]
        spotInfoVC.clickedSpot = spotArray![indexPath.row]
        navigationController?.pushViewController(spotInfoVC, animated: true)
    }
    
    
}
