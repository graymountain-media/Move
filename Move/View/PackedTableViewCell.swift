//
//  PackedTableViewCell.swift
//  Move
//
//  Created by Jake Gray on 5/1/18.
//  Copyright © 2018 Jake Gray. All rights reserved.
//

import UIKit

protocol  PackedTableViewCellDelegate: class{
    func cellOptionsButtonPressed(sender: UITableViewCell)
}

class PackedTableViewCell: UITableViewCell {
    
    weak var delegate: PackedTableViewCellDelegate?

    let iconImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    let nameLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = label.font.withSize(14)
        return label
    }()
    
    let optionsButton: UIButton = {
        let button = UIButton()
        button.setImage(#imageLiteral(resourceName: "moreOptions"), for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.tintColor = .lightGray
        return button
    }()
    
    let separator: UIView = {
        let view = UIView()
        view.layer.borderWidth = 1
        view.layer.borderColor = textFieldColor.cgColor
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    @objc private func optionsButtonPressed() {
        delegate?.cellOptionsButtonPressed(sender: self)
    }
    
    private func setupViews(){
        self.backgroundColor = .white
        
        self.addSubview(iconImageView)
        self.addSubview(nameLabel)
        self.addSubview(optionsButton)
        self.addSubview(separator)
        
        iconImageView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 8).isActive = true
        iconImageView.topAnchor.constraint(equalTo: self.topAnchor, constant: 4).isActive = true
        iconImageView.bottomAnchor.constraint(equalTo: separator.topAnchor, constant: -4).isActive = true
        iconImageView.widthAnchor.constraint(equalTo: iconImageView.heightAnchor).isActive = true
        
        optionsButton.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -8).isActive = true
        optionsButton.topAnchor.constraint(equalTo: self.topAnchor, constant: 4).isActive = true
        optionsButton.bottomAnchor.constraint(equalTo: separator.topAnchor, constant: -4).isActive = true
        optionsButton.widthAnchor.constraint(equalTo: optionsButton.heightAnchor).isActive = true
        
        nameLabel.leadingAnchor.constraint(equalTo: iconImageView.trailingAnchor, constant: 8).isActive = true
        nameLabel.topAnchor.constraint(equalTo: self.topAnchor, constant: 4).isActive = true
        nameLabel.bottomAnchor.constraint(equalTo: separator.topAnchor, constant: -4).isActive = true
        nameLabel.trailingAnchor.constraint(equalTo: optionsButton.leadingAnchor, constant: -4).isActive = true
        
        separator.heightAnchor.constraint(equalToConstant: 1).isActive = true
        separator.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
        separator.leadingAnchor.constraint(equalTo: nameLabel.leadingAnchor).isActive = true
        separator.trailingAnchor.constraint(equalTo: self.trailingAnchor).isActive = true
        
        optionsButton.addTarget(self, action: #selector(optionsButtonPressed), for: .touchUpInside)
    }
    
    func setupCell(name: String, image: UIImage){
        setupViews()
        
        nameLabel.text = name
        iconImageView.image = image
    }
}
