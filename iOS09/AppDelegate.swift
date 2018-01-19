//
//  AppDelegate.swift
//  iOS09
//
//  Created by admin on 12.11.17.
//  Copyright © 2017 admin. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth
import FirebaseDatabase

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        FirebaseApp.configure()
        
        UINavigationBar.appearance().setBackgroundImage(UIImage(named: "navigation")!.resizableImage(withCapInsets: UIEdgeInsetsMake(0, 0, 0, 0), resizingMode: .stretch), for: .default)
       // UINavigationBar.appearance().isTranslucent = false
        
        self.window = UIWindow(frame: UIScreen.main.bounds)
        let mainStoryboard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        var vc: UIViewController!
        
        if (Auth.auth().currentUser != nil) {
            vc = mainStoryboard.instantiateViewController(withIdentifier: "tabBarViewController")
        } else {
            vc = mainStoryboard.instantiateViewController(withIdentifier: "Login")
        }
        
        self.window?.rootViewController = vc
        self.window?.makeKeyAndVisible()
        
        return true
    }
    
}
