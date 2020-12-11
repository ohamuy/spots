//
//  ProfileViewController.swift
//  Spots
//
//  Created by Oliver Hamuy on 11/29/20.
//  Copyright © 2020 SpotsDevelopers. All rights reserved.
//

import UIKit
import FirebaseAuth
import Firebase

class ProfileViewController: UIViewController, UIImagePickerControllerDelegate & UINavigationControllerDelegate{
    
    var imgPicker = UIImagePickerController()

    var currentImage: UIImage? = nil
    
    @IBOutlet weak var profilePic: UIImageView!
    
    @IBOutlet weak var userName: UILabel!
    
    @IBOutlet weak var savedSpots: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        imgPicker.delegate = self
        setName()
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
    
    func setName() {
        //userName.text = Auth.auth().currentUser?.displayName
        let db = Firestore.firestore()
        let uid = Auth.auth().currentUser?.uid ?? ""
        db.collection("users").whereField("uid", isEqualTo: uid)
        .getDocuments() { (querySnapshot, err) in
        if let err = err {
            print("Error getting documents: \(err)")
        } else {
            for document in querySnapshot!.documents {
                //print("\(document.documentID) => \(document.data())")
                let name: String = document.get("firstname") as! String
                let last: String = document.get("lastname") as! String
                let fullname = name + " " + last
                self.userName.text = fullname
                
            }
        }
        }
//        let userSavedSpots: SavedSpotsViewController = SavedSpotsViewController()
//        let numSaved = userSavedSpots.spotsList.count
//        if numSaved != nil {
//           self.savedSpots.text = "# saved spots: \(numSaved)"
//       }
//    else {
//            self.savedSpots.text = "# saved spots: 0"
//        }
        self.savedSpots.text = "# Saved Spots: 0"
    }
      

    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {

        if let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {

            profilePic.image = image

            currentImage = profilePic.image

        }

        dismiss(animated: true, completion: nil)

    }
    
    
    

}
