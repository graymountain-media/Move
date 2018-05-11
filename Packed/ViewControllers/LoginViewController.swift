//
//  LoginViewController.swift
//  Packed
//
//  Created by Jake Gray on 5/10/18.
//  Copyright © 2018 Jake Gray. All rights reserved.
//

import UIKit
import FirebaseAuth

class LoginViewController: UIViewController {
  
    
    var heightConstraint = NSLayoutConstraint()
    
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
    
    let textFieldContainer: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.translatesAutoresizingMaskIntoConstraints = false
        view.layer.cornerRadius = 5
        view.clipsToBounds = true
        view.backgroundColor = .lightGray
        return view
    }()
    
    let emailTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "Email"
        textField.setPadding()
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.frame.size.height = textFieldHeight
        textField.backgroundColor = .white
        return textField
    }()
    
    let passwordTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "Password"
        textField.setPadding()
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.frame.size.height = textFieldHeight
        textField.backgroundColor = .white
        return textField
    }()
    
    let passwordConfirmationTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "Retype Password"
        textField.setPadding()
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.frame.size.height = textFieldHeight
        textField.backgroundColor = .white
        textField.isHidden = true
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
        label.text = "Log in to share your places with anyone helping you."
        label.textColor = .white
        label.font = UIFont.systemFont(ofSize: 14)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    // MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = mainColor
        setupView()
        
        view.addGestureRecognizer(touchGestureRecognizer)
        
        emailTextField.delegate = self
        passwordTextField.delegate = self
        passwordConfirmationTextField.delegate = self

    }
    
    // MARK: - View Setup
    
    func setupView(){
        
        view.addSubview(detailLabel)
        view.addSubview(statusControl)
        view.addSubview(textFieldContainer)
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
        statusControl.bottomAnchor.constraint(equalTo: textFieldContainer.topAnchor, constant: -8).isActive = true
        statusControl.heightAnchor.constraint(equalToConstant: 44).isActive = true
        statusControl.addTarget(self, action: #selector(statusChanged), for: UIControlEvents.valueChanged)
        
        submitButton.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16).isActive = true
        submitButton.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -16).isActive = true
        submitButton.topAnchor.constraint(equalTo: textFieldContainer.bottomAnchor, constant: 8).isActive = true
        submitButton.heightAnchor.constraint(equalToConstant: 50).isActive = true
        
        cancelButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        cancelButton.widthAnchor.constraint(equalTo: submitButton.widthAnchor, multiplier: 0.4).isActive = true
        cancelButton.topAnchor.constraint(equalTo: submitButton.bottomAnchor, constant: 8).isActive = true
        cancelButton.heightAnchor.constraint(equalTo: submitButton.heightAnchor).isActive = true
        
        textFieldContainer.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        textFieldContainer.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16).isActive = true
        textFieldContainer.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -16).isActive = true
        heightConstraint = textFieldContainer.heightAnchor.constraint(equalToConstant: 50)
        heightConstraint.isActive = true
        heightConstraint.constant = 100
        
        let textfieldStackView = UIStackView(arrangedSubviews: [emailTextField,passwordTextField,passwordConfirmationTextField])
        textfieldStackView.axis = .vertical
        textfieldStackView.distribution = .fillEqually
        textfieldStackView.spacing = 1
        textfieldStackView.translatesAutoresizingMaskIntoConstraints = false
        
        textFieldContainer.addSubview(textfieldStackView)
        
        textfieldStackView.leadingAnchor.constraint(equalTo: textFieldContainer.leadingAnchor).isActive = true
        textfieldStackView.trailingAnchor.constraint(equalTo: textFieldContainer.trailingAnchor).isActive = true
        textfieldStackView.topAnchor.constraint(equalTo: textFieldContainer.topAnchor).isActive = true
        textfieldStackView.bottomAnchor.constraint(equalTo: textFieldContainer.bottomAnchor).isActive = true
        
        view.bringSubview(toFront: activityIndicator)
    }
    
    // MARK: - Button Actions
    
    @objc private func userTapped() {
        print("User Tapped")
        view.endEditing(true)
    }
    
    @objc private func statusChanged() {
        switch statusControl.selectedSegmentIndex {
        case 0 :
            self.heightConstraint.constant -= 50
            self.passwordConfirmationTextField.isHidden = true
            submitButton.setTitle("Sign In", for: .normal)
        case 1:
            self.passwordConfirmationTextField.isHidden = false
            self.heightConstraint.constant += 50
            submitButton.setTitle("Register", for: .normal)
        default:
            print("Status change failed")
        }
    }
    
    
    @objc private func submitButtonPressed() {
        guard let email = emailTextField.text, !email.isEmpty else {print("No email entered") ; return}
        guard let password = passwordTextField.text, !password.isEmpty else {print("No Password entered") ; return}
        
        
        switch statusControl.selectedSegmentIndex {
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
                
                //Sign In
                Auth.auth().signIn(withEmail: email, password: password, completion: { (user, error) in
                    DispatchQueue.main.async {
                        self.activityIndicator.stopAnimating()
                    }
                    if let error = error {
                        print("Error signing in: \(error.localizedDescription)")
                        return
                    }
                    
                    print("Sign in successful")
                    self.view.endEditing(true)
                    self.dismiss(animated: true, completion: nil)
                })
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
}

extension LoginViewController: UITextFieldDelegate {
    func textFieldDidBeginEditing(_ textField: UITextField) {
        UIView.animate(withDuration: 0.2) {
            self.view.frame.origin.y -= 55
        }
    }
    
    func textFieldDidEndEditing(_ textField: UITextField, reason: UITextFieldDidEndEditingReason) {
        view.endEditing(true)
        UIView.animate(withDuration: 0.2) {
            self.view.frame.origin.y += 55
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        submitButtonPressed()
        textField.resignFirstResponder()
        return true
    }
}











