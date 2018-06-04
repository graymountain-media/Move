//
//  LoginViewController.swift
//  Packed
//
//  Created by Jake Gray on 5/10/18.
//  Copyright © 2018 Jake Gray. All rights reserved.
//

import UIKit
import Firebase

class LoginViewController: UIViewController {
  
    var heightConstraint = NSLayoutConstraint()
    var isNewUser = false
    let cellIdentifier = "Cell"
    
    //Cells
    let nameCell = UITableViewCell() 
    let emailCell = UITableViewCell()
    let pwCell = UITableViewCell()
    let pwConfirmCell = UITableViewCell()
    
    lazy var touchGestureRecognizer: UIGestureRecognizer = {
        let recognizer = UITapGestureRecognizer(target: self, action: #selector(userTapped))
        return recognizer
    }()
    
    let activityIndicator: UIActivityIndicatorView = {
        let activity = UIActivityIndicatorView()
        activity.translatesAutoresizingMaskIntoConstraints = false
        activity.color = .black
        return activity
    }()
    
    let statusControl: UISegmentedControl = {
        let control = UISegmentedControl(items: ["Sign In","Register"])
        control.tintColor = .white
        control.selectedSegmentIndex = 0
        control.translatesAutoresizingMaskIntoConstraints = false
        return control
    }()
    
    let inputsTableView: UITableView = {
        let table = UITableView(frame: CGRect.zero, style: .grouped)
        table.rowHeight = 50
        table.translatesAutoresizingMaskIntoConstraints = false
        table.backgroundColor = mainColor
        table.separatorStyle = .none
        table.isScrollEnabled = false
        return table
    }()

    //Text Fields
    var nameTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "Email"
        textField.setPadding()
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.backgroundColor = .white
        textField.layer.cornerRadius = 5
        textField.clipsToBounds = true
        return textField
    }()
    
