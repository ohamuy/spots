//
//  CustomPinViewController.swift
//  Spots
//
//  Created by Oliver Hamuy on 12/9/20.
//  Copyright © 2020 SpotsDevelopers. All rights reserved.
//

import UIKit
import FirebaseAuth

class CustomPinViewController: UIViewController {

    @IBOutlet weak var pageTitle: UILabel!
    @IBOutlet weak var locationTitle: UILabel!
    @IBOutlet weak var previewTitle: UILabel!
    @IBOutlet weak var addImageButton: UIButton!
    @IBOutlet weak var finishButton: UIButton!
    
    @IBOutlet weak var titleInputField: UITextField!
    @IBOutlet weak var genreInputField: UITextField!
    @IBOutlet weak var subtitleTextField: UITextField!
    
    @IBOutlet weak var titlePreview: UILabel!
    @IBOutlet weak var subtitlePreview: UILabel!
    @IBOutlet weak var imagePreview: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setDefault()
    }
    
    func setDefault () {
        Utilities.styleLabel(pageTitle)
        Utilities.styleLabel(locationTitle)
        Utilities.styleLabel(previewTitle)
        Utilities.styleButton(addImageButton)
        Utilities.styleButton(finishButton)
        Utilities.styleTextFieldAppContent(titleInputField)
        Utilities.styleTextFieldAppContent(genreInputField)
        Utilities.styleTextFieldAppContent(subtitleTextField)
    }

    @IBAction func titleTextFieldChanged(_ sender: UITextField) {
        titlePreview.text = sender.text
        let user = Auth.auth().currentUser
        if user != nil {
            print(user!.uid)
        }
    }
    
    @IBAction func subtitleTextFieldChanged(_ sender: UITextField) {
        subtitlePreview.text = sender.text
    }
    
    
    
    
    //https://www.youtube.com/watch?v=yggOGEzueFk
    @IBAction func addImageTapped(_ sender: Any) {
        let vc = UIImagePickerController()
        vc.sourceType = .photoLibrary
        vc.delegate = self
        vc.allowsEditing = true
        present(vc, animated: true)
    }
    
}

extension CustomPinViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let image = info[UIImagePickerController.InfoKey(rawValue: "UIImagePickerControllerEditedImage")] as? UIImage {
            imagePreview.image = image
        }
        
        picker.dismiss(animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
}
