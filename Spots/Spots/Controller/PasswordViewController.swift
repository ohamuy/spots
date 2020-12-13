//
//  PasswordViewController.swift
//  Spots
//
//  Created by Oliver Hamuy on 11/29/20.
//  Copyright © 2020 SpotsDevelopers. All rights reserved.
//

import UIKit
import FirebaseAuth
import Firebase

class PasswordViewController: UIViewController {
    
    var newPassword: String?
    var confirmPassword: String?
    
    @IBOutlet weak var newPasswordLabel: UILabel!
    @IBOutlet weak var confirmPasswordLabel: UILabel!
    @IBOutlet weak var saveButton: UIButton!
    
    @IBOutlet weak var newPass: UITextField!
    
    @IBOutlet weak var confirmPass: UITextField!
    
    @IBOutlet weak var errorLabel: UILabel!
    

    override func viewDidLoad() {
        super.viewDidLoad()
        setDefault()
    }
    
    func setDefault() {
        Utilities.styleButton(saveButton)
        Utilities.styleLabel(newPasswordLabel)
        Utilities.styleLabel(confirmPasswordLabel)
        Utilities.styleTextFieldAppContent(newPass)
        Utilities.styleTextFieldAppContent(confirmPass)
        errorLabel.alpha = 0
    }
    
    func cleanInputs() -> [String?] {
        return [newPass.text?.trimmingCharacters(in: .whitespacesAndNewlines),
                confirmPass.text?.trimmingCharacters(in: .whitespacesAndNewlines)]
    }
    
    @IBAction func confirmPasswords(_ sender: Any) {
        if newPass.text != nil && newPass.text! == confirmPass.text! {
            let password = newPass.text!.trimmingCharacters(in: .whitespacesAndNewlines)
            if Utilities.isPasswordValid(password) == false {
                errorLabel.alpha = 1
                errorLabel.text = "Please enter a valid password containing at least 8 characters, one special character, and one number"
            }
            else{
                errorLabel.alpha = 0
                let user = Auth.auth().currentUser
                var credential: AuthCredential
                
                //re-authenticate user !!
                
                user?.updatePassword(to: password)
                do {try Auth.auth().signOut() }
                catch {print("no user logged in")}
                
                UserDefaults.standard.removeObject(forKey: "uid")
                UserDefaults.standard.removeObject(forKey: "userEmail")
                
                let storyboard = UIStoryboard(name: "Main", bundle: nil)
                let loginNavController = storyboard.instantiateViewController(identifier: "LoginNavigationController")
                
                (UIApplication.shared.connectedScenes.first?.delegate as? SceneDelegate)?.changeRootViewController(loginNavController)
            }
        }
        else {
            errorLabel.alpha = 1
            errorLabel.text = "Please fill in all fields and ensure inputs match"
        }
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
