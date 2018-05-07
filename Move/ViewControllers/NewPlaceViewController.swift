//
//  NewPlaceViewController.swift
//  Move
//
//  Created by Jake Gray on 5/1/18.
//  Copyright © 2018 Jake Gray. All rights reserved.
//

import UIKit

class NewPlaceViewController: UIViewController {
    
    let nameTextField: UITextField = {
        let textField = UITextField()
        textField.backgroundColor = textFieldColor
        textField.placeholder = "Street Adress"
        textField.layer.cornerRadius = 5
        textField.clipsToBounds = true
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.setPadding()
        return textField
    }()
    
    let placeSegmentedControl: UISegmentedControl = {
        let control = UISegmentedControl()
        control.insertSegment(withTitle: "Home", at: 0, animated: true)
        control.insertSegment(withTitle: "Storage", at: 1, animated: true)
        control.selectedSegmentIndex = 0
        control.tintColor = mainColor
        control.translatesAutoresizingMaskIntoConstraints = false
        return control
    }()
    
    let saveButton: UIBarButtonItem = {
        let button = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.save, target: self, action: #selector(saveButtonPressed))
        return button
    }()
    
    let cancelButton: UIBarButtonItem = {
        let button = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.cancel, target: self, action: #selector(cancelButtonPressed))
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "Places"
        view.backgroundColor = offWhite
        
        navigationItem.rightBarButtonItem = saveButton
        navigationItem.leftBarButtonItem = cancelButton
        
        view.addSubview(placeSegmentedControl)
        view.addSubview(nameTextField)
        
        setupView()
    }
    
    @objc private func saveButtonPressed(){
        if let address = nameTextField.text {
            P
        }
    }
    
    @objc private func cancelButtonPressed(){
        navigationController?.popViewController(animated: true)
    }
    
    private func setupView(){
        placeSegmentedControl.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 32).isActive = true
        placeSegmentedControl.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -32).isActive = true
        placeSegmentedControl.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 32).isActive = true
        placeSegmentedControl.heightAnchor.constraint(equalToConstant: 60).isActive = true

        
        nameTextField.heightAnchor.constraint(equalToConstant: 30).isActive = true
        nameTextField.topAnchor.constraint(equalTo: placeSegmentedControl.bottomAnchor, constant: 40).isActive = true
        nameTextField.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 32).isActive = true
        nameTextField.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -32).isActive = true

    }
}
