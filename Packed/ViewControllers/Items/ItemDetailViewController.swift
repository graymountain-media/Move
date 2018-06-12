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
        textField.setIconPadding()
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
    
    let boxNameLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = label.font.withSize(18)
        return label
    }()
    
    let fragileLabel: UILabel = {
        let label = UILabel()
        label.text = "Fragile"
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = label.font.withSize(18)
        label.textAlignment = .left
        return label
    }()
    
    let fragileSwitch: UISwitch = {
        let mySwitch = UISwitch()
        mySwitch.isOn = false
        mySwitch.tintColor = mainColor
        mySwitch.onTintColor = mainColor
        mySwitch.translatesAutoresizingMaskIntoConstraints = false
        return mySwitch
    }()
    
    let separator: UIView = {
        let view = UIView()
        view.layer.borderWidth = 1
        view.layer.borderColor = textFieldColor.cgColor
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    let optionsTableView: UITableView = {
        let tableView = UITableView(frame: CGRect.zero, style: .grouped)
        tableView.rowHeight = 50
        tableView.backgroundColor = offWhite
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.isScrollEnabled = false
        tableView.allowsSelection = false
        return tableView
    }()
    let boxInfoCell: UITableViewCell = {
        let cell = UITableViewCell()
        cell.backgroundColor = .white
        cell.frame.size.height = 50
        return cell
    }()
    
    let fragileOptionCell: UITableViewCell = {
        let cell = UITableViewCell()
        cell.backgroundColor = .white
        cell.frame.size.height = 50
        return cell
    }()
    
    let deleteButton: UIButton = {
        let button = UIButton(type: UIButtonType.roundedRect)
        button.backgroundColor = .red
        button.setTitle("Delete This Item", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.layer.cornerRadius = 5
        button.clipsToBounds = true
        return button
    }()
    
    let fragileIconView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.image = #imageLiteral(resourceName: "FragileIcon")
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    let boxIconView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.image = #imageLiteral(resourceName: "BoxIcon")
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    // MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = offWhite
//        navigationItem.largeTitleDisplayMode = .never
        
        nameTextField.delegate = self
        optionsTableView.delegate = self
        optionsTableView.dataSource = self
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.save, target: self, action: #selector(saveButtonPressed))
        
        
        setupView()
    }
    
    // MARK: - Button Actions
    
    @objc private func saveButtonPressed(){
        
        if let name = nameTextField.text, !name.isEmpty {
            if let item = self.item {
                BoxController.update(item: item, withName: name, isFragile: fragileSwitch.isOn)
                nameTextField.resignFirstResponder()
                navigationController?.popViewController(animated: true)
            } else {
                guard let box = box else {return}
                BoxController.createItem(withName: name, inBox: box, isFragile: fragileSwitch.isOn)
                nameTextField.resignFirstResponder()
                dismiss(animated: true, completion: nil)
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
        nameTextField.resignFirstResponder()
        dismiss(animated: true, completion: nil)
    }
    
    @objc private func deleteButtonPressed(){
        let alert = UIAlertController(title: "Are you sure?", message: nil, preferredStyle: .alert)
        
        let deleteAction = UIAlertAction(title: "Delete", style: .destructive) { (_) in
            BoxController.delete(item: self.item!)
            self.navigationController?.popViewController(animated: true)
        }
        alert.addAction(deleteAction)
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        alert.addAction(cancelAction)
        
        present(alert, animated: true, completion: nil)
    }
    
    // MARK: - View Setup
    
    private func setupView(){
        
        view.addSubview(nameTextField)
        view.addSubview(textInstructionLabel)
        view.addSubview(optionsTableView)
        view.addSubview(deleteButton)
        
        nameTextField.heightAnchor.constraint(equalToConstant: 50).isActive = true
        nameTextField.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor).isActive = true
        nameTextField.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor).isActive = true
        nameTextField.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor).isActive = true
        
        textInstructionLabel.topAnchor.constraint(equalTo: nameTextField.bottomAnchor, constant: 4).isActive = true
        textInstructionLabel.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor).isActive = true
        textInstructionLabel.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor).isActive = true
        
        
        optionsTableView.topAnchor.constraint(equalTo: textInstructionLabel.bottomAnchor, constant: 16).isActive = true
        optionsTableView.bottomAnchor.constraint(equalTo: deleteButton.topAnchor, constant: -8).isActive = true
        optionsTableView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor).isActive = true
        optionsTableView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor).isActive = true
        
        deleteButton.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16).isActive = true
        deleteButton.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -16).isActive = true
        deleteButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -16).isActive = true
        deleteButton.heightAnchor.constraint(equalToConstant: 44).isActive = true
        deleteButton.addTarget(self, action: #selector(deleteButtonPressed), for: .touchUpInside)

        
        setupCells()

        
        if let item = self.item {
            nameTextField.text = item.name!
            fragileSwitch.isOn = item.isFragile
            self.title = "Item Details"
            deleteButton.isHidden = false
        } else {
            self.title = "Add New Item"
            deleteButton.isHidden = true
            nameTextField.becomeFirstResponder()
            navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.cancel, target: self, action: #selector(cancelButtonPressed))
        }
        textInstructionLabel.text = "Please name your item."
        boxNameLabel.text = box?.name
    }
    
    func setupCells() {
        boxInfoCell.addSubview(boxNameLabel)
        boxInfoCell.addSubview(boxIconView)
        
        boxIconView.leadingAnchor.constraint(equalTo: boxInfoCell.leadingAnchor, constant: 8).isActive = true
        boxIconView.topAnchor.constraint(equalTo: boxInfoCell.topAnchor, constant: 4).isActive = true
        boxIconView.bottomAnchor.constraint(equalTo: boxInfoCell.bottomAnchor, constant: -4).isActive = true
        boxIconView.widthAnchor.constraint(equalTo: boxIconView.heightAnchor).isActive = true
        
        boxNameLabel.centerYAnchor.constraint(equalTo: boxInfoCell.centerYAnchor).isActive = true
        boxNameLabel.leadingAnchor.constraint(equalTo: boxIconView.trailingAnchor, constant: 8).isActive = true
        boxNameLabel.trailingAnchor.constraint(equalTo: boxInfoCell.trailingAnchor, constant: -8).isActive = true
        
        fragileOptionCell.addSubview(fragileLabel)
        fragileOptionCell.addSubview(fragileSwitch)
        fragileOptionCell.addSubview(fragileIconView)
        
        fragileIconView.leadingAnchor.constraint(equalTo: fragileOptionCell.leadingAnchor, constant: 8).isActive = true
        fragileIconView.topAnchor.constraint(equalTo: fragileOptionCell.topAnchor, constant: 4).isActive = true
        fragileIconView.bottomAnchor.constraint(equalTo: fragileOptionCell.bottomAnchor, constant: -4).isActive = true
        fragileIconView.widthAnchor.constraint(equalTo: fragileOptionCell.heightAnchor).isActive = true
        
        fragileLabel.centerYAnchor.constraint(equalTo: fragileOptionCell.centerYAnchor).isActive = true
        fragileLabel.leadingAnchor.constraint(equalTo: fragileIconView.trailingAnchor, constant: 8).isActive = true
        fragileLabel.trailingAnchor.constraint(equalTo: fragileSwitch.leadingAnchor).isActive = true
        
        fragileSwitch.centerYAnchor.constraint(equalTo: fragileOptionCell.centerYAnchor).isActive = true
        fragileSwitch.trailingAnchor.constraint(equalTo: fragileOptionCell.trailingAnchor, constant: -8).isActive = true

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

extension ItemDetailViewController: UITableViewDataSource, UITableViewDelegate {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        switch section {
        case 0:
            return "In Box"
        case 1:
            return "Options"
        default:
            fatalError("That section does not exist")
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0:
            return 1
        case 1:
            return 1
        default:
            fatalError("That section does not exist")
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch (indexPath.section){
            case 0:
                return self.boxInfoCell
            default:
                return self.fragileOptionCell
        }
    }
    
    
}

