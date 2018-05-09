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
        textField.backgroundColor = .white
        textField.placeholder = "123 Hampton Ave"
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.setPadding()
        let imageView = UIImageView.init(frame: CGRect(x: 0, y: 0, width: 55, height: 45))
        imageView.image = #imageLiteral(resourceName: "HomeIcon")
        imageView.contentMode = .scaleAspectFit
        textField.leftView = imageView
        return textField
    }()
    
    let placeSegmentedControl: UISegmentedControl = {
        let control = UISegmentedControl()
        control.insertSegment(withTitle: "Home", at: 0, animated: true)
        control.insertSegment(withTitle: "Storage Unit", at: 1, animated: true)
        control.selectedSegmentIndex = 0
        control.tintColor = mainColor
        control.backgroundColor = .white
        control.translatesAutoresizingMaskIntoConstraints = false
        return control
    }()
    
    let textInstructionLabel: UILabel = {
        let label = UILabel()
        label.text = "Please name your new place."
        label.font = UIFont.systemFont(ofSize: 12)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .center
        return label
    }()
    
    let controlInstructionLabel: UILabel = {
        let label = UILabel()
        label.text = "Please set your place type."
        label.font = UIFont.systemFont(ofSize: 12)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .center
        return label
    }()
   
    
    override func viewDidLoad() {
        super.viewDidLoad()
    
        view.backgroundColor = offWhite
        self.title = "Add New Place"
        navigationItem.largeTitleDisplayMode = .never
        
        nameTextField.delegate = self
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.save, target: self, action: #selector(saveButtonPressed))
        navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.cancel, target: self, action: #selector(cancelButtonPressed))
        
        setupView()
        nameTextField.becomeFirstResponder()
    }
    
    @objc private func saveButtonPressed(){
        if let address = nameTextField.text, !address.isEmpty {
            let isHome = placeSegmentedControl.selectedSegmentIndex == 0 ? true : false
            PlaceController.createPlace(withName: address, isHome: isHome)
            nameTextField.resignFirstResponder()
            dismiss(animated: true, completion: nil)
        } else {
            let noAddressAlert = UIAlertController(title: "Missing Address", message: "Please input an address for your new place.", preferredStyle: .alert)
            let okayAction = UIAlertAction(title: "Okay", style: .cancel, handler: nil)
            noAddressAlert.addAction(okayAction)
            present(noAddressAlert, animated: true, completion: nil)
            return
        }
    }
    
    @objc private func cancelButtonPressed(){
        nameTextField.resignFirstResponder()
        dismiss(animated: true, completion: nil)
    }
    
    @objc private func controlChanged(){
        let icon = placeSegmentedControl.selectedSegmentIndex == 0 ? #imageLiteral(resourceName: "HomeIcon") : #imageLiteral(resourceName: "StorageIcon")
        
        let imageView = UIImageView.init(frame: CGRect(x: 0, y: 0, width: 55, height: 45))
        imageView.image = icon
        imageView.contentMode = .scaleAspectFit
        
        nameTextField.leftView = imageView
        
    }
    
    private func setupView(){
        
        view.addSubview(placeSegmentedControl)
        placeSegmentedControl.addTarget(self, action: #selector(controlChanged), for: UIControlEvents.valueChanged)
        view.addSubview(controlInstructionLabel)
        
        view.addSubview(nameTextField)
        view.addSubview(textInstructionLabel)
        
        placeSegmentedControl.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 32).isActive = true
        placeSegmentedControl.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -32).isActive = true
        placeSegmentedControl.topAnchor.constraint(equalTo: textInstructionLabel.bottomAnchor, constant: 40).isActive = true
        placeSegmentedControl.heightAnchor.constraint(equalToConstant: 60).isActive = true
        
        controlInstructionLabel.topAnchor.constraint(equalTo: placeSegmentedControl.bottomAnchor, constant: 4).isActive = true
        controlInstructionLabel.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor).isActive = true
        controlInstructionLabel.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor).isActive = true
        
        nameTextField.heightAnchor.constraint(equalToConstant: 50).isActive = true
        nameTextField.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor).isActive = true
        nameTextField.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor).isActive = true
        nameTextField.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor).isActive = true
        
        textInstructionLabel.topAnchor.constraint(equalTo: nameTextField.bottomAnchor, constant: 4).isActive = true
        textInstructionLabel.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor).isActive = true
        textInstructionLabel.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor).isActive = true
    }
}

extension NewPlaceViewController: UITextFieldDelegate{
    func textFieldDidEndEditing(_ textField: UITextField) {
        nameTextField.resignFirstResponder()
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        saveButtonPressed()
        nameTextField.resignFirstResponder()
        return true
    }
}
