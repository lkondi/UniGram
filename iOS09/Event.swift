//
//  Event.swift
//  iOS09
//
//  Created by admin on 29.11.17.
//  Copyright © 2017 admin. All rights reserved.
//

import UIKit
import os.log

class Event  {
    
    //MARK: Properties
    
    var eventName: String
    var eventImage: UIImage?
    var eventKey: String

    
    //MARK: Initialization
    
    init(eventName: String, eventImage: UIImage?, eventKey: String) {
        // Initialize stored properties.
        self.eventName = eventName
        self.eventImage = eventImage
        self.eventKey = eventKey
    }
    
}

