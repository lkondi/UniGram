//
//  Users.swift
//  iOS09
//
//  Created by admin on 15.11.17.
//  Copyright © 2017 admin. All rights reserved.
//

import Foundation
import FirebaseDatabase
import FirebaseAuth
import UIKit

class User {
    
    let uid: String
    let userName: String
    let email: String
    let password: String
    var picture: UIImage?
    
    init(authData: User) {
        uid = authData.uid
        userName = authData.userName
        email = authData.email
        password = authData.password
        picture = authData.picture
    }
    
    init(uid: String, userName: String, email: String, password: String) {
        self.uid = uid
        self.userName = userName
        self.email = email
        self.password = password
    }
    
    init(uid: String, userName: String, email: String, password: String, picture: UIImage?) {
        self.uid = uid
        self.userName = userName
        self.email = email
        self.password = password
        self.picture = picture
    }
    
    
    func toAnyObject() -> Any {
        return [
            "userName": userName,
            "email": email,
            "password": password
        ]
    }
    
    class func info(forUserID: String, completion: @escaping (User) -> Swift.Void) {
        Database.database().reference().child("users").child(forUserID).observeSingleEvent(of: .value, with: { (snapshot) in
            if let value = snapshot.value as? NSDictionary {
                let name = value["username"] as? String ?? ""
                let email = value["email"] as? String ?? ""
                let password = value["password"] as? String ?? ""
                //todo picture
                print("profile pic")
                let picture = UIImage(named: "profile pic")
                let user = User.init(uid: forUserID, userName: name, email: email, password: password, picture: picture!)
                completion(user)
                }
            })
        }
    
    class func downloadAllUsers(exceptID: String, completion: @escaping (User) -> Swift.Void) {
        Database.database().reference().child("users").observe(.childAdded, with: { (snapshot) in
            let id = snapshot.key
            let value = snapshot.value as? NSDictionary
            if id != exceptID {
                let name = value!["username"] as? String ?? ""
                let email = value!["email"] as? String ?? ""
                let password = value!["password"] as? String ?? ""
                //todo picture
                print("profile pic")
                let picture = UIImage(named: "profile pic")
                let user = User.init(uid: id, userName: name, email: email, password: password, picture: picture!)
                completion(user)
            }
        })
    }
    
}
