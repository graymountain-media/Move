//
//  ShareViewController.swift
//  Packed
//
//  Created by Jake Gray on 6/6/18.
//  Copyright © 2018 Jake Gray. All rights reserved.
//

import UIKit
import Firebase
import FirebaseDatabase
import FirebaseAuth

protocol BlurBackgroundDelegate: class {
    func dismissBlur()
}

class ShareViewController: UIViewController {
    
    weak var delegate: BlurBackgroundDelegate?
    var place: Place?
    
    let topLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 16)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .center
        return label
    }()
    
    let instructionLabel: UILabel = {
        let label = UILabel()
        label.text = "Enter the user's email address"
        label.font = UIFont.systemFont(ofSize: 12)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .center
        return label
    }()
    
    let searchTextField: UITextField = {
        let textField = UITextField()
        textField.setPadding()
        textField.placeholder = "john@example.com"
        textField.layer.cornerRadius = 5
        textField.layer.borderColor = UIColor.lightGray.cgColor
        textField.layer.borderWidth = 0.5
        textField.clipsToBounds = true
        textField.translatesAutoresizingMaskIntoConstraints = false
        return textField
    }()
    
    let containerView: UIView = {
        let view = UIView()
        view.backgroundColor = offWhite
        view.layer.cornerRadius = 5
        view.clipsToBounds = true
        view.layer.borderWidth = 1
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    lazy var searchButton: UIButton = {
        let button = UIButton()
        button.setTitle("Search", for: .normal)
        button.setTitleColor(mainColor, for: .normal)
        button.addTarget(self, action: #selector(searchButtonPressed), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    lazy var cancelButton: UIButton = {
        let button = UIButton()
        button.setTitle("Cancel", for: .normal)
        button.setTitleColor(.red, for: .normal)
        button.addTarget(self, action: #selector(cancelButtonPressed), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    // MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        searchTextField.delegate = self
        setupView()
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
       
    }
    
    private func setupView() {
        
        view.addSubview(containerView)
        
        containerView.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.8).isActive = true
        containerView.heightAnchor.constraint(equalToConstant: 250).isActive = true
        containerView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        containerView.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        
        setupSubviews()
    }
    
    private func setupSubviews(){
        
        guard let place = place else {return}
        topLabel.text = "Share \(place.name!)"
        
        containerView.addSubview(cancelButton)
        containerView.addSubview(topLabel)
        containerView.addSubview(searchTextField)
        containerView.addSubview(instructionLabel)
        containerView.addSubview(searchButton)
        
        topLabel.bottomAnchor.constraint(equalTo: searchTextField.topAnchor, constant: -8).isActive = true
        topLabel.leadingAnchor.constraint(equalTo: containerView.leadingAnchor).isActive = true
        topLabel.trailingAnchor.constraint(equalTo: containerView.trailingAnchor).isActive = true
        
        searchTextField.centerYAnchor.constraint(equalTo: containerView.centerYAnchor, constant: -32).isActive = true
        searchTextField.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 16).isActive = true
        searchTextField.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -16).isActive = true
        searchTextField.heightAnchor.constraint(equalToConstant: 44).isActive = true
        
        instructionLabel.topAnchor.constraint(equalTo: searchTextField.bottomAnchor, constant: 4).isActive = true
        instructionLabel.leadingAnchor.constraint(equalTo: containerView.leadingAnchor).isActive = true
        instructionLabel.trailingAnchor.constraint(equalTo: containerView.trailingAnchor).isActive = true
        
        cancelButton.topAnchor.constraint(equalTo: searchButton.bottomAnchor, constant: 4).isActive = true
        cancelButton.leadingAnchor.constraint(equalTo: containerView.leadingAnchor).isActive = true
        cancelButton.trailingAnchor.constraint(equalTo: containerView.trailingAnchor).isActive = true
        cancelButton.heightAnchor.constraint(equalToConstant: 44).isActive = true
        
        searchButton.topAnchor.constraint(equalTo: instructionLabel.bottomAnchor, constant: 16).isActive = true
        searchButton.leadingAnchor.constraint(equalTo: containerView.leadingAnchor).isActive = true
        searchButton.trailingAnchor.constraint(equalTo: containerView.trailingAnchor).isActive = true
        searchButton.heightAnchor.constraint(equalToConstant: 44).isActive = true
    }
    
    @objc private func searchButtonPressed(){
        print("Hello")
        ref.child("users").observeSingleEvent(of: DataEventType.value) { (snapshot) in
            guard let enteredEmail = self.searchTextField.text, let place = self.place else {
                print("Cant get email")
                return}
            var userID: String = ""
            let userDict = snapshot.value as? [String:[String:Any]]
//            var emails: [String] = []
            for person in userDict! {
                guard let email = person.value["email"] as? String else {continue}
                if email == enteredEmail {
                    print("hello again")
                    userID = person.key
                    FirebaseDataManager.share(place: place, toUser: userID)
                    self.dismiss(animated: true, completion: nil)
                    self.delegate?.dismissBlur()
                    return
                }
            }
            
        }
//        FirebaseDataManager.share(place: place)
    }
    
    @objc private func cancelButtonPressed(){
        dismiss(animated: true, completion: nil)
        delegate?.dismissBlur()
    }
}

extension ShareViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        searchButtonPressed()
        view.endEditing(true)
        return true
    }
}
