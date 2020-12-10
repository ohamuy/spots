//
//  ProfileViewController.swift
//  Spots
//
//  Created by Oliver Hamuy on 11/29/20.
//  Copyright © 2020 SpotsDevelopers. All rights reserved.
//

import UIKit

class ProfileViewController: UIViewController {
    
    var imgPicker = UIImagePickerController()
    
    var currentImage: UIImage? = nil
    
    @IBOutlet weak var profilePic: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        imgPicker.delegate = self
        // Do any additional setup after loading the view.
    }
    
    @IBAction func logoutTapped(_ sender: Any) {
        UserDefaults.standard.removeObject(forKey: "userEmail")
           
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let loginNavController = storyboard.instantiateViewController(identifier: "LoginNavigationController")
       
        (UIApplication.shared.connectedScenes.first?.delegate as? SceneDelegate)?.changeRootViewController(loginNavController)
    }
    
    @IBAction func changePic(_ sender: Any) {
        imgPicker.sourceType = .photoLibrary
        imgPicker.allowsEditing = true
        present(imgPicker, animated: true, completion: nil)
    }
    
   
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}

extension ProfileViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate{
      
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            profilePic.image = image
            currentImage = profilePic.image
        }
        dismiss(animated: true, completion: nil)
    }
   }
