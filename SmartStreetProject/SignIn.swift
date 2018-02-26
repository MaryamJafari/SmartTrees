//
//  SignInAndSignUpViewController.swift
//  SmartStreetProject
//
//  Created by Maryam Jafari on 10/8/17.
//  Copyright © 2017 Maryam Jafari. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth


class SignIn: UIViewController, UITextFieldDelegate {
    var emailAddress : String!
    @IBOutlet weak var pass: UITextField!
    @IBOutlet weak var email: UITextField!
    var name: String!
    var phone : String!
    var emailA : String!
    var password: String!
    override func viewDidLoad() {
        email.text = ""
        pass.text = ""
        super.viewDidLoad()
        pass.delegate = self
        email.delegate = self
        let color = UIColor(red:0.76, green:0.34, blue:0.0, alpha:1.0)
        self.navigationController?.navigationBar.tintColor = UIColor.gray
        self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedStringKey.foregroundColor:color]
        self.navigationController?.navigationBar.titleTextAttributes = [ NSAttributedStringKey.font: UIFont(name: "Avenir Next", size: 23)!]
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool
    {
        textField.resignFirstResponder()
        return true;
    }
    @IBAction func signIn(_ sender: Any) {
        
        if self.email.text == "" || self.pass.text == "" {
            let alertController = UIAlertController(title: "Error", message: "Please enter an email and password.", preferredStyle: .alert)
            let defaultAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
            alertController.addAction(defaultAction)
            self.present(alertController, animated: true, completion: nil)
            
        } else {
            
            Auth.auth().signIn(withEmail: self.email.text!, password: self.pass.text!) { (user, error) in
                
                if error == nil {
                    print("You have successfully logged in")
                    let emailAddress = self.email.text
                    self.performSegue(withIdentifier: "LogIn", sender: emailAddress)
                } else {
                    let alertController = UIAlertController(title: "Error", message: error?.localizedDescription, preferredStyle: .alert)
                    
                    let defaultAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
                    alertController.addAction(defaultAction)
                    
                    self.present(alertController, animated: true, completion: nil)
                }
            }
        }
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "LogIn"{
            
            if let destinationNavigationController = segue.destination as? UINavigationController{
                let targetController = destinationNavigationController.topViewController as? Nearby
                if let email = sender as? String{
                    targetController?.emailAddress = email
                    targetController?.password = password
                    targetController?.name = name
                    targetController?.phone = phone
                    UserDefaults.standard.set(email, forKey: "email")
                    UserDefaults.standard.set(password, forKey: "password")
                    UserDefaults.standard.set(phone, forKey: "phone")
                    UserDefaults.standard.set(name, forKey: "name")
                }
            }
        }
    }
    
    @IBAction func barcodeSignIn(_ sender: Any) {
        
        performSegue(withIdentifier: "userBarcode", sender: "")
    }
    
}
