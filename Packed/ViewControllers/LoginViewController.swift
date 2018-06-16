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
    let emailCell = UITableViewCell()
    let pwCell = UITableViewCell()
    
    lazy var touchGestureRecognizer: UIGestureRecognizer = {
        let recognizer = UITapGestureRecognizer(target: self, action: #selector(userTapped))
        return recognizer
    }()
    
    let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "Log In"
        label.textColor = .white
        label.font = UIFont.systemFont(ofSize: 28)
        label.adjustsFontSizeToFitWidth = true
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .center
        return label
    }()
    
    let detailLabel: UILabel = {
        let label = UILabel()
        label.text = "Log in to share your places with anyone helping you."
        label.textColor = .white
        label.font = UIFont.systemFont(ofSize: 14)
        label.adjustsFontSizeToFitWidth = true
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .center
        return label
    }()
    
    let activityIndicator: UIActivityIndicatorView = {
        let activity = UIActivityIndicatorView()
        activity.translatesAutoresizingMaskIntoConstraints = false
        activity.color = .white
        return activity
    }()
    
    let loginTableView: UITableView = {
        let table = UITableView()
        table.rowHeight = 50
        table.translatesAutoresizingMaskIntoConstraints = false
        table.backgroundColor = mainColor
        table.separatorStyle = .none
        table.isScrollEnabled = false
        return table
    }()
    
    let signUpLabel: UILabel = {
        let label = UILabel()
        label.text = "Don't have an account?"
        label.textColor = .white
        label.font = UIFont.systemFont(ofSize: 18)
        label.adjustsFontSizeToFitWidth = true
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .center
        return label
    }()
    
    lazy var signUpButton: UIButton = {
        let button = UIButton()
        button.setTitle("Sign Up Here", for: .normal)
        button.setTitleColor(secondaryColor, for: .normal)
        button.clipsToBounds = true
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(signUpButtonPressed), for: .touchUpInside)
        return button
    }()

    //Text Fields
    
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

    
    lazy var submitButton: UIButton = {
        let button = UIButton()
        button.setTitle("Log In", for: .normal)
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
        button.setTitleColor(secondaryColor, for: .normal)
        button.clipsToBounds = true
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(cancelButtonPressed), for: .touchUpInside)
        return button
    }()
    
    

    // MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = mainColor
        loginTableView.register(UITableViewCell.self, forCellReuseIdentifier: cellIdentifier)
        
        
        loginTableView.delegate = self
        loginTableView.dataSource = self
        view.addGestureRecognizer(touchGestureRecognizer)
        
        emailTextField.delegate = self
        passwordTextField.delegate = self
        
        setupView()
    }
    
    // MARK: - View Setup
    
    func setupView(){
        
        view.addSubview(titleLabel)
        view.addSubview(detailLabel)
        view.addSubview(loginTableView)
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
        
        loginTableView.topAnchor.constraint(equalTo: detailLabel.bottomAnchor, constant: 8).isActive = true
        loginTableView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16).isActive = true
        loginTableView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -16).isActive = true
        loginTableView.heightAnchor.constraint(equalToConstant: 180).isActive = true
        
        submitButton.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16).isActive = true
        submitButton.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -16).isActive = true
        submitButton.topAnchor.constraint(equalTo: loginTableView.bottomAnchor, constant: 16).isActive = true
        submitButton.heightAnchor.constraint(equalToConstant: 50).isActive = true
        
        cancelButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        cancelButton.widthAnchor.constraint(equalTo: submitButton.widthAnchor, multiplier: 0.4).isActive = true
        cancelButton.topAnchor.constraint(equalTo: submitButton.bottomAnchor, constant: 4).isActive = true
        cancelButton.heightAnchor.constraint(equalTo: submitButton.heightAnchor).isActive = true
        
        let signUpStackView = UIStackView(arrangedSubviews: [signUpLabel,signUpButton])
        signUpStackView.spacing = 0
        signUpStackView.translatesAutoresizingMaskIntoConstraints = false
        signUpStackView.distribution = .fillProportionally
        signUpStackView.axis = .vertical
        signUpStackView.spacing = 4
        
        view.addSubview(signUpStackView)
        
        signUpStackView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16).isActive = true
        signUpStackView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -16).isActive = true
        signUpStackView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor).isActive = true
        signUpStackView.heightAnchor.constraint(equalToConstant: 60).isActive = true
        
        view.bringSubview(toFront: activityIndicator)
    }
    
    // MARK: - Button Actions
    
    @objc private func userTapped() {
        view.endEditing(true)
        UIView.animate(withDuration: 0.2) {
            self.view.frame.origin.y = 0
        }
    }
    
    @objc private func submitButtonPressed() {
        activityIndicator.startAnimating()
        UIView.animate(withDuration: 0.2) {
            self.view.frame.origin.y = 0
        }
        
        guard let email = emailTextField.text, !email.isEmpty else {
            activityIndicator.stopAnimating()
            let alert = UIAlertController(title: "Missing Information", message: "No email entered", preferredStyle: .alert)
            let okayAction = UIAlertAction(title: "Okay", style: .cancel, handler: nil)
            alert.addAction(okayAction)
            present(alert, animated: true, completion: nil)
            return
            
        }
        
        guard let password = passwordTextField.text, !password.isEmpty else {
            activityIndicator.stopAnimating()
            let alert = UIAlertController(title: "Missing Information", message: "No password entered", preferredStyle: .alert)
            let okayAction = UIAlertAction(title: "Okay", style: .cancel, handler: nil)
            alert.addAction(okayAction)
            present(alert, animated: true, completion: nil)
            
            return
            
        }
        
        Auth.auth().signIn(withEmail: email, password: password) { (auth, error) in
            self.activityIndicator.stopAnimating()
            if let error = error {
                let alert = UIAlertController(title: "Error Logging In", message: error.localizedDescription, preferredStyle: .alert)
                let okayAction = UIAlertAction(title: "Okay", style: .cancel, handler: nil)
                alert.addAction(okayAction)
                self.present(alert, animated: true, completion: nil)
                return
            }
            self.view.endEditing(true)
            self.dismiss(animated: true, completion: nil)
            
        }
        
    }
    
    @objc private func cancelButtonPressed(){
        self.view.endEditing(true)
        dismiss(animated: true, completion: nil)
    }
    
    @objc private func signUpButtonPressed() {
        present(RegisterViewController(), animated: true, completion: nil)
    }
}

