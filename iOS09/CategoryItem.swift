//
//  CategoryItem.swift
//  UniGram
//
//  Created by Lydia Kondylidou on 10.11.17.
//  Copyright © 2017 Lydia Kondylidou. All rights reserved.
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
