//
//  RoomDetailViewController.swift
//  Move
//
//  Created by Jake Gray on 5/7/18.
//  Copyright © 2018 Jake Gray. All rights reserved.
//

import UIKit

class RoomDetailViewController: UIViewController {
    
    var place: Place?
    var room: Room?
    
    let nameTextField: UITextField = {
        let textField = UITextField()
        textField.backgroundColor = .white
        textField.placeholder = "Room Name"
        textField.layer.cornerRadius = 5
        textField.clipsToBounds = true
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.setIconPadding()
        let imageView = UIImageView.init(frame: CGRect(x: 0, y: 0, width: 55, height: 45))
        imageView.image = #imageLiteral(resourceName: "RoomIcon")
        imageView.contentMode = .scaleAspectFit
        textField.leftView = imageView
        return textField
    }()
    
    let textInstructionLabel: UILabel = {
        let label = UILabel()
        label.text = ""
        label.font = UIFont.systemFont(ofSize: 12)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .center
        return label
    }()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = offWhite
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
        
        if let name = nameTextField.text, !name.isEmpty {
            if let room = self.room {
                RoomController.update(room: room, withName: name)
            } else {
                guard let place = place else {return}
                PlaceController.createRoom(withName: name, inPlace: place)
            }
            nameTextField.resignFirstResponder()
            dismiss(animated: true, completion: nil)
        } else {
            let noAddressAlert = UIAlertController(title: "Missing Name", message: "Please input an name for your new room.", preferredStyle: .alert)
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
        
        if let room = self.room {
            nameTextField.text = room.name!
            self.title = "Rename Room"
            textInstructionLabel.text = "Please rename your room."
        } else {
            self.title = "Add New Room"
            textInstructionLabel.text = "Please name your room."
        }
    }
}

extension RoomDetailViewController: UITextFieldDelegate{
    func textFieldDidEndEditing(_ textField: UITextField) {
        nameTextField.resignFirstResponder()
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        saveButtonPressed()
        nameTextField.resignFirstResponder()
        return true
    }
}
