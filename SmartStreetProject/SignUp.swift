//
//  SignUp.swift
//  SmartStreetProject
//
//  Created by Maryam Jafari on 10/24/17.
//  Copyright © 2017 Maryam Jafari. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth

class SignUp: UIViewController, UITextFieldDelegate {
    @IBOutlet weak var pass: UITextField!
    @IBOutlet weak var email: UITextField!
    @IBOutlet weak var fullName: UITextField!
    @IBOutlet weak var phoneNumber: UITextField!
    var name: String!
    var phone : String!
    var emailAddress : String!
    var password : String!
    var uid : String!
    var userEmail : String!
    var userPhoneNumber : String!
    var userFullName : String!
    var userPass : String!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        pass.delegate = self
        email.delegate = self
        email.text = emailAddress
        pass.text = password
        fullName.text = name
        phoneNumber.text = phone
    }
    func textFieldShouldReturn(_ textField: UITextField) -> Bool
    {
        textField.resignFirstResponder()
        return true;
    }
    
    
    @IBAction func signUp(_ sender: Any) {
        
        if email.text == "" {
            let alertController = UIAlertController(title: "Error", message: "Please enter your email and password", preferredStyle: .alert)
            let defaultAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
            alertController.addAction(defaultAction)
            
            present(alertController, animated: true, completion: nil)
            
        } else {
            Auth.auth().createUser(withEmail: email.text!, password: pass.text!) { (user, error) in
                
                let user = Auth.auth().currentUser
                if let user = user {
                    self.uid = user.uid
                    
                }
                if let password = self.pass.text{
                    self.userPass = password
                }
                if let name = self.fullName.text{
                    self.userFullName = name
                }
                if let email = self.email.text{
                    self.userEmail = email
                }
                if let phoneNum = self.phoneNumber.text {
                    self.userPhoneNumber = phoneNum
                }
                DBProvider.Instance.saveUser(withID: self.uid, pass: self.userPass, email : self.userEmail, phone: self.userPhoneNumber, name: self.userFullName)
                if error == nil {
                    print("You have successfully signed up")
                    let alertController = UIAlertController(title: "Succesful", message: "You Signed up Succesfully", preferredStyle: .alert)
                    let defaultAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
                    alertController.addAction(defaultAction)
                    self.present(alertController, animated: true, completion: nil)
                } else {
                    let alertController = UIAlertController(title: "Error", message: error?.localizedDescription, preferredStyle: .alert)
                    let defaultAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
                    alertController.addAction(defaultAction)
                    self.present(alertController, animated: true, completion: nil)
                }
            }
        }
        performSegue(withIdentifier: "BackFromSignUp", sender: self)
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "BackFromSignUp"{
            if let destination = segue.destination as? SignIn{
                destination.emailA = email.text
                destination.password = pass.text
                destination.name = fullName.text
                destination.phone = phoneNumber.text
                
            }
        }
        
    }
}
