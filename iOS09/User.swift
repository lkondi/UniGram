//
//  Users.swift
//  iOS09
//
//  Created by admin on 15.11.17.
//  Copyright © 2017 admin. All rights reserved.
//

import Foundation
import FirebaseDatabase

struct User {
    
    let uid: String
    let userName: String
    let email: String
    let password: String
    
    init(authData: User) {
        uid = authData.uid
        userName = authData.userName
        email = authData.email
        password = authData.password
    }
    
    init(uid: String, userName: String, email: String, password: String) {
        self.uid = uid
        self.userName = userName
        self.email = email
        self.password = password
    }
    
    
    func toAnyObject() -> Any {
        return [
            "userName": userName,
            "email": email,
            "password": password
        ]
    }
    
}
