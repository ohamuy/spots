//
//  SignUpViewController.swift
//  Spots
//
//  Created by Oliver Hamuy on 11/27/20.
//  Copyright © 2020 SpotsDevelopers. All rights reserved.
//

import UIKit
import FirebaseAuth
import Firebase

//Learned how to create user authentication here:
//https://www.youtube.com/watch?v=1HN7usMROt8

class SignUpViewController: UIViewController {
    
    @IBOutlet weak var firstNameTextField: UITextField!
    
    @IBOutlet weak var lastNameTextField: UITextField!
    
    @IBOutlet weak var emailTextField: UITextField!
    
    @IBOutlet weak var passwordTextField: UITextField!
    
    @IBOutlet weak var registerButton: UIButton!
   
    @IBOutlet weak var errorLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setDefault()
        
    }
    
    //Style buttons and show error label default values
    func setDefault () {
        errorLabel.alpha = 0
        
        //style button and fields
        LoginUtilities.styleButton(registerButton)
        LoginUtilities.styleTextField(firstNameTextField)
        LoginUtilities.styleTextField(lastNameTextField)
        LoginUtilities.styleTextField(emailTextField)
        LoginUtilities.styleTextField(passwordTextField)
    }
    
    //Clean Inputs
    func cleanInputs() -> [String?] {
        return [firstNameTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines),
        lastNameTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines),
        emailTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines),
        passwordTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines)]
    }
    
    //Check if all fields are filled and if password is valid
    func validateFields() -> String? {
        //Get cleaned inputs
        let inputs = cleanInputs()
        
        //Check if all fields are filled
        if inputs[0] == "" || inputs[1] == "" || inputs[2] == "" || inputs[3] == "" {
            return "Please fill in all fields."
        }
        
        let password = passwordTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
        
        if LoginUtilities.isPasswordValid(password) == false {
            return "Please enter a valid password containing at least 8 characters, one special character, and one number"
        }
        
        return nil
    }
    
    //Show error message
    func showError(_ message: String) {
        errorLabel.text = message
        errorLabel.alpha = 1
    }
    
    @IBAction func registerTapped(_ sender: Any) {
        //Check if password is valid
        let errorMessage = validateFields()
        
        //If there is an error, show error
        if errorMessage != nil {
            showError(errorMessage!)
        }
        else {
            //Get cleaned inputs
            let inputs = cleanInputs()
            
            //Create a user in the database
            Auth.auth().createUser(withEmail: inputs[2]!, password: inputs[3]!) { (result, error) in
                //Check for erros
                if error != nil {
                    //There was an error
                    self.showError("Error creating user")
                }
                else {
                    //User created successfully
                    let db = Firestore.firestore()
                    
                    db.collection("users").addDocument(data: ["firstname": inputs[0]!,
                        "lastname": inputs[1]!, "uid": result!.user.uid]) { (error) in
                            
                        if error != nil { //fix this maybe later
                            self.showError("User data couldn't be saved")
                        }
                    }
                    
                    //Login to home page
                    LoginUtilities.goToMain()
                }
            }
            
        }
    }
    
    
}
