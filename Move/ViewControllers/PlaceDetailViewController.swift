//
//  NewPlaceViewController.swift
//  Move
//
//  Created by Jake Gray on 5/1/18.
//  Copyright © 2018 Jake Gray. All rights reserved.
//

import UIKit

class PlaceDetailViewController: UIViewController {
    
    var place: Place?
    
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
    
    override func viewDidLoad() {
        super.viewDidLoad()
    
        view.backgroundColor = offWhite
        
        nameTextField.delegate = self
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.save, target: self, action: #selector(saveButtonPressed))
        navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.cancel, target: self, action: #selector(cancelButtonPressed))
        
        view.addSubview(placeSegmentedControl)
        view.addSubview(nameTextField)
        
        setupView()
    }
    
    @objc private func saveButtonPressed(){
        if let address = nameTextField.text, !address.isEmpty {
            let isHome = placeSegmentedControl.selectedSegmentIndex == 0 ? true : false
            if let place = self.place{
                PlaceController.update(place: place, withName: address, isHome: isHome)
            } else {
                PlaceController.createPlace(withName: address, isHome: isHome)
            }
            navigationController?.popViewController(animated: true)
        } else {
            let noAddressAlert = UIAlertController(title: "Missing Address", message: "Please input an address", preferredStyle: .alert)
            let okayAction = UIAlertAction(title: "Okay", style: .cancel, handler: nil)
            noAddressAlert.addAction(okayAction)
            present(noAddressAlert, animated: true, completion: nil)
            return
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
        
        if let place = self.place {
            nameTextField.text = place.name!
            self.title = "Edit Place"
            placeSegmentedControl.selectedSegmentIndex = place.isHome ? 0 : 1
        } else {
            self.title = "Add New Place"
        }
    }
}

extension PlaceDetailViewController: UITextFieldDelegate{
    func textFieldDidEndEditing(_ textField: UITextField) {
        nameTextField.resignFirstResponder()
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        saveButtonPressed()
        nameTextField.resignFirstResponder()
        return true
    }
}
