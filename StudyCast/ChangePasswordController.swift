//
//  ChangePasswordController.swift
//  StudyCast
//
//  Created by Dennis Huebert on 2016-11-16.
//  Copyright © 2016 Austin Phillips. All rights reserved.
//

import UIKit
import Firebase

class ChangePasswordController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor(r: 61, g: 91, b: 151)
        self.navigationController?.navigationBar.barTintColor = UIColor(r: 61, g: 91, b: 151)
        self.navigationController?.navigationBar.tintColor = UIColor.white
        self.navigationItem.title = "Password"
        
        view.addSubview(currentPasswordTextField)
        view.addSubview(newPasswordTextField)
        view.addSubview(confirmNewPasswordTextField)
        view.addSubview(logoImageView)
        view.addSubview(confirmButton)
        
        setupCurrentPasswordTextField()
        setupNewPasswordTextField()
        setupConfrimNewPasswordTextField()
        setupLogoImageView()
        setupConfirmButton()
    }
    
    let currentPasswordTextField: UITextField = {
        let tf = UITextField()
        tf.placeholder = " Current Password"
        tf.translatesAutoresizingMaskIntoConstraints = false
        tf.isSecureTextEntry = true
        tf.backgroundColor = UIColor.white
        tf.layer.cornerRadius = 6.0
        return tf
    }()
    
    let newPasswordTextField: UITextField = {
        let tf = UITextField()
        tf.placeholder = " New Password"
        tf.translatesAutoresizingMaskIntoConstraints = false
        tf.isSecureTextEntry = true
        tf.backgroundColor = UIColor.white
        tf.layer.cornerRadius = 6.0
        return tf
    }()
    
    let confirmNewPasswordTextField: UITextField = {
        let tf = UITextField()
        tf.placeholder = " Confirm Password"
        tf.translatesAutoresizingMaskIntoConstraints = false
        tf.isSecureTextEntry = true
        tf.backgroundColor = UIColor.white
        tf.layer.cornerRadius = 6.0
        return tf
    }()
    
    lazy var logoImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "studyCast_book3")
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFill
        return imageView
    }()
    
    lazy var confirmButton: UIButton = {
        let button = UIButton(type: .system)
        button.backgroundColor = UIColor(r: 80, g: 101, b: 161)
        button.setTitle("Confirm", for: UIControlState())
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitleColor(UIColor.white, for: UIControlState())
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 16)
        
        button.addTarget(self, action: #selector(handleConfirmation), for: .touchUpInside)
        
        return button
    }()
    
    func setupCurrentPasswordTextField() {
        currentPasswordTextField.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        currentPasswordTextField.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: -20).isActive = true
        currentPasswordTextField.widthAnchor.constraint(equalTo: view.widthAnchor, constant: -140).isActive = true
        currentPasswordTextField.heightAnchor.constraint(equalToConstant: 35).isActive = true
    }
    
    func setupNewPasswordTextField() {
        newPasswordTextField.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        newPasswordTextField.topAnchor.constraint(equalTo: currentPasswordTextField.bottomAnchor, constant: 15).isActive = true
        newPasswordTextField.widthAnchor.constraint(equalTo: currentPasswordTextField.widthAnchor).isActive = true
        newPasswordTextField.heightAnchor.constraint(equalToConstant: 35).isActive = true
    }
    
    func setupConfrimNewPasswordTextField() {
        confirmNewPasswordTextField.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        confirmNewPasswordTextField.topAnchor.constraint(equalTo: newPasswordTextField.bottomAnchor, constant: 15).isActive = true
        confirmNewPasswordTextField.widthAnchor.constraint(equalTo: currentPasswordTextField.widthAnchor).isActive = true
        confirmNewPasswordTextField.heightAnchor.constraint(equalToConstant: 35).isActive = true
    }
    
    func setupLogoImageView() {
        logoImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        logoImageView.bottomAnchor.constraint(equalTo: currentPasswordTextField.centerYAnchor, constant: -50).isActive = true
        logoImageView.widthAnchor.constraint(equalToConstant: 170).isActive = true
        logoImageView.heightAnchor.constraint(equalToConstant: 170).isActive = true
    }
    
    func setupConfirmButton(){
        confirmButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        confirmButton.topAnchor.constraint(equalTo: confirmNewPasswordTextField.bottomAnchor, constant: 20).isActive = true
        confirmButton.widthAnchor.constraint(equalTo: currentPasswordTextField.widthAnchor).isActive = true
        confirmButton.heightAnchor.constraint(equalToConstant: 45).isActive = true
    }
    
    func handleConfirmation() {
        guard let currentPassword =  currentPasswordTextField.text, let newPassword = newPasswordTextField.text,
            let confirmPassword = confirmNewPasswordTextField.text else {
            print("Form is not valid")
            return
        }
        
        let user = FIRAuth.auth()?.currentUser
        let credential = FIREmailPasswordAuthProvider.credential(withEmail: (user?.email)!, password: currentPassword)
        
        user?.reauthenticate(with: credential) { error in
            if let error = error {
                print(error)
            } else {
                if newPassword == confirmPassword {
                    user?.updatePassword(newPassword, completion: { (error) in
                        if let error = error {
                            print(error)
                        } else {
                            //dismiss view, password has been updated
                            self.dismiss(animated: true, completion: nil)
                        }
                    })
                } else {
                    print("Passwords do not match")
                }
            }
        }
    }
}



