//
//  DBProvider.swift
//  SmartStreetProject
//
//  Created by Maryam Jafari on 2/7/18.
//  Copyright © 2018 Maryam Jafari. All rights reserved.
//

import Foundation
import FirebaseDatabase


class DBProvider {
    private static let _instance = DBProvider();
    
    private init(){}
    static var Instance : DBProvider{
        return _instance
    }
    var dbRef : DatabaseReference {
        return Database.database().reference()
    }
    var contactsRef : DatabaseReference{
        return dbRef.child(Constant.PROFILE)
    }
    func saveUser (withID: String, pass : String, email : String, phone : String, name : String){
        let data : Dictionary<String, Any> = [Constant.EMAIL : email, Constant.PASSWORD : pass, Constant.PHONE : phone, Constant.NAME : name]
        contactsRef.child(withID).setValue(data)
    }
    
}
