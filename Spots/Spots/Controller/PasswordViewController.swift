//
//  PasswordViewController.swift
//  Spots
//
//  Created by Oliver Hamuy on 11/29/20.
//  Copyright © 2020 SpotsDevelopers. All rights reserved.
//

import UIKit

class PasswordViewController: UIViewController {

    var newPassword: String?
    var confirmPassword: String?
    
    @IBOutlet weak var saveButton: UIButton!
    
    @IBOutlet weak var newPass: UITextField!
    
    @IBOutlet weak var confirmPass: UITextField!
   
    @IBAction func confirmPasswords(_ sender: Any) {
        if newPass.text != nil && newPass.text! == confirmPass.text! {
            
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        Utilities.styleButton(saveButton)
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
