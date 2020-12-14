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
    var genreColorRGB: [String]?
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
        configureButtonColors()
        // Do any additional setup after loading the view.
        setDefault()
    }
    
    func setDefault() {
        Utilities.styleLabel(genreTitle)
        Utilities.styleLabel(descriptionTitle)
        Utilities.styleLabel(colorTitle)
        Utilities.styleTextFieldAppContent(titleInput)
        Utilities.styleTextFieldAppContent(descriptionInput)
        Utilities.styleButton(noColorButton)
    }
    
    func configureButtonColors() {
//        colorButtonCollection[0].backgroundColor = Utilities.yieldGenreColor(color: .pink).0
//        colorButtonCollection[1].backgroundColor = Utilities.yieldGenreColor(color: .red).0
//        colorButtonCollection[2].backgroundColor = Utilities.yieldGenreColor(color: .orange).0
//        colorButtonCollection[3].backgroundColor = Utilities.yieldGenreColor(color: .gold).0
//        colorButtonCollection[4].backgroundColor = Utilities.yieldGenreColor(color: .peach).0
//        colorButtonCollection[5].backgroundColor = Utilities.yieldGenreColor(color: .blue).0
//        colorButtonCollection[6].backgroundColor = Utilities.yieldGenreColor(color: .cyan).0
//        colorButtonCollection[7].backgroundColor = Utilities.yieldGenreColor(color: .green).0
//        colorButtonCollection[8].backgroundColor = Utilities.yieldGenreColor(color: .brown).0
//        colorButtonCollection[9].backgroundColor = Utilities.yieldGenreColor(color: .black).0
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
        for color in colorButtonCollection {
            color.layer.borderColor = UIColor.clear.cgColor
        }
        colorButtonCollection[1].layer.borderColor = UIColor.gray.cgColor
        genreColorRGB =  ["255", "59", "0"]
    }
    
    @IBAction func selectOrange(_ sender: Any) {
        for color in colorButtonCollection {
            color.layer.borderColor = UIColor.clear.cgColor
        }
        colorButtonCollection[2].layer.borderColor = UIColor.gray.cgColor
        genreColorRGB =  ["245", "145", "5"]
    }
    
    @IBAction func selectGold(_ sender: Any) {
        for color in colorButtonCollection {
            color.layer.borderColor = UIColor.clear.cgColor
        }
        colorButtonCollection[3].layer.borderColor = UIColor.gray.cgColor
        genreColorRGB =  ["245", "145", "5"]
    }
    
    @IBAction func selectPeach(_ sender: Any) {
        for color in colorButtonCollection {
            color.layer.borderColor = UIColor.clear.cgColor
        }
        colorButtonCollection[4].layer.borderColor = UIColor.gray.cgColor
        genreColorRGB = ["249", "127", "80"]
    }
    
    @IBAction func selectBlue(_ sender: Any) {
        for color in colorButtonCollection {
            color.layer.borderColor = UIColor.clear.cgColor
        }
        colorButtonCollection[5].layer.borderColor = UIColor.gray.cgColor
        genreColorRGB = ["10", "49", "121"]
    }
    
    @IBAction func selectCyan(_ sender: Any) {
        for color in colorButtonCollection {
            color.layer.borderColor = UIColor.clear.cgColor
        }
        colorButtonCollection[6].layer.borderColor = UIColor.gray.cgColor
        genreColorRGB = ["0", "175", "225"]
    }
    @IBAction func selectGreen(_ sender: Any) {
        for color in colorButtonCollection {
            color.layer.borderColor = UIColor.clear.cgColor
        }
        colorButtonCollection[7].layer.borderColor = UIColor.gray.cgColor
        genreColorRGB = ["93", "171", "29"]
    }
    @IBAction func selectBrown(_ sender: Any) {
        for color in colorButtonCollection {
            color.layer.borderColor = UIColor.clear.cgColor
        }
        colorButtonCollection[8].layer.borderColor = UIColor.gray.cgColor
        genreColorRGB = ["114", "80", "51"]
    }
    @IBAction func selectBlack(_ sender: Any) {
        for color in colorButtonCollection {
            color.layer.borderColor = UIColor.clear.cgColor
        }
        colorButtonCollection[8].layer.borderColor = UIColor.gray.cgColor
        genreColorRGB = ["51", "51", "51"]
    }
    
    @IBAction func colorButtonTapped(_ sender: Any) {
        //        let colorPicker = UIColorPickerViewController()
        //        colorPicker.delegate = self
        //        self.present(colorPicker, animated: true, completion: nil)
    }
    
    @IBAction func saveGenreButtonTapped(_ sender: Any) {
        let title = titleInput.text ?? ""
        if title.isEmpty {
            let noTitleErrorMsg = UIAlertController(title: "Title Required", message: "Every genre need a name. Add something to the title field, then try again.", preferredStyle: .alert)
            noTitleErrorMsg.addAction(UIAlertAction(title: NSLocalizedString("OK", comment: "Go back"), style: .default, handler: { _ in
                NSLog("Err: no title on genre save")
            }))
            self.present(noTitleErrorMsg, animated: true, completion: nil)
            return
        }
      
        let title = Utilities.parseInputToRecord(input: titleInput.text!)
        let desc = descriptionInput.text ?? ""
        // TODO: Firestore stuff
    }
    
    @IBAction func discardGenreButtonTapped(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
//    profilePic.layer.cornerRadius = profilepic.frame.width / 2
//    profilePic.layer.borderColor = UIColor.init(red: 234/255, green: 226/255, blue: 197/255, alpha: 1).cgColor
//    profilePic.layer.borderWidth = 6
//    profilePic.layer.masksToBounds = false
//    profilePic.clipsToBounds = true

    
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destination.
     // Pass the selected object to the new view controller.
     }
     */
    
}

//extension CustomGenreViewController: UIColorPickerViewControllerDelegate {
//    func colorPickerViewControllerDidFinish(_ colorPicker: UIColorPickerViewController) {
//        self.genreColor = colorPicker.selectedColor
//        colorView.backgroundColor = colorPicker.selectedColor
//    }

//    func colorPickerViewControllerDidSelectColor(_ viewController: UIColorPickerViewController) {
//    }
//}
