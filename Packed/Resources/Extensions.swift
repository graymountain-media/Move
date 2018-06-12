//
//  Extensions.swift
//  Move
//
//  Created by Jake Gray on 5/7/18.
//  Copyright © 2018 Jake Gray. All rights reserved.
//

import UIKit

extension UITextField{
    
    func setIconPadding(){
        let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: 50, height: self.frame.height))
        paddingView.contentMode = .scaleAspectFit
        self.leftView = paddingView
        self.leftViewMode = .always
    }
    func setPadding(){
        let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: 10, height: self.frame.height))
        paddingView.contentMode = .scaleAspectFit
        self.leftView = paddingView
        self.leftViewMode = .always
    }
}

extension UINavigationController {
    
    func setupBar() {
        self.navigationBar.isTranslucent = false
        self.navigationBar.barTintColor = mainColor
        self.navigationBar.tintColor = .white
        self.navigationBar.titleTextAttributes = [NSAttributedStringKey.foregroundColor : UIColor.white]
        
        self.navigationBar.backgroundColor = .white
    }
}

