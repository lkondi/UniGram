//
//  CategoryItemsManager.swift
//  iOS09
//
//  Created by admin on 22.11.17.
//  Copyright © 2017 admin. All rights reserved.
//

import Foundation
import UIKit

class CategoryItemsManager: NSObject {
    
    static let sharedManager = CategoryItemsManager()
    
    private override init() {}
    
    // MARK: - Public Methods
    func loadData() -> [CategoryItem] {
        let path = Bundle.main.path(forResource: "CategoryItems", ofType: "plist")
        if let dataArray = NSArray(contentsOfFile: path!) {
            print("path not nil")
            return constructCategoryItemsFromArray(array: dataArray)
            
        } else {
            print("path nil")
            return [CategoryItem]()
        }
    }
    // MARK: - Private Methods
    private func constructCategoryItemsFromArray(array: NSArray) -> [CategoryItem] {
        var resultItems = [CategoryItem]()
        
        for object in array {
            let obj = object as! NSDictionary
            let name = obj["name"] as! String
            let image = obj["image"] as! String
            
            let loadedCategoryItem = CategoryItem(name: name, image: image)
            resultItems.append(loadedCategoryItem)
        }
        return resultItems
    }
}
