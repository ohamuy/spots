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
    var spotsList:[Spot]!
    
    //the UITableView
    @IBOutlet var spotsTable: UITableView!
    
    //to figure out how many sections there are
    func countCategories (list: [Spot]) -> Int {
        var numCat = 1
        for i in 1...list.count-1 {
            let firstCat = list[i].category
            if list[i+1].category != firstCat {
                numCat++
            }
        }
        return numCat
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return countCategories(list: spotsList)
    }
    
    //used a bunch of pastel colors but this can be changed later
    let colorPalette = [ UIColor(red: 255/255, green: 103/255, blue: 147/255, alpha: 1), UIColor(red: 255/255, green: 161/255, blue: 101/255, alpha: 1),  UIColor(red: 255/255, green: 255/255, blue: 172/255, alpha: 1), UIColor(red: 190/255  , green: 255/255, blue: 132/255, alpha: 1), UIColor(red: 171/255, green: 255/255, blue: 255/255, alpha: 1), UIColor(red: 197/255, green: 179/255, blue: 255/255, alpha: 1)]
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // Create a cell to return
        let cell = UITableViewCell(style: .default, reuseIdentifier: "cell")
        // indexPath has two properties, `section` and `row`.
        cell.textLabel?.text = spotsList[indexPath.row].label
        cell.backgroundColor = colorPalette[indexPath.section]
        return cell
    }
    
    //when an item is selected, a new view controller that shows details about that spot will be pushed forward
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let spotInfoVC = storyboard!.instantiateViewController(identifier: "spotInfo") as SpotInfoViewController
        //        detailedVC.image = theImageCache[indexPath.row]
        spotInfoVC.clickedSpot = spotsList[indexPath.row]
        navigationController?.pushViewController(detailedVC, animated: true)
    }
    
    
}
