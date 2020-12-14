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
    var recordId: String?
    var genreDescription: String?
    
    // Outlets
    @IBOutlet var titleInput: UITextField!
    @IBOutlet var descriptionInput: UITextField!
    @IBOutlet var colorView: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }
    
    
    // Event handlers
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
        
        let record = Utilities.parseInputToRecord(input: title)
        let description = descriptionInput.text ?? ""
        let colorString = Utilities.convertColorToHex(color: genreColor)
        print("Genre record \(record)")
        print("Genre desc \(description)")
        print("Genre color string \(colorString)")
        
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
