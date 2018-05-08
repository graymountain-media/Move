//
//  ItemDetailViewController.swift
//  Move
//
//  Created by Jake Gray on 5/7/18.
//  Copyright © 2018 Jake Gray. All rights reserved.
//
import UIKit

class ItemDetailViewController: UIViewController {
    
    var box: Box?
    var item: Item?
    
    let nameTextField: UITextField = {
        let textField = UITextField()
        textField.backgroundColor = .white
        textField.placeholder = "Item Name"
        textField.layer.cornerRadius = 5
        textField.clipsToBounds = true
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.setPadding()
        let imageView = UIImageView.init(frame: CGRect(x: 0, y: 0, width: 55, height: 45))
        imageView.image = #imageLiteral(resourceName: "ItemIcon")
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
            if let item = self.item {
                BoxController.update(item: item, withName: name)
                navigationController?.popViewController(animated: true)
            } else {
                guard let box = box else {return}
                BoxController.createItem(withName: name, inBox: box)
                navigationController?.popViewController(animated: true)
            }
        } else {
            let noAddressAlert = UIAlertController(title: "Missing Name", message: "Please input an name for your new item.", preferredStyle: .alert)
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
        
        if let item = self.item {
            nameTextField.text = item.name!
            self.title = "Rename Item"
            textInstructionLabel.text = "Please rename your item."
        } else {
            self.title = "Add New Item"
            textInstructionLabel.text = "Please name your item."
        }
    }
}

extension ItemDetailViewController: UITextFieldDelegate{
    func textFieldDidEndEditing(_ textField: UITextField) {
        nameTextField.resignFirstResponder()
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        saveButtonPressed()
        nameTextField.resignFirstResponder()
        return true
    }
}

