//
//  LoginViewController.swift
//  Spots
//
//  Created by Oliver Hamuy on 11/27/20.
//  Copyright © 2020 SpotsDevelopers. All rights reserved.
//

import UIKit
import FirebaseAuth

class LoginViewController: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var emailTextField: UITextField!
    
    @IBOutlet weak var passwordTextField: UITextField!
    
    @IBOutlet weak var loginButton: UIButton!
    
    @IBOutlet weak var errorLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setDefault()
    }
    
    //Style default buttons and error label
    func setDefault () {
        errorLabel.alpha = 0
        
        //style button and fields here
        Utilities.styleButton(loginButton)
        Utilities.styleTextField(emailTextField)
        Utilities.styleTextField(passwordTextField)
        self.emailTextField.delegate = self
        self.passwordTextField.delegate = self 
    }
    
    //Clean Inputs
    func cleanInputs() -> [String?] {
        return [emailTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines),
        passwordTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines)]
    }
    
    //Show error
    func showError(_ message: String) {
        errorLabel.text = message
        errorLabel.alpha = 1
    }
    
    @IBAction func loginTapped(_ sender: Any) {
        //Clean inputs
        let inputs = cleanInputs()
        
        //Sign in user
        Auth.auth().signIn(withEmail: inputs[0]!, password: inputs[1]!) { (result, error) in
            if error != nil {
                self.showError(error!.localizedDescription)
            }
            else {
                //Store Username in UserDefualts
                //https://www.hackingwithswift.com/example-code/system/how-to-save-user-settings-using-userdefaults
                let defaults = UserDefaults.standard
                defaults.set(Auth.auth().currentUser?.uid, forKey: "uid")
                
                let storyboard = UIStoryboard(name: "Main", bundle: nil)
                let mainTabBarController = storyboard.instantiateViewController(identifier: "MainTabBarController")
               
                // This is to get the SceneDelegate object from your view controller
                // then call the change root view controller function to change to main tab bar
                (UIApplication.shared.connectedScenes.first?.delegate as? SceneDelegate)?.changeRootViewController(mainTabBarController)
            }
        }
    }
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}
