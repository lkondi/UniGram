//
//  CategoryItem.swift
//  iOS09
//
//  Created by admin on 22.11.17.
//  Copyright © 2017 admin. All rights reserved.
//

import Foundation
import UIKit

class CategoryItem: NSObject {
    
    var name: String
    var image: String
    
    init(name: String, image: String) {
        self.name = name
        self.image = image
    }
}

