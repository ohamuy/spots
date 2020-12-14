//
//  TestViewController.swift
//  Spots
//
//  Created by Oliver Hamuy on 12/13/20.
//  Copyright © 2020 SpotsDevelopers. All rights reserved.
//

import UIKit

class TestViewController: UIViewController, UITableViewDataSource {
    
    let array : [String] = []
    func favoritesSetup() {
        tableView.dataSource = self
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "tableCell")
        tableView.reloadData()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 20
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .subtitle, reuseIdentifier: "tableCell")
        cell.textLabel!.text = "potato"
        return cell
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        favoritesSetup()
        // Do any additional setup after loading the view.
    }
    
    @IBOutlet weak var tableView: UITableView!

}
