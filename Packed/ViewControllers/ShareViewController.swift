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
    
    let searchContainerView: UIView = {
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
    
    let userNotFoundLabel: UILabel = {
        let label = UILabel()
        label.text = "No user found for that email"
        label.textColor = .red
        label.adjustsFontSizeToFitWidth = true
        label.isHidden = true
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .center
        return label
    }()
    
    // Add User
    let addContainer: UIView = {
        let view = UIView()
        view.backgroundColor = offWhite
        view.layer.cornerRadius = 5
        view.clipsToBounds = true
        view.layer.borderWidth = 1
        view.isHidden = true
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    let addTopLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 16)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .center
        label.text = "Are you sure want to add this user to your Place?"
        return label
    }()
    
    let usernameLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 16)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .center
        return label
    }()
    
    lazy var addButton: UIButton = {
        let button = UIButton()
        button.setTitle("Add User", for: .normal)
        button.setTitleColor(mainColor, for: .normal)
        button.addTarget(self, action: #selector(addButtonPressed), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    lazy var addCancelButton: UIButton = {
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
        
        view.addSubview(searchContainerView)
        view.addSubview(addContainer)
        
        searchContainerView.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.8).isActive = true
        searchContainerView.heightAnchor.constraint(equalToConstant: 250).isActive = true
        searchContainerView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        searchContainerView.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        
        addContainer.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.8).isActive = true
        addContainer.heightAnchor.constraint(equalToConstant: 250).isActive = true
        addContainer.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        addContainer.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        
        setupSearchSubviews()
        setupAddSubviews()
    }
    
    private func setupSearchSubviews(){
        
        guard let place = place else {return}
        topLabel.text = "Share \(place.name!)"
        
        searchContainerView.addSubview(cancelButton)
        searchContainerView.addSubview(topLabel)
        searchContainerView.addSubview(searchTextField)
        searchContainerView.addSubview(instructionLabel)
        searchContainerView.addSubview(searchButton)
        searchContainerView.addSubview(userNotFoundLabel)
        
        topLabel.bottomAnchor.constraint(equalTo: searchTextField.topAnchor, constant: -24).isActive = true
        topLabel.leadingAnchor.constraint(equalTo: searchContainerView.leadingAnchor).isActive = true
        topLabel.trailingAnchor.constraint(equalTo: searchContainerView.trailingAnchor).isActive = true
        
        searchTextField.centerYAnchor.constraint(equalTo: searchContainerView.centerYAnchor, constant: -32).isActive = true
        searchTextField.leadingAnchor.constraint(equalTo: searchContainerView.leadingAnchor, constant: 16).isActive = true
        searchTextField.trailingAnchor.constraint(equalTo: searchContainerView.trailingAnchor, constant: -16).isActive = true
        searchTextField.heightAnchor.constraint(equalToConstant: 44).isActive = true
        
        userNotFoundLabel.bottomAnchor.constraint(equalTo: searchTextField.topAnchor, constant: -4).isActive = true
        userNotFoundLabel.leadingAnchor.constraint(equalTo: searchContainerView.leadingAnchor, constant: 16).isActive = true
        userNotFoundLabel.trailingAnchor.constraint(equalTo: searchContainerView.trailingAnchor, constant: -16).isActive = true
        
        instructionLabel.topAnchor.constraint(equalTo: searchTextField.bottomAnchor, constant: 4).isActive = true
        instructionLabel.leadingAnchor.constraint(equalTo: searchContainerView.leadingAnchor).isActive = true
        instructionLabel.trailingAnchor.constraint(equalTo: searchContainerView.trailingAnchor).isActive = true
        
        cancelButton.topAnchor.constraint(equalTo: searchButton.bottomAnchor, constant: 4).isActive = true
        cancelButton.leadingAnchor.constraint(equalTo: searchContainerView.leadingAnchor).isActive = true
        cancelButton.trailingAnchor.constraint(equalTo: searchContainerView.trailingAnchor).isActive = true
        cancelButton.heightAnchor.constraint(equalToConstant: 44).isActive = true
        
        searchButton.topAnchor.constraint(equalTo: instructionLabel.bottomAnchor, constant: 16).isActive = true
        searchButton.leadingAnchor.constraint(equalTo: searchContainerView.leadingAnchor).isActive = true
        searchButton.trailingAnchor.constraint(equalTo: searchContainerView.trailingAnchor).isActive = true
        searchButton.heightAnchor.constraint(equalToConstant: 44).isActive = true
    }
    
    private func setupAddSubviews() {
        
        addContainer.addSubview(addTopLabel)
        addContainer.addSubview(usernameLabel)
        addContainer.addSubview(addButton)
        addContainer.addSubview(addCancelButton)
        
        
        usernameLabel.centerYAnchor.constraint(equalTo: addContainer.centerYAnchor, constant: -32).isActive = true
        usernameLabel.leadingAnchor.constraint(equalTo: addContainer.leadingAnchor, constant: 16).isActive = true
        usernameLabel.trailingAnchor.constraint(equalTo: addContainer.trailingAnchor, constant: -16).isActive = true
        
        addTopLabel.bottomAnchor.constraint(equalTo: usernameLabel.topAnchor, constant: -16).isActive = true
        addTopLabel.leadingAnchor.constraint(equalTo: addContainer.leadingAnchor).isActive = true
        addTopLabel.trailingAnchor.constraint(equalTo: addContainer.trailingAnchor).isActive = true
        
        addCancelButton.topAnchor.constraint(equalTo: addButton.bottomAnchor, constant: 4).isActive = true
        addCancelButton.leadingAnchor.constraint(equalTo: addContainer.leadingAnchor).isActive = true
        addCancelButton.trailingAnchor.constraint(equalTo: addContainer.trailingAnchor).isActive = true
        addCancelButton.heightAnchor.constraint(equalToConstant: 44).isActive = true
        
        addButton.topAnchor.constraint(equalTo: usernameLabel.bottomAnchor, constant: 16).isActive = true
        addButton.leadingAnchor.constraint(equalTo: addContainer.leadingAnchor).isActive = true
        addButton.trailingAnchor.constraint(equalTo: addContainer.trailingAnchor).isActive = true
        addButton.heightAnchor.constraint(equalToConstant: 44).isActive = true
        
    }
    
    @objc private func searchButtonPressed(){
        searchTextField.resignFirstResponder()
        
            ref.child("users").observeSingleEvent(of: DataEventType.value) { (snapshot) in
                guard let enteredEmail = self.searchTextField.text?.lowercased(), let place = self.place else {
                    
                    return}
                var userID: String = ""
                let userDict = snapshot.value as? [String:[String:Any]]
                
                for person in userDict! {
                    guard let email = person.value["email"] as? String else {continue}
                    if email == enteredEmail {
                        
                        userID = person.key
                        FirebaseDataManager.share(place: place, toUser: userID)
                        self.dismiss(animated: true, completion: nil)
                        self.delegate?.dismissBlur()
                        return
                    }
                }
                self.userNotFoundLabel.isHidden = false
                
            }
        
        
        
    }
    
    @objc private func addButtonPressed(){
        
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
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        userNotFoundLabel.isHidden = true
    }
}
