//
//  SpacesViewController.swift
//  Move
//
//  Created by Jake Gray on 4/21/18.
//  Copyright © 2018 Jake Gray. All rights reserved.
//

import UIKit

class SpacesViewController: UIViewController{
    
    // MARK: - Properties
    
    let cellIdentifier = "RoomCell"
    var inputStackViewBottomConstraint: NSLayoutConstraint = NSLayoutConstraint()
    // Body
    
    let mainTableView: UITableView = {
        let tableView = UITableView()
        tableView.layer.borderWidth = 0
        tableView.separatorStyle = .none
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.rowHeight = 60
        return tableView
    }()
    
    let noEntitiesLabel: UILabel = {
        let label = UILabel()
        label.text = "You do not have any spaces or homes set up."
        label.font = UIFont.boldSystemFont(ofSize: 24)
        label.isHidden = true
        label.textAlignment = .center
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    // Footer
    
    let addButton: UIButton = {
        let button = UIButton()
        button.setTitle("Add New Space or Home", for: .normal)
        button.setTitleColor(mainColor, for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(activateAddView), for: .touchUpInside)
        return button
    }()
    
    let submitButton: UIButton = {
        let button = UIButton()
        button.setTitle("Add", for: .normal)
        button.setTitleColor(mainColor, for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(submitAdd), for: .touchUpInside)
        button.isHidden = true
        button.alpha = 0.0
        return button
    }()
    
    let nameTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "Enter name..."
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.isHidden = true
        textField.alpha = 0.0
        textField.backgroundColor = .white
        textField.textColor = mainColor
        textField.layer.cornerRadius = 10
        textField.clipsToBounds = true
        return textField
    }()
    
    let searchBar : UISearchBar = {
        let searchBar = UISearchBar()
        searchBar.placeholder = "Search for item or box name..."
        searchBar.translatesAutoresizingMaskIntoConstraints = false
        searchBar.barTintColor = mainColor
        searchBar.layer.borderWidth = 0
        searchBar.backgroundImage = UIImage()
        return searchBar
    }()
    
    let addView: UIView = {
        let view = UIView()
        view.backgroundColor = secondaryColor
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    
    var rightButton: UIBarButtonItem = {
        let navButton = UIBarButtonItem(barButtonSystemItem: .search, target: self, action: #selector(goToSearch))
        navButton.tintColor = mainColor
        return navButton
    }()
    
    
    // MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Spaces"
        view.backgroundColor = mainColor
        self.navigationItem.rightBarButtonItem = rightButton
        
        mainTableView.register(TitleTableViewCell.self, forCellReuseIdentifier: cellIdentifier)
        mainTableView.delegate = self
        mainTableView.dataSource = self
        
        nameTextField.delegate = self
        
        view.addSubview(mainTableView)
        view.addSubview(noEntitiesLabel)
        
        view.addSubview(addView)
        view.addSubview(searchBar)
        
        setupFooter()
        setupBody()
        
        NotificationCenter.default.addObserver(self, selector: #selector(handleKeyboardShowNotification), name: .UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(handleKeyboardHideNotification), name: .UIKeyboardWillHide, object: nil)
    }
    
    @objc func handleKeyboardShowNotification(notification: NSNotification){
        if let userInfo = notification.userInfo {
            let keyboardFrame = (userInfo[UIKeyboardFrameEndUserInfoKey] as! NSValue).cgRectValue
            inputStackViewBottomConstraint.constant = -keyboardFrame.height + 84
        }
    }
    
    @objc func handleKeyboardHideNotification(notification: NSNotification){
        if let userInfo = notification.userInfo {
            let keyboardFrame = (userInfo[UIKeyboardFrameEndUserInfoKey] as! NSValue).cgRectValue
            inputStackViewBottomConstraint.constant = keyboardFrame.height + 84
        }
    }
    
    @objc private func goToSearch(){
        //FIXME: Search
        print("I need to search")
    }
    
    @objc func showEditing(sender: UIBarButtonItem)
    {
        if(self.mainTableView.isEditing == true)
        {
            self.mainTableView.isEditing = false
            self.navigationItem.rightBarButtonItem?.title = "Done"
        }
        else
        {
            self.mainTableView.isEditing = true
            self.navigationItem.rightBarButtonItem?.title = "Edit"
        }
    }
    
    
    // MARK: - Button Actions
    
    @objc private func activateAddView() {
        print("add button pressed")
        UIView.animate(withDuration: 0.3, animations: {
            self.addView.frame.size.height += 52;
            self.addButton.alpha = 0.0
            self.nameTextField.isHidden = false
            self.submitButton.isHidden = false
        }) { (complete) in
            if complete {
                UIView.animate(withDuration: 0.15, animations: {
                    self.nameTextField.alpha = 1.0
                    self.submitButton.alpha = 1.0
                    self.nameTextField.becomeFirstResponder()
                })
            }
        }
        
    }
    
    @objc private func submitAdd(){
        guard let name = nameTextField.text, !name.isEmpty else { return }
            
        SpaceController.shared.createSpace(withName: name)
        nameTextField.text = ""
        
        UIView.animate(withDuration: 0.2, animations: {
            self.nameTextField.alpha = 0.0
            self.submitButton.alpha = 0.0
            self.noEntitiesLabel.alpha = 0.0
        }) { (complete) in
            if complete {
                UIView.animate(withDuration: 0.5, animations: {
                    self.addView.frame.size.height -= 52;
                    self.addButton.alpha = 1.0
                    self.nameTextField.isHidden = true
                    self.submitButton.isHidden = true
                    self.noEntitiesLabel.isHidden = true
                })
            }
        }
        nameTextField.resignFirstResponder()
        mainTableView.isHidden = false
        mainTableView.insertRows(at: [IndexPath(item: 0, section: 0)], with: .automatic)
    }
    
    private func setupFooter() {
        
        searchBar.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor).isActive = true
        searchBar.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor).isActive = true
        searchBar.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor).isActive = true
        
