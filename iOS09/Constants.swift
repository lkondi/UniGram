//
//  Constants.swift
//  iOS09
//
//  Created by Lydia Kondylidou on 22.11.17.
//  Copyright © 2017 admin. All rights reserved.
//

import Foundation
import Firebase

struct Constants
{
    struct refs
    {
        static let databaseRoot = Database.database().reference()
        static let databaseChats = databaseRoot.child("chats")
    }
}