    var emailTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "Email"
        textField.setPadding()
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.backgroundColor = .white
        textField.layer.cornerRadius = 5
        textField.clipsToBounds = true
        return textField
    }()
    
    var passwordTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "Email"
        textField.setPadding()
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.backgroundColor = .white
        textField.layer.cornerRadius = 5
        textField.clipsToBounds = true
        return textField
    }()
    
    var passwordConfirmationTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "Email"
        textField.setPadding()
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.backgroundColor = .white
        textField.layer.cornerRadius = 5
        textField.clipsToBounds = true
        return textField
    }()
    
    
    
    lazy var submitButton: UIButton = {
        let button = UIButton()
        button.setTitle("Sign In", for: .normal)
        button.backgroundColor = .lightGray
        button.layer.cornerRadius = 5
        button.clipsToBounds = true
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(submitButtonPressed), for: .touchUpInside)
        return button
    }()
    
    lazy var cancelButton: UIButton = {
        let button = UIButton()
        button.setTitle("Cancel", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.clipsToBounds = true
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(cancelButtonPressed), for: .touchUpInside)
        return button
    }()
    
    let detailLabel: UILabel = {
        let label = UILabel()
        label.text = "Sign in to share your places with anyone helping you."
        label.textColor = .white
        label.font = UIFont.systemFont(ofSize: 14)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    // MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = mainColor
        inputsTableView.register(UITableViewCell.self, forCellReuseIdentifier: cellIdentifier)
        
        
        inputsTableView.delegate = self
        inputsTableView.dataSource = self
        view.addGestureRecognizer(touchGestureRecognizer)
        
        nameTextField.delegate = self
        emailTextField.delegate = self
        passwordTextField.delegate = self
        passwordConfirmationTextField.delegate = self
        
        setupView()
    }
    
    // MARK: - View Setup
    
    func setupView(){
        
        view.addSubview(detailLabel)
        view.addSubview(statusControl)
        view.addSubview(inputsTableView)
        view.addSubview(submitButton)
        view.addSubview(cancelButton)
        view.addSubview(activityIndicator)
        
        activityIndicator.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        activityIndicator.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        activityIndicator.heightAnchor.constraint(equalToConstant: 30).isActive = true
        activityIndicator.widthAnchor.constraint(equalToConstant: 30).isActive = true
        

        
        detailLabel.bottomAnchor.constraint(equalTo: statusControl.topAnchor, constant: -8).isActive = true
        detailLabel.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16).isActive = true
        detailLabel.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -16).isActive = true
        
        statusControl.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16).isActive = true
        statusControl.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -16).isActive = true
        statusControl.bottomAnchor.constraint(equalTo: inputsTableView.topAnchor, constant: -8).isActive = true
        statusControl.heightAnchor.constraint(equalToConstant: 44).isActive = true
        statusControl.addTarget(self, action: #selector(statusChanged), for: UIControlEvents.valueChanged)
        
        submitButton.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16).isActive = true
        submitButton.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -16).isActive = true
        submitButton.bottomAnchor.constraint(equalTo: cancelButton.topAnchor, constant: -8).isActive = true
        submitButton.heightAnchor.constraint(equalToConstant: 50).isActive = true
        
        cancelButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        cancelButton.widthAnchor.constraint(equalTo: submitButton.widthAnchor, multiplier: 0.4).isActive = true
        cancelButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -8).isActive = true
        cancelButton.heightAnchor.constraint(equalTo: submitButton.heightAnchor).isActive = true
        
        inputsTableView.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        inputsTableView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16).isActive = true
        inputsTableView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -16).isActive = true
        inputsTableView.heightAnchor.constraint(equalToConstant: 400).isActive = true
        
        view.bringSubview(toFront: activityIndicator)
        
        //setupCells()
    }
    
    private func setupCells(){
        nameCell.addSubview(nameTextField)
    }
    
    // MARK: - Button Actions
    
    @objc private func userTapped() {
        view.endEditing(true)
        UIView.animate(withDuration: 0.2) {
            self.view.frame.origin.y = 0
        }
    }
    
    @objc private func statusChanged() {
        UIView.animate(withDuration: 0.2) {
            self.view.frame.origin.y = 0
        }
        switch statusControl.selectedSegmentIndex {
        case 0 :
            isNewUser = false
            submitButton.setTitle("Sign In", for: .normal)
            inputsTableView.deleteRows(at: [IndexPath(item: 1, section: 2)], with: .top)
        case 1:
            isNewUser = true
            submitButton.setTitle("Register", for: .normal)
            inputsTableView.insertRows(at: [IndexPath(item: 1, section: 2)], with: .top)
        default:
            print("Status change failed")
        }
    }
    
    
    @objc private func submitButtonPressed() {
        guard let email = emailTextField.text, !email.isEmpty else {print("No email entered") ; return}
        guard let password = passwordTextField.text, !password.isEmpty else {print("No Password entered") ; return}
        
        
        switch statusControl.selectedSegmentIndex {
        
        //SIGN IN
        case 0 :
            Auth.auth().signIn(withEmail: email, password: password) { (auth, error) in
                if let error = error {
                    print("Error signing in: \(error.localizedDescription)")
                    return
                }
                print("sign in successful")
                self.view.endEditing(true)
                self.dismiss(animated: true, completion: nil)
                
            }
            
        //REGISTER
        case 1:
            guard let confirmPassword = passwordConfirmationTextField.text, !confirmPassword.isEmpty else {print("No Password confimation entered") ; return}
            
            let results = validatePassword(password: password, confirmPassword: confirmPassword)
            
            if results.0 == false { print(results.1); return }
            
            activityIndicator.startAnimating()
            Auth.auth().createUser(withEmail: email, password: password) { (result, error) in
                
                if let error = error {
                    DispatchQueue.main.async {
                        self.activityIndicator.stopAnimating()
                    }
                    print("Error \(error.localizedDescription)")
                    return
                }
                
                //Successful
                if let user = result?.user {
                    self.add(user: user)
                    print("Sign in successful")
                    self.view.endEditing(true)
                    self.dismiss(animated: true, completion: nil)
                }
            }
        default:
            print("Status change failed")
        }
    }
    
    @objc private func cancelButtonPressed(){
        self.view.endEditing(true)
        dismiss(animated: true, completion: nil)
    }
    
    // MARK: - Methods
    private func validatePassword(password: String, confirmPassword: String) -> (Bool, String) {
        
        if password.count < 8 {
            return (false, "Password must be at least 8 characters long")
        }
        
        if password != confirmPassword {
            return (false, "Passwords do not match")
        }
        
        return (true, "")
    }
    
    private func add(user: User){
        let userRef = Database.database().reference().child("users").child(user.uid)
        
        let values = ["name": "", "email" : user.email!]
        
        userRef.updateChildValues(values)
    }
}

