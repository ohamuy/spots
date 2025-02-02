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
import FirebaseStorage

class ProfileViewController: UIViewController, UIImagePickerControllerDelegate & UINavigationControllerDelegate{
    
    var imgPicker = UIImagePickerController()
    var currentImage: UIImage? = nil
    let db = Firestore.firestore()
    let user = Auth.auth().currentUser
    let uid = Auth.auth().currentUser?.uid ?? ""
    let storage = Storage.storage().reference()
    var imageData: Data?
    var numberOfSpots = 0
    
    @IBOutlet weak var profilePic: UIImageView!
    @IBOutlet weak var userName: UILabel!
    @IBOutlet weak var savedSpots: UILabel!
    
    @IBOutlet weak var profilePictureButton: UIButton!
    @IBOutlet weak var changePasswordButton: UIButton!
    @IBOutlet weak var logoutButton: UIButton!
    @IBOutlet weak var deleteUserButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        updateProfile()
        setName()
        
        imgPicker.delegate = self
        profilePic.layer.cornerRadius = 180 / 2
        profilePic.layer.borderColor = UIColor.init(red: 234/255, green: 226/255, blue: 197/255, alpha: 1).cgColor
        profilePic.layer.borderWidth = 6
        profilePic.layer.masksToBounds = false
        profilePic.clipsToBounds = true
        
        Utilities.styleButtonForProfile(profilePictureButton)
        Utilities.styleButtonForProfile(changePasswordButton)
        Utilities.styleButtonForProfile(logoutButton)
        Utilities.styleButtonForProfile(deleteUserButton)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        retrieveNumberOfSpots()
    }
    
    func updateProfile() {
        loadProfileImage()
    }
    
    func loadProfileImage() {
        storage.child("\(uid)/profile.png").downloadURL(completion: {url, error in
            guard let url = url, error == nil else {
                return
            }
            
            let urlString = url.absoluteString
            let urlFinal = URL(string: urlString)
            let task = URLSession.shared.dataTask(with: urlFinal!, completionHandler: { data, _, error in
                guard let data = data, error == nil else {
                    return
                }
                
                DispatchQueue.main.async {
                    let image = UIImage(data: data)
                    self.profilePic.image = image
                }
            })
            task.resume()
        })
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
        db.collection("users").whereField("uid", isEqualTo: uid)
            .getDocuments() { (querySnapshot, err) in
                if let err = err {
                    print("Error getting documents: \(err)")
                } else {
                    for document in querySnapshot!.documents {
                        let name: String = document.get("firstname") as! String
                        let last: String = document.get("lastname") as! String
                        let fullname = name + " " + last
                        self.userName.text = fullname
                        
                    }
                }
        }
    }
    
    func retrieveNumberOfSpots() {
        db.collection("spots").whereField("uid", isEqualTo: uid)
            .getDocuments() { (querySnapshot, err) in
                if let err = err {
                    print("Error getting documents: \(err)")
                } else {
                    self.numberOfSpots = 0
                    for _ in querySnapshot!.documents {
                        self.numberOfSpots += 1
                    }
                    self.savedSpots.text = String(self.numberOfSpots)
                }
        }
    }
    
    @IBAction func deleteUserTapped(_ sender: Any) {
        let confirm = UIAlertController(title: "Confirm Deletion", message: "Are you sure you want to delete your user? All associated data will also be deleted.", preferredStyle: .alert)
        confirm.addAction(UIAlertAction(title: NSLocalizedString("Cancel", comment: "Confirm"), style: .default, handler: { _ in
            NSLog("User NOT deleted")
            return
        }))
        confirm.addAction(UIAlertAction(title: NSLocalizedString("Yes", comment: "Confirm"), style: .default, handler: { _ in
            NSLog("User Deleted")
            
            //delete spots associated with user
            self.db.collection("spots").whereField("uid", isEqualTo: self.uid).getDocuments() { (querySnapshot, err) in
                if let err = err {
                    print("Error getting documents: \(err)")
                } else {
                    for document in querySnapshot!.documents {
                        //delete associated images
                        let docid = document.documentID
                        let ref = Storage.storage().reference().child("\(self.uid)/\(docid).png")
                        ref.delete { error in
                            if let error = error {
                                print(error)
                            } else {
                                //File deleted successfully
                            }
                        }
                        //delete spot document
                        document.reference.delete()
                    }
                    //delete the profile image
                    let ref = Storage.storage().reference().child("\(self.uid)/profile.png")
                    ref.delete { error in
                        if let error = error {
                            print(error)
                        } else {
                            //File deleted successfully
                        }
                    }
                }
            }
            
            //deleted genres associated with user
            self.db.collection("genres").whereField("uid", isEqualTo: self.uid).getDocuments() { (querySnapshot, err) in
                if let err = err {
                    print("Error getting documents: \(err)")
                } else {
                    for document in querySnapshot!.documents {
                        document.reference.delete()
                    }
                }
            }
            
            //deleted user document associated with user
            self.db.collection("users").whereField("uid", isEqualTo: self.uid).getDocuments() { (querySnapshot, err) in
                if let err = err {
                    print("Error getting documents: \(err)")
                } else {
                    for document in querySnapshot!.documents {
                        document.reference.delete()
                    }
                }
            }
            
            //delete user from user authentication
            self.user?.delete { error in
                if let error = error {
                    print(error)
                } else {
                    UserDefaults.standard.removeObject(forKey: "uid")
                    UserDefaults.standard.removeObject(forKey: "userEmail")
                    
                    let storyboard = UIStoryboard(name: "Main", bundle: nil)
                    let loginNavController = storyboard.instantiateViewController(identifier: "LoginNavigationController")
                    
                    (UIApplication.shared.connectedScenes.first?.delegate as? SceneDelegate)?.changeRootViewController(loginNavController)
                }
            }
        }))
        self.present(confirm, animated: true, completion: nil)
    }
    
    
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let image = info[UIImagePickerController.InfoKey(rawValue: "UIImagePickerControllerEditedImage")] as? UIImage {
            profilePic.image = image
            currentImage = profilePic.image
            profilePic.layer.cornerRadius = 180 / 2
            profilePic.layer.borderColor = UIColor.init(red: 234/255, green: 226/255, blue: 197/255, alpha: 1).cgColor
            profilePic.layer.borderWidth = 6
            profilePic.layer.masksToBounds = false
            profilePic.clipsToBounds = true
        }
        
        guard let image = info[UIImagePickerController.InfoKey.editedImage] as? UIImage else {return}
        
        if image.pngData() != nil {
            imageData = image.pngData()!
        }
        
        //store image in database
        self.storage.child("\(uid)/profile.png").putData(self.imageData!, metadata: nil, completion: { _, error in
            guard error == nil else {
                print("Failed to Upload")
                return
            }
        })
        
        
        dismiss(animated: true, completion: nil)
        
    }
    
    //Cancel image picker, no image was selected
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
}
