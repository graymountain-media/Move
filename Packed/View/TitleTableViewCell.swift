//
//  TitleTableViewCell.swift
//  Move
//
//  Created by Jake Gray on 4/23/18.
//  Copyright © 2018 Jake Gray. All rights reserved.
//

import UIKit

@objc protocol TitleTableViewCellDelegate: class {
    func deleteButtonPressed(_ sender: TitleTableViewCell)
}

class TitleTableViewCell: UITableViewCell {
    
    weak var delegate: TitleTableViewCellDelegate?
    
    let containerView: UIView = {
        let view = UIView()
        view.backgroundColor = mainColor
        view.layer.cornerRadius = 5
        view.clipsToBounds = true
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    let iconImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFill
        return imageView
    }()
    
    let nameLabel: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.text = ""
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.boldSystemFont(ofSize: 24)
        return label
    }()
    
    var deleteButton: UIButton!
    
    func setupDeleteButton() {
        let button = UIButton(type: .system)
        button.setImage(#imageLiteral(resourceName: "XIcon"), for: .normal)
        button.contentMode = UIViewContentMode.scaleAspectFill
        button.translatesAutoresizingMaskIntoConstraints = false
        button.tintColor = .white
        button.addTarget(self, action: #selector(deleteButtonPressed), for: .touchUpInside)
        self.deleteButton = button
    }
    
    private func setupViews(){
        
        setupDeleteButton()
        
        self.addSubview(containerView)
        containerView.addSubview(iconImageView)
        containerView.addSubview(nameLabel)
        containerView.addSubview(deleteButton)
        
        iconImageView.topAnchor.constraint(equalTo: self.topAnchor, constant: 8).isActive = true
        iconImageView.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -8).isActive = true
        iconImageView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 12).isActive = true
        iconImageView.widthAnchor.constraint(equalToConstant: 45).isActive = true
        
        containerView.topAnchor.constraint(equalTo: self.topAnchor, constant: 4).isActive = true
        containerView.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -4).isActive = true
        containerView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 8).isActive = true
        containerView.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -8).isActive = true
        
        nameLabel.centerYAnchor.constraint(equalTo: containerView.centerYAnchor).isActive = true
        nameLabel.leadingAnchor.constraint(equalTo: iconImageView.trailingAnchor, constant: 8).isActive = true
        nameLabel.trailingAnchor.constraint(equalTo: deleteButton.leadingAnchor, constant: -8).isActive = true

        
        deleteButton.centerYAnchor.constraint(equalTo: containerView.centerYAnchor).isActive = true
        deleteButton.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -8).isActive = true
        deleteButton.widthAnchor.constraint(equalToConstant: 38).isActive = true
        deleteButton.heightAnchor.constraint(equalToConstant: 38).isActive = true

    }
    
    @objc func deleteButtonPressed(){
        delegate?.deleteButtonPressed(self)
    }
    
    func update(withTitle title: String, image: UIImage){
        setupViews()
        nameLabel.text = title
        iconImageView.image = image
    }
    

}
