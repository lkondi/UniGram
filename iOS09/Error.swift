//
//  Error.swift
//  iOS09
//
//  Created by Lydia Kondylidou on 12.01.18.
//  Copyright © 2018 admin. All rights reserved.
//

import Foundation
import FirebaseAuth

class Error {
    
    var errorMessage: String!
    
    init(error: AuthErrorCode) {
        switch error {
            
        case .invalidEmail:
            errorMessage = "Whoops! That's not a valid email!"
            
        case .userDisabled:
            errorMessage = "This user is blocked."
            
        case .wrongPassword:
            errorMessage = "Looks like the email or password is incorrect!"
            
        case .emailAlreadyInUse:
            errorMessage = "There's already an account with this email!"
            
        case .weakPassword:
            errorMessage = "The password is too weak. Try something stronger!"
            
        default:
            errorMessage = "Looks like something went wrong. Please try again!"
        }
    }
    
}

