//
//  SVCMethods.swift
//  Move
//
//  Created by Jake Gray on 4/24/18.
//  Copyright © 2018 Jake Gray. All rights reserved.
//

import UIKit

extension SpacesViewController{
    @objc func handleKeyboardShowNotification(notification: NSNotification){
        if let userInfo = notification.userInfo {
            let keyboardFrame = (userInfo[UIKeyboardFrameEndUserInfoKey] as! NSValue).cgRectValue
            inputStackViewBottomConstraint.constant = -keyboardFrame.height + 26
        }
    }
    
    @objc func handleKeyboardHideNotification(notification: NSNotification){
        if let userInfo = notification.userInfo {
            let keyboardFrame = (userInfo[UIKeyboardFrameEndUserInfoKey] as! NSValue).cgRectValue
            inputStackViewBottomConstraint.constant = keyboardFrame.height + 26
        }
    }
    
    @objc func goToSearch(){
        //FIXME: Search
        print("I need to search")
    }
    
    
    // MARK: - Button Actions
    
    @objc func activateAddView() {
//        self.nameTextField.becomeFirstResponder()
        UIView.animate(withDuration: 0.3, animations: {
            self.addView.frame.size.height += 52;
            self.addButton.alpha = 0.0
            self.nameTextField.isHidden = false
            self.submitButton.isHidden = false
        }) { (complete) in
            if complete {
                UIView.animate(withDuration: 0.15, animations: {
                    self.nameTextField.alpha = 1.0
                    self.submitButton.alpha = 1.0
                    
                })
            }
        }
        
    }
    
    @objc func submitAdd(){
        guard let name = nameTextField.text, !name.isEmpty else { return }
        
        SpaceController.createSpace(withName: name)
        nameTextField.text = ""
        
        UIView.animate(withDuration: 0.2, animations: {
            self.nameTextField.alpha = 0.0
            self.submitButton.alpha = 0.0
            self.noEntitiesLabel.alpha = 0.0
        }) { (complete) in
            if complete {
                UIView.animate(withDuration: 0.5, animations: {
                    self.addView.frame.size.height -= 52;
                    self.addButton.alpha = 1.0
                    self.nameTextField.isHidden = true
                    self.submitButton.isHidden = true
                    self.noEntitiesLabel.isHidden = true
                })
            }
        }
        nameTextField.resignFirstResponder()
        mainTableView.isHidden = false
    }
    
    
}

