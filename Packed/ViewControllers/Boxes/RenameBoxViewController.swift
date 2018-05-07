//
//  RenameBoxViewController.swift
//  Move
//
//  Created by Jake Gray on 5/7/18.
//  Copyright © 2018 Jake Gray. All rights reserved.
//

import UIKit

class RenameBoxViewController: UIViewController {
    
    var box: Box?
    
    let nameTextField: UITextField = {
        let textField = UITextField()
        textField.backgroundColor = .white
        textField.placeholder = "Box Name"
        textField.layer.cornerRadius = 5
        textField.clipsToBounds = true
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.setPadding()
        let imageView = UIImageView.init(frame: CGRect(x: 0, y: 0, width: 55, height: 45))
        imageView.image = #imageLiteral(resourceName: "BoxIcon")
        imageView.contentMode = .scaleAspectFit
        textField.leftView = imageView
        return textField
    }()
    
    let textInstructionLabel: UILabel = {
        let label = UILabel()
        label.text = "Please rename your box."
        label.font = UIFont.systemFont(ofSize: 12)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .center
        return label
    }()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = offWhite
        
        nameTextField.delegate = self
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.save, target: self, action: #selector(saveButtonPressed))
        navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.cancel, target: self, action: #selector(cancelButtonPressed))
        
        view.addSubview(nameTextField)
        view.addSubview(textInstructionLabel)
        
        setupView()
    }
    
    @objc private func saveButtonPressed(){
        guard let box = self.box else {return}
        if let name = nameTextField.text, !name.isEmpty {
            BoxContoller.update(box: box, withName: name)
            navigationController?.popViewController(animated: true)
        } else {
            let noAddressAlert = UIAlertController(title: "Missing Name", message: "Please input an name for your box.", preferredStyle: .alert)
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
        
        nameTextField.heightAnchor.constraint(equalToConstant: 50).isActive = true
        nameTextField.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor).isActive = true
        nameTextField.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor).isActive = true
        nameTextField.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor).isActive = true
        
        textInstructionLabel.topAnchor.constraint(equalTo: nameTextField.bottomAnchor, constant: 4).isActive = true
        textInstructionLabel.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor).isActive = true
        textInstructionLabel.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor).isActive = true
        
        self.title = "Rename"
           
    }
}

extension RenameBoxViewController: UITextFieldDelegate{
    func textFieldDidEndEditing(_ textField: UITextField) {
        nameTextField.resignFirstResponder()
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        saveButtonPressed()
        nameTextField.resignFirstResponder()
        return true
    }
}
