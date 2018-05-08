//
//  AppDelegate.swift
//  Move
//
//  Created by Jake Gray on 4/21/18.
//  Copyright © 2018 Jake Gray. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        
        UIApplication.shared.statusBarStyle = .lightContent
        
        window = UIWindow(frame: UIScreen.main.bounds)
        
        let homeViewController = PlaceViewController()
        let navigationController = UINavigationController(rootViewController: homeViewController)

        navigationController.setupBar()
        
        self.window?.rootViewController = navigationController
        self.window?.makeKeyAndVisible()
        self.window?.backgroundColor = offWhite
        
        
        
        return true
    }




}