extension LoginViewController: UITextFieldDelegate {
    func textFieldDidBeginEditing(_ textField: UITextField) {
        UIView.animate(withDuration: 0.3) {
            self.view.frame.origin.y -= ((textField.superview?.frame.origin.y)! + self.view.frame.origin.y) - 30
        }
    }
    
    func textFieldDidEndEditing(_ textField: UITextField, reason: UITextFieldDidEndEditingReason) {
        print("did end editing")
        view.endEditing(true)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        submitButtonPressed()
        textField.resignFirstResponder()
        return true
    }
    
    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
         print("Should end editing")
        view.endEditing(true)
        return true
    }
}

// MARK: - Tableview Data Source

extension LoginViewController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 3
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        switch section {
        case 0:
            return "Name"
        case 1:
            return "Email"
        case 2:
            return "Password"
        default:
            return ""
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 2:
            return isNewUser ? 2 : 1
        default:
            return 1
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath)
        
        cell.backgroundColor = mainColor
        
        switch indexPath.section {
        case 0:
            print("Name section")
            cell.addSubview(nameTextField)
            
            nameTextField.placeholder = "Name"
            nameTextField.topAnchor.constraint(equalTo: cell.topAnchor).isActive = true
            nameTextField.bottomAnchor.constraint(equalTo: cell.bottomAnchor).isActive = true
            nameTextField.leadingAnchor.constraint(equalTo: cell.leadingAnchor).isActive = true
            nameTextField.trailingAnchor.constraint(equalTo: cell.trailingAnchor).isActive = true
        case 1:
            print("email section")
            cell.addSubview(emailTextField)
            
            emailTextField.placeholder = "Email"
            emailTextField.topAnchor.constraint(equalTo: cell.topAnchor).isActive = true
            emailTextField.bottomAnchor.constraint(equalTo: cell.bottomAnchor).isActive = true
            emailTextField.leadingAnchor.constraint(equalTo: cell.leadingAnchor).isActive = true
            emailTextField.trailingAnchor.constraint(equalTo: cell.trailingAnchor).isActive = true
        case 2:
            if indexPath.row == 0 {
                cell.addSubview(passwordTextField)
                
                passwordTextField.placeholder = "Password"
                passwordTextField.topAnchor.constraint(equalTo: cell.topAnchor).isActive = true
                passwordTextField.bottomAnchor.constraint(equalTo: cell.bottomAnchor).isActive = true
                passwordTextField.leadingAnchor.constraint(equalTo: cell.leadingAnchor).isActive = true
                passwordTextField.trailingAnchor.constraint(equalTo: cell.trailingAnchor).isActive = true
            } else {
                cell.addSubview(passwordConfirmationTextField)
                
                passwordConfirmationTextField.placeholder = "Retype Password"
                passwordConfirmationTextField.topAnchor.constraint(equalTo: cell.topAnchor).isActive = true
                passwordConfirmationTextField.bottomAnchor.constraint(equalTo: cell.bottomAnchor).isActive = true
                passwordConfirmationTextField.leadingAnchor.constraint(equalTo: cell.leadingAnchor).isActive = true
                passwordConfirmationTextField.trailingAnchor.constraint(equalTo: cell.trailingAnchor).isActive = true
            }
        default:
            return cell
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        if let header = view as? UITableViewHeaderFooterView {
            header.textLabel?.textColor = .white
            header.frame.size.height = 20
        }
    }
}