extension LoginViewController: UITextFieldDelegate {
    
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
        return 2
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        switch section {
        case 0:
            return "Email"
        case 1:
            return "Password"
        default:
            return "Section"
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath)
        
        cell.backgroundColor = mainColor
        
        switch indexPath.section {
        
        case 0:
            cell.addSubview(emailTextField)
            
            emailTextField.placeholder = "Email"
            emailTextField.topAnchor.constraint(equalTo: cell.topAnchor).isActive = true
            emailTextField.bottomAnchor.constraint(equalTo: cell.bottomAnchor).isActive = true
            emailTextField.leadingAnchor.constraint(equalTo: cell.leadingAnchor).isActive = true
            emailTextField.trailingAnchor.constraint(equalTo: cell.trailingAnchor).isActive = true
        case 1:
            cell.addSubview(passwordTextField)
            
            passwordTextField.placeholder = "Password"
            passwordTextField.topAnchor.constraint(equalTo: cell.topAnchor).isActive = true
            passwordTextField.bottomAnchor.constraint(equalTo: cell.bottomAnchor).isActive = true
            passwordTextField.leadingAnchor.constraint(equalTo: cell.leadingAnchor).isActive = true
            passwordTextField.trailingAnchor.constraint(equalTo: cell.trailingAnchor).isActive = true
            
        default:
            return cell
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        if let header = view as? UITableViewHeaderFooterView {
            header.textLabel?.textColor = .white
            header.backgroundView = UIImageView()
        }
    }
}









