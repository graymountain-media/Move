//
//  SearchTableViewCell.swift
//  Move
//
//  Created by Jake Gray on 4/27/18.
//  Copyright © 2018 Jake Gray. All rights reserved.
//

import UIKit

class SearchTableViewCell: UITableViewCell {
    
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
    
    let breadCrumbLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = label.font.withSize(12)
        return label
    }()
    
    let separator: UIView = {
        let view = UIView()
        view.layer.borderWidth = 1
        view.layer.borderColor = textFieldColor.cgColor
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private func setupViews(){
        self.backgroundColor = .white
        
        let labelStackView = UIStackView(arrangedSubviews: [nameLabel, breadCrumbLabel])
        labelStackView.axis = .vertical
        labelStackView.distribution = .fillProportionally
        labelStackView.translatesAutoresizingMaskIntoConstraints = false
        labelStackView.spacing = 4
        
        self.addSubview(labelStackView)
        self.addSubview(iconImageView)
        self.addSubview(separator)
        
        iconImageView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 8).isActive = true
        iconImageView.topAnchor.constraint(equalTo: self.topAnchor, constant: 4).isActive = true
        iconImageView.bottomAnchor.constraint(equalTo: separator.topAnchor, constant: -4).isActive = true
        iconImageView.widthAnchor.constraint(equalTo: iconImageView.heightAnchor).isActive = true
        
        labelStackView.leadingAnchor.constraint(equalTo: iconImageView.trailingAnchor, constant: 8).isActive = true
        labelStackView.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: 8).isActive = true
        labelStackView.topAnchor.constraint(equalTo: self.topAnchor, constant: 4).isActive = true
        labelStackView.bottomAnchor.constraint(equalTo: separator.topAnchor, constant: -4).isActive = true
        
        separator.heightAnchor.constraint(equalToConstant: 1).isActive = true
        separator.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
        separator.leadingAnchor.constraint(equalTo: iconImageView.leadingAnchor).isActive = true
        separator.trailingAnchor.constraint(equalTo: self.trailingAnchor).isActive = true
    }
    
    func setupCell(box: Box?, item: Item?){
        setupViews()
        
        if let box = box {
            iconImageView.image = #imageLiteral(resourceName: "BoxIcon")
            nameLabel.text = box.name
            
            let room = box.room!
            let place = room.place!
            
            if place.isHome {
                breadCrumbLabel.text = "\(place.name!) > \(room.name!)"
            } else {
                breadCrumbLabel.text = "\(place.name!)"
            }
            
            
        }
        
        if let item = item {
            iconImageView.image = #imageLiteral(resourceName: "ItemIcon")
            nameLabel.text = item.name!
            
            let box = item.box!
            let room = box.room!
            let place = room.place!
            
            if place.isHome {
                breadCrumbLabel.text = "\(place.name!) > \(room.name!) > \(box.name!)"
            } else {
                breadCrumbLabel.text = "\(place.name!) > \(box.name!)"
            }
        }
    }
    
    func setNoResults(icon: UIImage) {
        setupViews()
        nameLabel.text = "No Results"
        breadCrumbLabel.text = ""
        iconImageView.image = icon
    }
   
}
