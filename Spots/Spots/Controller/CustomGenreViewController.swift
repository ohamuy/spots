//
//  CustomGenreViewController.swift
//  Spots
//
//  Created by David Easton on 12/11/20.
//  Copyright © 2020 SpotsDevelopers. All rights reserved.
//

import UIKit
import FirebaseStorage
import FirebaseAuth
import Firebase

class CustomGenreViewController: UIViewController {
    
    // Model variables
    var genreColor: UIColor?
    var genreColorRGB: [String] = ["","",""]
    var recordId: String?
    var genreDescription: String?
    
    // Outlets
    @IBOutlet weak var genreTitle: UILabel!
    @IBOutlet var titleInput: UITextField!
    @IBOutlet weak var descriptionTitle: UILabel!
    @IBOutlet var descriptionInput: UITextField!
    @IBOutlet weak var colorTitle: UILabel!
    @IBOutlet var colorButtonCollection: [ColorButton]!
    
    @IBOutlet weak var noColorButton: UIButton!
    
    @IBOutlet weak var saveButton: UIButton!
    @IBOutlet weak var cancelButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    
        setDefault()
    }
    
    func setDefault() {
        Utilities.styleLabel(genreTitle)
        Utilities.styleLabel(descriptionTitle)
        Utilities.styleLabel(colorTitle)
        Utilities.styleTextFieldAppContent(titleInput)
        Utilities.styleTextFieldAppContent(descriptionInput)
        Utilities.styleButton(noColorButton)
        Utilities.styleButton(saveButton)
        Utilities.styleButton(cancelButton)
        noColorButton.layer.borderWidth = 3
        noColorButton.layer.borderColor = UIColor.clear.cgColor
    }
    
    // Event handlers
    @IBAction func selectPink(_ sender: Any) {
        for color in colorButtonCollection {
            color.layer.borderColor = UIColor.clear.cgColor
        }
        colorButtonCollection[0].layer.borderColor = UIColor.gray.cgColor
        genreColorRGB =  ["193", "112", "184"]
    }
    
    @IBAction func selectRed(_ sender: Any) {
        noColorButton.layer.borderColor = UIColor.clear.cgColor
        for color in colorButtonCollection {
            color.layer.borderColor = UIColor.clear.cgColor
        }
        colorButtonCollection[1].layer.borderColor = UIColor.gray.cgColor
        genreColorRGB =  ["255", "59", "0"]
    }
    
    @IBAction func selectOrange(_ sender: Any) {
        noColorButton.layer.borderColor = UIColor.clear.cgColor
        for color in colorButtonCollection {
            color.layer.borderColor = UIColor.clear.cgColor
        }
        colorButtonCollection[2].layer.borderColor = UIColor.gray.cgColor
        genreColorRGB =  ["245", "145", "5"]
    }
    
    @IBAction func selectGold(_ sender: Any) {
        noColorButton.layer.borderColor = UIColor.clear.cgColor
        for color in colorButtonCollection {
            color.layer.borderColor = UIColor.clear.cgColor
        }
        colorButtonCollection[3].layer.borderColor = UIColor.gray.cgColor
        genreColorRGB =  ["245", "145", "5"]
    }
    
    @IBAction func selectPeach(_ sender: Any) {
        noColorButton.layer.borderColor = UIColor.clear.cgColor
        for color in colorButtonCollection {
            color.layer.borderColor = UIColor.clear.cgColor
        }
        colorButtonCollection[4].layer.borderColor = UIColor.gray.cgColor
        genreColorRGB = ["249", "127", "80"]
    }
    
    @IBAction func selectBlue(_ sender: Any) {
        noColorButton.layer.borderColor = UIColor.clear.cgColor
        for color in colorButtonCollection {
            color.layer.borderColor = UIColor.clear.cgColor
        }
        colorButtonCollection[5].layer.borderColor = UIColor.gray.cgColor
        genreColorRGB = ["10", "49", "121"]
    }
    
    @IBAction func selectCyan(_ sender: Any) {
        noColorButton.layer.borderColor = UIColor.clear.cgColor
        for color in colorButtonCollection {
            color.layer.borderColor = UIColor.clear.cgColor
        }
        colorButtonCollection[6].layer.borderColor = UIColor.gray.cgColor
        genreColorRGB = ["0", "175", "225"]
    }
    @IBAction func selectGreen(_ sender: Any) {
        noColorButton.layer.borderColor = UIColor.clear.cgColor
        for color in colorButtonCollection {
            color.layer.borderColor = UIColor.clear.cgColor
        }
        colorButtonCollection[7].layer.borderColor = UIColor.gray.cgColor
        genreColorRGB = ["93", "171", "29"]
    }
    @IBAction func selectBrown(_ sender: Any) {
        noColorButton.layer.borderColor = UIColor.clear.cgColor
        for color in colorButtonCollection {
            color.layer.borderColor = UIColor.clear.cgColor
        }
        colorButtonCollection[8].layer.borderColor = UIColor.gray.cgColor
        genreColorRGB = ["114", "80", "51"]
    }
    @IBAction func selectBlack(_ sender: Any) {
        noColorButton.layer.borderColor = UIColor.clear.cgColor
        for color in colorButtonCollection {
            color.layer.borderColor = UIColor.clear.cgColor
        }
        colorButtonCollection[9].layer.borderColor = UIColor.gray.cgColor
        genreColorRGB = ["51", "51", "51"]
    }
    
    @IBAction func noColorTapped(_ sender: UIButton) {
        sender.layer.borderColor = UIColor.gray.cgColor
        genreColorRGB = ["","",""]
    }
    
    //Save genre to
    @IBAction func saveGenreButtonTapped(_ sender: Any) {
        var title = titleInput.text ?? ""
        if title.isEmpty {
            let noTitleErrorMsg = UIAlertController(title: "Title Required", message: "Every genre needs a name. Add something to the title field, then try again.", preferredStyle: .alert)
            noTitleErrorMsg.addAction(UIAlertAction(title: NSLocalizedString("OK", comment: "Go back"), style: .default, handler: { _ in
                NSLog("Err: no title on genre save")
            }))
            self.present(noTitleErrorMsg, animated: true, completion: nil)
            return
        }
      
        title = Utilities.parseInputToRecord(input: titleInput.text!)
        let desc = descriptionInput.text ?? "null"
        let db = Firestore.firestore()
        let uid = Auth.auth().currentUser?.uid
        
        db.collection("genres").addDocument(data: [
            "color" : genreColorRGB,
            "genre_record" : title,
            "description" : desc,
            "uid" : uid!
        ])
        
        
    }
    
    //Add functionality to cancel button
    @IBAction func cancelButtonTapped(_ sender: Any) {

    }
}
