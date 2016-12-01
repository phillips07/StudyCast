//
//  PasswordResetController.swift
//  StudyCast
//
//  Created by Dennis Huebert on 2016-11-17.
//  Copyright © 2016 Austin Phillips. All rights reserved.
//

import UIKit
import Firebase

class PasswordResetController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        self.hideKeyboardWhenTappedAround()
        view.backgroundColor = UIColor(r: 61, g: 91, b: 151)
        self.navigationController?.navigationBar.barTintColor = UIColor(r: 61, g: 91, b: 151)
        self.navigationController?.navigationBar.tintColor = UIColor.white
        
        view.addSubview(resetButton)
        view.addSubview(resetLabel)
        view.addSubview(emailTextField)
        view.addSubview(resetMessage)
        view.addSubview(returnToLoginButton)
        view.addSubview(cancelButton)
        
        setupResetButton()
        setupResetLabel()
        setupEmailTextField()
        setupResetMessage()
        setupReturnToLoginButton()
        setupCancelButton()
    }
    
    let resetLabel: UILabel = {
        let label = UILabel()
        label.textColor = UIColor.white
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Reset Your Password"
        label.font = UIFont.boldSystemFont(ofSize: 18)
        return label
    }()
    
    let resetMessage: UILabel = {
        let label = UILabel()
        label.textColor = UIColor.white
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Enter your email address and we'll\nsend you a link to reset your password."
        label.font = UIFont.boldSystemFont(ofSize: 14)
        label.textAlignment = NSTextAlignment.center
        label.numberOfLines = 2
        return label
    }()
    
    lazy var resetButton: UIButton = {
        let button = UIButton(type: .system)
        button.backgroundColor = UIColor(r: 80, g: 101, b: 161)
        button.setTitle("Reset Password", for: UIControlState())
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitleColor(UIColor.white, for: UIControlState())
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 16)
        button.addTarget(self, action: #selector(handleReset), for: .touchUpInside)
        
        return button
    }()
    
    lazy var returnToLoginButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Return to Login", for: UIControlState())
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitleColor(UIColor.white, for: UIControlState())
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 14)
        button.addTarget(self, action: #selector(handleBack), for: .touchUpInside)
        return button
    }()
    
    let emailTextField: UITextField = {
        let tf = UITextField()
        tf.placeholder = " Email Address"
        tf.translatesAutoresizingMaskIntoConstraints = false
        tf.backgroundColor = UIColor.white
        tf.layer.cornerRadius = 6.0
        return tf
    }()
    
    lazy var cancelButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Cancel", for: UIControlState())
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitleColor(UIColor.white, for: UIControlState())
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 16)
        button.addTarget(self, action: #selector(handleBack), for: .touchUpInside)
        return button
    }()
    
    func setupResetButton(){
        resetButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        resetButton.topAnchor.constraint(equalTo: emailTextField.bottomAnchor, constant: 20).isActive = true
        resetButton.widthAnchor.constraint(equalTo: emailTextField.widthAnchor).isActive = true
        resetButton.heightAnchor.constraint(equalToConstant: 45).isActive = true
    }
    
    func setupResetLabel(){
        resetLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        resetLabel.topAnchor.constraint(equalTo: view.topAnchor, constant: 200).isActive = true
    }
    
    func setupResetMessage(){
        resetMessage.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        resetMessage.topAnchor.constraint(equalTo: resetLabel.bottomAnchor, constant: 20).isActive = true
    }
    
    func setupEmailTextField(){
        emailTextField.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        emailTextField.topAnchor.constraint(equalTo: resetMessage.bottomAnchor, constant: 20).isActive = true
        emailTextField.widthAnchor.constraint(equalTo: view.widthAnchor, constant: -140).isActive = true
        emailTextField.heightAnchor.constraint(equalToConstant: 35).isActive = true
    }
    
    func setupReturnToLoginButton(){
        returnToLoginButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        returnToLoginButton.topAnchor.constraint(equalTo: resetButton.bottomAnchor, constant: 20).isActive = true
    }
    
    func setupCancelButton(){
        cancelButton.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 10).isActive = true
        cancelButton.topAnchor.constraint(equalTo: view.topAnchor, constant: 25).isActive = true
    }
    
    func handleReset() {
        guard let email = emailTextField.text else {
                print("Form is not valid")
                return
        }
        
        FIRAuth.auth()?.sendPasswordReset(withEmail: email) { error in
            if let error = error {
                print(error)
                let alert = UIAlertController(title: "Password Reset", message: "No account with the entered email was found.",
                                              preferredStyle: UIAlertControllerStyle.alert)
                alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.default, handler: nil))
                self.present(alert, animated: true, completion: nil)
                self.emailTextField.text = ""
            } else {
                let alert = UIAlertController(title: "Password Reset", message: "An email containing a reset link was sent to your email.",
                                              preferredStyle: UIAlertControllerStyle.alert)
                alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.default, handler: nil))
                self.present(alert, animated: true, completion: nil)
                self.emailTextField.text = ""
            }
        }
    }
    
    func handleBack() {
        dismiss(animated: true, completion: nil)
    }

}
