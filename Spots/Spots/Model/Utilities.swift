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
    
    static func styleButtonForProfile(_ button:UIButton) {
        let thickness: CGFloat = 2.0
        let topBorder = CALayer()
        topBorder.frame = CGRect(x: 0.0, y: 0.0, width: button.frame.size.width, height: thickness)
        //button.layer.borderWidth = 3
        button.layer.addSublayer(topBorder)
        topBorder.backgroundColor = UIColor.init(red: 234/255, green: 226/255, blue: 197/255, alpha: 1).cgColor
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
    
    // convert UI color to hexidecimal string
    // inspired and tweaked from this code https://stackoverflow.com/questions/26341008/how-to-convert-uicolor-to-hex-and-display-in-nslog
    static func convertColorToHex(color: UIColor?) -> String {
        if color == nil {
            return "#000000"
        }
        let codeRGB = color!.cgColor.components
        
        let colorInHex = String.init(
            format: "#%02lX%02lX%02lX",
            floor(Float((codeRGB?[0] ?? 0.0) * 255)),   // red
            floor(Float((codeRGB?[1] ?? 0.0) * 255)),   // green
            floor(Float((codeRGB?[2] ?? 0.0) * 255)))   // blue
        print(colorInHex)
        return colorInHex
    }
    
    static func convertColorToHex(color: genreColor ) -> (UIColor, [String]) {
        switch(color) {
            case .pink:
                return (UIColor(red: 193, green: 112, blue: 184, alpha: 1.0), ["193", "112", "184"])
            case .red:
                return (UIColor(red: 255, green: 59, blue: 0, alpha: 1.0), ["255", "59", "0"])
            case .orange:
                return (UIColor(red: 245, green: 145, blue: 5, alpha: 1.0), ["245", "145", "5"])
            case .gold:
                return (UIColor(red: 255, green: 180, blue: 0, alpha: 1.0), ["255", "180", "0"])
            case .peach:
                return (UIColor(red: 249, green: 127, blue: 80, alpha: 1.0), ["249", "127", "80"])
            case .blue:
                return (UIColor(red: 10, green: 49, blue: 121, alpha: 1.0), ["10", "49", "121"])
            case .cyan:
                return (UIColor(red: 0, green: 175, blue: 225, alpha: 1.0), ["0", "175", "225"])
            case .green:
                return (UIColor(red: 93, green: 171, blue: 29, alpha: 1.0), ["93", "171", "29"])
            case .brown:
                return (UIColor(red: 114, green: 80, blue: 51, alpha: 1.0), ["114", "80", "51"])
            case .black:
                return (UIColor(red: 51, green: 51, blue: 51, alpha: 1.0), ["51", "51", "51"])
        }
    }
}
