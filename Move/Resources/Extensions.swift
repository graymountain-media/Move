//
//  Extensions.swift
//  Move
//
//  Created by Jake Gray on 5/7/18.
//  Copyright © 2018 Jake Gray. All rights reserved.
//

import UIKit

extension UITextField{
    
    func setPadding(){
        let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: 10, height: self.frame.height))
        self.leftView = paddingView
        self.leftViewMode = .always
    }
}
