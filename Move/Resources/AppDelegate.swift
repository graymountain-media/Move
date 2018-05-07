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
        
        let homeViewController = MainViewController()
        let navigationController = UINavigationController(rootViewController: homeViewController)

        navigationController.navigationBar.isTranslucent = false
        navigationController.navigationBar.barTintColor = mainColor
        navigationController.navigationBar.tintColor = .white
        navigationController.navigationBar.titleTextAttributes = [NSAttributedStringKey.foregroundColor : UIColor.white]
        
        navigationController.navigationBar.backgroundColor = .white
        
        self.window?.rootViewController = navigationController
        self.window?.makeKeyAndVisible()
        
        
        
        return true
    }




}

