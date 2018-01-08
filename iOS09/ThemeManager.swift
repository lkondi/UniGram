//
//  ThemeManager.swift
//  iOS09
//
//  Created by Lydia Kondylidou on 08.01.18.
//  Copyright © 2018 admin. All rights reserved.
//

import Foundation
import UIKit

private let NavigationBarFontSize = 18.0
private let NavigationBarFontName = "KozGoPro-Light"

class ThemeManager: NSObject {
    
    static let sharedManager = ThemeManager()
    
    private override init() {}
    
    func applyNavigationBarTheme() {
        UINavigationBar.appearance().titleTextAttributes = [NSAttributedStringKey.foregroundColor: UIColor.white, NSAttributedStringKey.font: UIFont(name: NavigationBarFontName, size: CGFloat(NavigationBarFontSize))!]
    }
}
