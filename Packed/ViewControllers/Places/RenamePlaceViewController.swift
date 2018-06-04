//
//  RenamePlaceViewController.swift
//  Move
//
//  Created by Jake Gray on 5/7/18.
//  Copyright © 2018 Jake Gray. All rights reserved.
//

import UIKit

class RenamePlaceViewController: UIViewController {
    var place: Place?
    
    let nameTextField: UITextField = {
        let textField = UITextField()
        textField.backgroundColor = .white
        textField.placeholder = "123 Hampton Ave"
        textField.layer.cornerRadius = 5
        textField.clipsToBounds = true
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.setIconPadding()
        return textField
    }()
    
    let textInstructionLabel: UILabel = {
        let label = UILabel()
        label.text = "Please rename your place."
        label.font = UIFont.systemFont(ofSize: 12)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .center
        return label
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = offWhite
        self.title = "Rename"
        navigationItem.largeTitleDisplayMode = .never
        
        nameTextField.delegate = self
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.save, target: self, action: #selector(saveButtonPressed))
        navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.cancel, target: self, action: #selector(cancelButtonPressed))
        
        view.addSubview(nameTextField)
        view.addSubview(textInstructionLabel)
        
        setupView()
        nameTextField.becomeFirstResponder()
    }
    
    @objc private func saveButtonPressed(){
        if let address = nameTextField.text, !address.isEmpty, let place = self.place {
            PlaceController.update(place: place, withName: address, isHome: place.isHome)
            nameTextField.resignFirstResponder()
            
            dismiss(animated: true, completion: nil)
        } else {
            let noAddressAlert = UIAlertController(title: "Missing Address", message: "Please input an address for your place.", preferredStyle: .alert)
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
    
    private func setupView(){
        
        nameTextField.heightAnchor.constraint(equalToConstant: 50).isActive = true
        nameTextField.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor).isActive = true
        nameTextField.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor).isActive = true
        nameTextField.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor).isActive = true
        
        textInstructionLabel.topAnchor.constraint(equalTo: nameTextField.bottomAnchor, constant: 4).isActive = true
        textInstructionLabel.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor).isActive = true
        textInstructionLabel.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor).isActive = true
        
        if let place = self.place {
            let imageView = UIImageView.init(frame: CGRect(x: 0, y: 0, width: 55, height: 45))
            imageView.image = place.isHome ? #imageLiteral(resourceName: "HomeIcon") : #imageLiteral(resourceName: "StorageIcon")
            imageView.contentMode = .scaleAspectFit
            nameTextField.leftView = imageView
            nameTextField.text = place.name
        }
    }
}

extension RenamePlaceViewController: UITextFieldDelegate{
    func textFieldDidEndEditing(_ textField: UITextField) {
        nameTextField.resignFirstResponder()
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        saveButtonPressed()
        nameTextField.resignFirstResponder()
        return true
    }

}
