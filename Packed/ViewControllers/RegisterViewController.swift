//
//  RegisterViewController.swift
//  Packed
//
//  Created by Jake Gray on 6/4/18.
//  Copyright © 2018 Jake Gray. All rights reserved.
//

import UIKit
import Firebase

class RegisterViewController: UIViewController {
    
    var heightConstraint = NSLayoutConstraint()
    var isNewUser = false
    let cellIdentifier = "Cell"
    
    //Cells
    let userNameCell = UITableViewCell()
    let emailCell = UITableViewCell()
    let pwCell = UITableViewCell()
    let pwConfirmCell = UITableViewCell()
    var keyboardHeight : CGFloat = 216
    
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
    
    let registerTableView: UITableView = {
        let table = UITableView()
        table.rowHeight = 44
        table.translatesAutoresizingMaskIntoConstraints = false
        table.backgroundColor = mainColor
        table.separatorStyle = .none
        table.isScrollEnabled = false
        return table
    }()
    
    //Text Fields
    var userNameTextField: UITextField = {
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
        textField.isSecureTextEntry = true
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
        textField.isSecureTextEntry = true
        return textField
    }()
    
    lazy var submitButton: UIButton = {
        let button = UIButton()
        button.setTitle("Register", for: .normal)
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
    
    let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "Register"
        label.textColor = .white
        label.font = UIFont.systemFont(ofSize: 28)
        label.adjustsFontSizeToFitWidth = true
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .center
        return label
    }()
    
    let detailLabel: UILabel = {
        let label = UILabel()
        label.text = "Register to share your places with anyone helping you."
        label.textColor = .white
        label.font = UIFont.systemFont(ofSize: 14)
        label.textAlignment = .center
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    // MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = mainColor
        registerTableView.register(UITableViewCell.self, forCellReuseIdentifier: cellIdentifier)
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        
        
        registerTableView.delegate = self
        registerTableView.dataSource = self
        view.addGestureRecognizer(touchGestureRecognizer)
        
        userNameTextField.delegate = self
        emailTextField.delegate = self
        passwordTextField.delegate = self
        passwordConfirmationTextField.delegate = self
        
        setupView()
    }
    
    // MARK: - View Setup
    
    func setupView(){
        
        view.addSubview(titleLabel)
        view.addSubview(detailLabel)
        view.addSubview(registerTableView)
        view.addSubview(submitButton)
        view.addSubview(cancelButton)
        view.addSubview(activityIndicator)
        
        activityIndicator.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        activityIndicator.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        activityIndicator.heightAnchor.constraint(equalToConstant: 30).isActive = true
        activityIndicator.widthAnchor.constraint(equalToConstant: 30).isActive = true
        
        titleLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 16).isActive = true
        titleLabel.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16).isActive = true
        titleLabel.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -16).isActive = true
        
        detailLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 4).isActive = true
        detailLabel.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16).isActive = true
        detailLabel.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -16).isActive = true
        
        registerTableView.topAnchor.constraint(equalTo: detailLabel.bottomAnchor, constant: 8).isActive = true
        registerTableView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16).isActive = true
        registerTableView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -16).isActive = true
        registerTableView.heightAnchor.constraint(equalToConstant: 300).isActive = true
        
        submitButton.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16).isActive = true
        submitButton.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -16).isActive = true
        submitButton.topAnchor.constraint(equalTo: registerTableView.bottomAnchor, constant: 8).isActive = true
        submitButton.heightAnchor.constraint(equalToConstant: 50).isActive = true
        
        cancelButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        cancelButton.widthAnchor.constraint(equalTo: submitButton.widthAnchor, multiplier: 0.4).isActive = true
        cancelButton.topAnchor.constraint(equalTo: submitButton.bottomAnchor, constant: 8).isActive = true
        cancelButton.heightAnchor.constraint(equalTo: submitButton.heightAnchor).isActive = true
        
        view.bringSubview(toFront: activityIndicator)
        
        //setupCells()
    }
    
    private func setupCells(){
        userNameCell.addSubview(userNameTextField)
    }
    
    // MARK: - Button Actions
    
    @objc private func userTapped() {
        view.endEditing(true)
        UIView.animate(withDuration: 0.2) {
            self.view.frame.origin.y = 0
        }
    }
    
    @objc private func submitButtonPressed() {
        UIView.animate(withDuration: 0.2) {
            self.view.frame.origin.y = 0
        }
        guard let email = emailTextField.text, !email.isEmpty else {print("No email entered") ; return}
        guard let password = passwordTextField.text, !password.isEmpty else {print("No Password entered") ; return}
        guard let confirmPassword = passwordConfirmationTextField.text, !confirmPassword.isEmpty else {print("No Password confimation entered") ; return}
        guard let name = userNameTextField.text, !name.isEmpty else {print("No username entered") ; return}
            
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
                    self.add(user: user, withName: name)
                    print("Sign in successful")
                    self.view.endEditing(true)
                    self.presentingViewController?.presentingViewController?.dismiss(animated: true, completion: nil)
                }
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
    
    private func add(user: User, withName name: String){
        let userRef = ref.child("users").child(user.uid)
        
        let values = ["name": name, "email" : user.email!]
        
        userRef.updateChildValues(values)
    }
    
    @objc func keyboardWillShow(notification: NSNotification) {
//        if let keyboardSize = (notification.userInfo?[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
////            keyboardHeight = keyboardSize.height
//        }
    }
    
}

// MARK: - Text Field Delegate

extension RegisterViewController: UITextFieldDelegate {
    func textFieldDidBeginEditing(_ textField: UITextField) {
//        let moveAmount = keyboardHeight - (textField.superview?.frame.origin.y)! - 44
//        if moveAmount < 0 {
//           self.view.frame.origin.y -= -(moveAmount)
//        }
    }
    
    func textFieldDidEndEditing(_ textField: UITextField, reason: UITextFieldDidEndEditingReason) {
        view.frame.origin.y = 0
        print("did end editing")
        view.endEditing(true)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
//        textField.resignFirstResponder()
        
        switch textField {
        case userNameTextField:
            userNameTextField.resignFirstResponder()
            emailTextField.becomeFirstResponder()
        case emailTextField:
            emailTextField.resignFirstResponder()
            passwordTextField.becomeFirstResponder()
        case passwordTextField:
            passwordTextField.resignFirstResponder()
            passwordConfirmationTextField.becomeFirstResponder()
        case passwordConfirmationTextField:
            passwordConfirmationTextField.resignFirstResponder()
            submitButtonPressed()
        default:
            view.resignFirstResponder()
        }
        
        return true
    }
    
    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
        view.frame.origin.y = 0
        print("Should end editing")
        view.endEditing(true)
        return true
    }
}

// MARK: - Tableview Data Source

extension RegisterViewController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 3
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        switch section {
        case 0:
            return "Username"
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
            return 2
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
            cell.addSubview(userNameTextField)
            
            userNameTextField.placeholder = "Username"
            userNameTextField.topAnchor.constraint(equalTo: cell.topAnchor).isActive = true
            userNameTextField.bottomAnchor.constraint(equalTo: cell.bottomAnchor).isActive = true
            userNameTextField.leadingAnchor.constraint(equalTo: cell.leadingAnchor).isActive = true
            userNameTextField.trailingAnchor.constraint(equalTo: cell.trailingAnchor).isActive = true
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
//            header.frame.size.height = 40
            header.backgroundView = UIImageView()
        }
        
    }
}









