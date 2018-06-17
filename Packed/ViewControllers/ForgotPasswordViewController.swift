//
//  ForgotPasswordViewController.swift
//  Packed.
//
//  Created by Jake Gray on 6/16/18.
//  Copyright © 2018 Jake Gray. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth

class ForgotPasswordViewController: UIViewController {

    let cellIdentifier = "Cell"
    
    //Cells
    let emailCell = UITableViewCell()
    
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
    
    let forgotPasswordTableView: UITableView = {
        let table = UITableView()
        table.rowHeight = 44
        table.translatesAutoresizingMaskIntoConstraints = false
        table.backgroundColor = mainColor
        table.separatorStyle = .none
        table.isScrollEnabled = false
        return table
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
    
    lazy var submitButton: UIButton = {
        let button = UIButton()
        button.setTitle("Submit", for: .normal)
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
        label.text = "Forgot Password"
        label.textColor = .white
        label.font = UIFont.systemFont(ofSize: 28)
        label.adjustsFontSizeToFitWidth = true
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .center
        return label
    }()
    
    let detailLabel: UILabel = {
        let label = UILabel()
        label.text = "Enter the email associated with your account"
        label.textColor = .white
        label.font = UIFont.systemFont(ofSize: 14)
        label.textAlignment = .center
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let confirmationLabel: UILabel = {
        let label = UILabel()
        label.text = "A password reset link has been sent to the email you entered!"
        label.backgroundColor = confirmationColor
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 0
        label.textColor = .white
        label.textAlignment = .center
        label.font = UIFont.boldSystemFont(ofSize: 20)
        label.isHidden = true
        label.alpha = 0
        return label
    }()
    
    // MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = mainColor
        forgotPasswordTableView.register(UITableViewCell.self, forCellReuseIdentifier: cellIdentifier)
        
        forgotPasswordTableView.delegate = self
        forgotPasswordTableView.dataSource = self
        view.addGestureRecognizer(touchGestureRecognizer)
        emailTextField.delegate = self
        
        setupView()
        
        emailTextField.becomeFirstResponder()
    }
    
    // MARK: - View Setup
    
    func setupView(){
        
        view.addSubview(titleLabel)
        view.addSubview(detailLabel)
        view.addSubview(forgotPasswordTableView)
        view.addSubview(submitButton)
        view.addSubview(cancelButton)
        view.addSubview(activityIndicator)
        view.addSubview(confirmationLabel)
        
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
        
        forgotPasswordTableView.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: -150).isActive = true
        forgotPasswordTableView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16).isActive = true
        forgotPasswordTableView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -16).isActive = true
        forgotPasswordTableView.heightAnchor.constraint(equalToConstant: 85).isActive = true
        
        submitButton.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16).isActive = true
        submitButton.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -16).isActive = true
        submitButton.topAnchor.constraint(equalTo: forgotPasswordTableView.bottomAnchor, constant: 8).isActive = true
        submitButton.heightAnchor.constraint(equalToConstant: 50).isActive = true
        
        cancelButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        cancelButton.widthAnchor.constraint(equalTo: submitButton.widthAnchor, multiplier: 0.4).isActive = true
        cancelButton.topAnchor.constraint(equalTo: submitButton.bottomAnchor, constant: 8).isActive = true
        cancelButton.heightAnchor.constraint(equalTo: submitButton.heightAnchor).isActive = true
        
        confirmationLabel.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        confirmationLabel.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor).isActive = true
        confirmationLabel.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor).isActive = true
        confirmationLabel.heightAnchor.constraint(equalToConstant: 70).isActive = true
        
        view.bringSubview(toFront: activityIndicator)
        
        //setupCells()
    }
    
    // MARK: - Button Actions
    
    @objc private func userTapped() {
        view.endEditing(true)
    }
    
    @objc private func submitButtonPressed() {
        
        guard let email = emailTextField.text, !email.isEmpty else {
            let alert = UIAlertController(title: "Missing Information", message: "No email entered", preferredStyle: .alert)
            let okayAction = UIAlertAction(title: "Okay", style: .cancel, handler: nil)
            alert.addAction(okayAction)
            present(alert, animated: true, completion: nil)
            
            return}
        
        activityIndicator.startAnimating()
        view.isUserInteractionEnabled = false
        Auth.auth().sendPasswordReset(withEmail: email) { (error) in
            self.activityIndicator.stopAnimating()
            if let error = error {
                let alert = UIAlertController(title: "Oops, something went wrong!", message: error.localizedDescription, preferredStyle: .alert)
                let okayAction = UIAlertAction(title: "Okay", style: .cancel, handler: nil)
                alert.addAction(okayAction)
                self.present(alert, animated: true, completion: nil)
                self.view.isUserInteractionEnabled = true
                return
            }
            
            DispatchQueue.main.async {
                UIView.animate(withDuration: 0.2, animations: {
                    self.confirmationLabel.isHidden = false
                    self.confirmationLabel.alpha = 1
                    self.confirmationLabel.transform = CGAffineTransform(scaleX: 1.2, y: 1.2)
                }, completion: { (_) in
                    UIView.animate(withDuration: 0.2, animations: {
                        self.confirmationLabel.transform = CGAffineTransform(scaleX: 0.8, y: 0.8)
                    }, completion: { (_) in
                        let timer = Timer.scheduledTimer(withTimeInterval: 3.0, repeats: false) { (timer) in
                            self.dismiss(animated: true, completion: nil)
                        }
                        RunLoop.current.add(timer, forMode: .commonModes)
                    })
                })
            }
            
        }
        
    }
    
    @objc private func cancelButtonPressed(){
        self.view.endEditing(true)
        dismiss(animated: true, completion: nil)
    }
    
}

// MARK: - Text Field Delegate

extension ForgotPasswordViewController: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        textField.resignFirstResponder()
        
        submitButtonPressed()
        
        return true
    }
}

// MARK: - Tableview Data Source

extension ForgotPasswordViewController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        switch section {
        case 0:
            return "Recovery Email"
        default:
            return ""
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath)
        
        cell.backgroundColor = mainColor
        
        
        cell.addSubview(emailTextField)
        
        emailTextField.placeholder = "Email"
        emailTextField.topAnchor.constraint(equalTo: cell.topAnchor).isActive = true
        emailTextField.bottomAnchor.constraint(equalTo: cell.bottomAnchor).isActive = true
        emailTextField.leadingAnchor.constraint(equalTo: cell.leadingAnchor).isActive = true
        emailTextField.trailingAnchor.constraint(equalTo: cell.trailingAnchor).isActive = true
        
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
