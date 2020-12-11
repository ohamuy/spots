//
//  ProfileViewController.swift
//  Spots
//
//  Created by Oliver Hamuy on 11/29/20.
//  Copyright © 2020 SpotsDevelopers. All rights reserved.
//

import UIKit
import FirebaseAuth

class ProfileViewController: UIViewController, UIImagePickerControllerDelegate & UINavigationControllerDelegate{
    
    var imgPicker = UIImagePickerController()

    var currentImage: UIImage? = nil
    
    @IBOutlet weak var profilePic: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        imgPicker.delegate = self
    }
    
    @IBAction func changePic(_ sender: Any) {
        imgPicker.sourceType = .photoLibrary

        imgPicker.allowsEditing = true

        present(imgPicker, animated: true, completion: nil)
    }
    
    @IBAction func logoutTapped(_ sender: Any) {
        //logout user from auth()
        do {try Auth.auth().signOut() }
        catch {print("no user logged in")}

        UserDefaults.standard.removeObject(forKey: "uid")
        UserDefaults.standard.removeObject(forKey: "userEmail")
           
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let loginNavController = storyboard.instantiateViewController(identifier: "LoginNavigationController")
       
        (UIApplication.shared.connectedScenes.first?.delegate as? SceneDelegate)?.changeRootViewController(loginNavController)
    }
    

      

    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {

        if let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {

            profilePic.image = image

            currentImage = profilePic.image

        }

        dismiss(animated: true, completion: nil)

    }
    

}
