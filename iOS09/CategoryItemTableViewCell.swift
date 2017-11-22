//
//  CategoryItemTableViewCell.swift
//  UniGram
//
//  Created by Lydia Kondylidou on 10.11.17.
//  Copyright © 2017 Lydia Kondylidou. All rights reserved.
//

import Foundation
import UIKit

class CategoryItemTableViewCell: UITableViewCell {
    
    @IBOutlet weak var categoryItemImageView: UIImageView?
    @IBOutlet weak var categoryItemNameLabel: UILabel?
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
}