        setupAddView()
    }
    
    private func setupAddView(){
        addView.bottomAnchor.constraint(equalTo: searchBar.topAnchor).isActive = true
        addView.frame.size.height = 44;
        addView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor).isActive = true
        addView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor).isActive = true
        
        addView.addSubview(addButton)
        
        addButton.bottomAnchor.constraint(equalTo: addView.bottomAnchor).isActive = true
        addButton.topAnchor.constraint(equalTo: addView.topAnchor).isActive = true
        addButton.leadingAnchor.constraint(equalTo: addView.leadingAnchor).isActive = true
        addButton.trailingAnchor.constraint(equalTo: addView.trailingAnchor).isActive = true
        
        let inputStackView = UIStackView(arrangedSubviews: [nameTextField, submitButton])
        inputStackView.distribution = .fillEqually
        inputStackView.axis = .vertical
        inputStackView.spacing = 4
        inputStackView.backgroundColor = mainColor
        inputStackView.translatesAutoresizingMaskIntoConstraints = false
        
        addView.addSubview(inputStackView)
        
        inputStackView.topAnchor.constraint(equalTo: addView.topAnchor, constant: 8).isActive = true
        inputStackViewBottomConstraint = inputStackView.bottomAnchor.constraint(equalTo: addView.bottomAnchor, constant: -8)
        inputStackViewBottomConstraint.isActive = true
        inputStackView.leadingAnchor.constraint(equalTo: addButton.leadingAnchor, constant: 16).isActive = true
        inputStackView.trailingAnchor.constraint(equalTo: addButton.trailingAnchor, constant: -16).isActive = true
        
        addView.bringSubview(toFront: addButton)
        
    }
    
    private func setupBody(){
        if SpaceController.shared.spaces.count == 0 {
            noEntitiesLabel.isHidden = false
        } else {
            noEntitiesLabel.isHidden = true
        }
        
        mainTableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor).isActive = true
        mainTableView.bottomAnchor.constraint(equalTo: addView.topAnchor).isActive = true
        mainTableView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor).isActive = true
        mainTableView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor).isActive = true
        
        noEntitiesLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        noEntitiesLabel.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: -50).isActive = true
        noEntitiesLabel.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor).isActive = true
        noEntitiesLabel.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor).isActive = true
        
//        view.bringSubview(toFront: noEntitiesLabel)
    }
}

    // MARK: - TableView Data Source

extension SpacesViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return SpaceController.shared.spaces.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = mainTableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as? TitleTableViewCell else {
            print("Cell failed")
            return UITableViewCell()}
        
        let room = SpaceController.shared.spaces[indexPath.row]
        cell.update(withTitle: room.name)
        
        let bgView = UIView()
        bgView.backgroundColor = secondaryColor
        cell.selectedBackgroundView = bgView
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete{
            let space = SpaceController.shared.spaces[indexPath.row]
            SpaceController.shared.delete(space: space)
            
            mainTableView.deleteRows(at: [indexPath], with: .fade)
        }
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    override func setEditing(_ editing: Bool, animated: Bool) {
        
        super.setEditing(editing, animated: animated)
        self.mainTableView.setEditing(editing, animated: true)
        
    }
    
}

extension SpacesViewController: UITextFieldDelegate {
    
//    func moveTextField(textField: UITextField, moveDistance: Int, up: Bool){
//        let moveDuration = 0.3
//        let movement: CGFloat = CGFloat(up ? moveDistance : -moveDistance)
//
//        UIView.beginAnimations("animateTextField", context: nil)
//        UIView.setAnimationBeginsFromCurrentState(true)
//        UIView.setAnimationDuration(moveDuration)
//        self.view.frame.offsetBy(dx: 0, dy: movement)
//        UIView.commitAnimations()
//    }
    
//    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
//        textField.resignFirstResponder()
//        return true
//    }
}

