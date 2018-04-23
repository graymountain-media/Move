//
//  HomeViewController.swift
//  Move
//
//  Created by Jake Gray on 4/21/18.
//  Copyright © 2018 Jake Gray. All rights reserved.
//

import UIKit

class HomeViewController: UIViewController {

    let addButton: UIButton = {
        let button = UIButton()
        button.setTitle("+", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = .blue
        button.layer.cornerRadius = 10
        button.clipsToBounds = true
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 38)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(addHome), for: .touchUpInside)
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Home"
        view.backgroundColor = .white
        
        view.addSubview(addButton)
        
        setupButton()
    }
    
    @objc private func addHome() {
//        let addHomeView = AddInputView()
//        present(addHomeView, animated: true, completion: nil)
        
    }
    
    private func setupButton() {
        addButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        addButton.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        addButton.heightAnchor.constraint(equalToConstant: 60).isActive = true
        addButton.widthAnchor.constraint(equalToConstant: 60).isActive = true
    }

}

