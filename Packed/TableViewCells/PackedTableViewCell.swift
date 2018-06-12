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
        button.contentMode = .scaleAspectFit
        button.translatesAutoresizingMaskIntoConstraints = false
        button.tintColor = .lightGray
        return button
    }()
    let fragileIconImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = #imageLiteral(resourceName: "FragileIcon")
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.isHidden = true
        return imageView
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
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        setupViews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupViews(){
        self.backgroundColor = .white
        
        self.addSubview(iconImageView)
        self.addSubview(nameLabel)
        self.addSubview(optionsButton)
        self.addSubview(fragileIconImageView)
        self.addSubview(separator)
        
        iconImageView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 8).isActive = true
        iconImageView.topAnchor.constraint(equalTo: self.topAnchor, constant: 4).isActive = true
        iconImageView.bottomAnchor.constraint(equalTo: separator.topAnchor, constant: -4).isActive = true
        iconImageView.widthAnchor.constraint(equalTo: iconImageView.heightAnchor).isActive = true
        
        optionsButton.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -8).isActive = true
        optionsButton.topAnchor.constraint(equalTo: self.topAnchor, constant: 4).isActive = true
        optionsButton.bottomAnchor.constraint(equalTo: separator.topAnchor, constant: -4).isActive = true
        optionsButton.widthAnchor.constraint(equalTo: optionsButton.heightAnchor).isActive = true
        
        fragileIconImageView.trailingAnchor.constraint(equalTo: optionsButton.leadingAnchor, constant: 4).isActive = true
        fragileIconImageView.topAnchor.constraint(equalTo: self.topAnchor, constant: 4).isActive = true
        fragileIconImageView.bottomAnchor.constraint(equalTo: separator.topAnchor, constant: -4).isActive = true
        fragileIconImageView.widthAnchor.constraint(equalTo: iconImageView.heightAnchor).isActive = true
        
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
    
    func updateCellWith(name: String, image: UIImage, isFragile: Bool){
        
        
        nameLabel.text = name
        iconImageView.image = image
        if isFragile {
            fragileIconImageView.isHidden = false
        } else {
            fragileIconImageView.isHidden = true
        }
    }
}
