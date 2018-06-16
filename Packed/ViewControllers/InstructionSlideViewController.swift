//
//  InstructionSlideViewController.swift
//  Packed.
//
//  Created by Jake Gray on 6/16/18.
//  Copyright © 2018 Jake Gray. All rights reserved.
//

import UIKit

class InstructionSlideViewController: UIViewController {
    
    var card: UIImage?
    var viewedOnboarding: Bool = false
    
    let cardImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .clear
        view.addSubview(cardImageView)
        
        let viewedOnboarding = UserDefaults.standard.bool(forKey: "viewedOnboarding")
        
        guard let card = card else {return}
        cardImageView.image = card
        
        cardImageView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 8).isActive = true
        cardImageView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor).isActive = true
        cardImageView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor).isActive = true
        
        if viewedOnboarding {
            cardImageView.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.7).isActive = true
        } else {
            cardImageView.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.6).isActive = true
        }
        
    }

}
