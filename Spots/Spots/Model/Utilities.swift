//
//  LoginUtilities.swift
//  Spots
//
//  Created by Oliver Hamuy on 11/28/20.
//  Copyright © 2020 SpotsDevelopers. All rights reserved.
//

import Foundation
import UIKit

//APP COLORS
//LIGHT GREEN: #aecfbc / 174, 207, 188
//TURQOISE: #258b90 / 37, 139, 144
//TAN: #eae2c5 / 234, 226, 197


class Utilities {
    
    static func styleTextField(_ textfield: UITextField) {
        //Create Underline
        let underline = CALayer()
        
        underline.frame = CGRect(x: 0, y:textfield.frame.height - 2, width: textfield.frame.width, height: 2)
        underline.backgroundColor = UIColor.init(red: 234/255, green: 226/255, blue: 197/255, alpha: 1).cgColor
        
        textfield.borderStyle = .none
        textfield.textColor = UIColor.init(red: 37/255, green: 139/255, blue: 144/255, alpha: 1)
        textfield.layer.addSublayer(underline)
    }
    
    static func styleTextFieldAppContent(_ textfield: UITextField) {
        //Create Underline
        let underline = CALayer()
        
        underline.frame = CGRect(x: 0, y:textfield.frame.height - 2, width: textfield.frame.width, height: 2)
        underline.backgroundColor = UIColor.init(red: 234/255, green: 226/255, blue: 197/255, alpha: 1).cgColor
        
        textfield.borderStyle = .none
        textfield.textColor = UIColor.init(red: 71/255, green: 71/255, blue: 71/255, alpha: 1)
        textfield.layer.addSublayer(underline)
    }
    
    static func styleLabel(_ label: UILabel) {
        //Create Underline
        let underline = CALayer()
        
        underline.frame = CGRect(x: 0, y:label.frame.height - 2, width: label.frame.width, height: 2)
        underline.backgroundColor = UIColor.init(red: 234/255, green: 226/255, blue: 197/255, alpha: 1).cgColor
        
        label.textColor = UIColor.init(red: 71/255, green: 71/255, blue: 71/255, alpha: 1)
        label.layer.addSublayer(underline)
    }
    
    static func styleButton(_ button:UIButton) {
        button.backgroundColor = UIColor.init(red: 37/255, green: 139/255, blue: 144/255, alpha: 1)
        button.layer.cornerRadius = 15.0
        button.tintColor = UIColor.init(red: 234/255, green: 226/255, blue: 197/255, alpha: 1)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 15)
    }
    
    static func isPasswordValid(_ password: String) -> Bool {
        //Must have at least 8 characters, one special character, and one number
        let checkPassword = NSPredicate(format: "SELF MATCHES %@", "^(?=.*[a-z])(?=.*[$@$#!%*?&])[A-Za-z\\d$@$#!%*?&]{8,}")
        return checkPassword.evaluate(with: password);
    }
    
    static func goToMain () {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let mainTabBarController = storyboard.instantiateViewController(identifier: "MainTabBarController")
        
        // This is to get the SceneDelegate object from your view controller
        // then call the change root view controller function to change to main tab bar
        (UIApplication.shared.connectedScenes.first?.delegate as? SceneDelegate)?.changeRootViewController(mainTabBarController)
    }
    
    // clear user input for firestore record
    static func parseInputToRecord (input: String) -> String {
        let clean = input.trimmingCharacters(in: .whitespacesAndNewlines)
        return clean.lowercased().replacingOccurrences(of: " ", with: "_")
    }
    
    // prepare record name for display to user
    static func parseRecordToDisplayText (record: String) -> String {
        if record == NO_GENRE {
            return "No Genre"
        }
        let components = record.components(separatedBy: "_")
        var rejoin = [String]();
        for c in components {
            print(c)
            if !connectors.contains(c) {
                rejoin.append(c.prefix(1).uppercased() + c.lowercased().dropFirst())
            }
            else {
                rejoin.append(c)
            }
        }
        return rejoin.joined(separator: " ")
    }
}
