//
//  RegisterController.swift
//  StudyCast
//
//  Created by Dennis on 2016-11-02.
//  Copyright © 2016 Apollo. All rights reserved.
//

import UIKit

class RegisterController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
    
        view.backgroundColor = UIColor(r: 61, g: 91, b: 151)
        
        view.addSubview(nameTextField)
        view.addSubview(emailTextField)
        view.addSubview(passwordTextField)
        view.addSubview(profileImageView)
        view.addSubview(passwordImageView)
        view.addSubview(emailImageView)
        view.addSubview(nameImageView)
        view.addSubview(registerButton)
        view.addSubview(cancelButton)
        view.addSubview(termsAndConditionsLabel)
        
        setupNameTextField()
        setupEmailTextField()
        setupPasswordTextField()
        setupProfileImageView()
        setupPasswordImageView()
        setupEmailImageView()
        setupNameImageView()
        setupRegisterButton()
        setupBackButton()
        setupTermsAndConditionsLabel()
    }
    
    let nameTextField: UITextField = {
        let tf = UITextField()
        tf.placeholder = " Name"
        tf.translatesAutoresizingMaskIntoConstraints = false
        return tf
    }()
    
    let emailTextField: UITextField = {
        let tf = UITextField()
        tf.placeholder = " Email Address"
        tf.translatesAutoresizingMaskIntoConstraints = false
        return tf
    }()
    
    let passwordTextField: UITextField = {
        let tf = UITextField()
        tf.placeholder = " Choose a Password"
        tf.translatesAutoresizingMaskIntoConstraints = false
        tf.isSecureTextEntry = true
        return tf
    }()
    
    lazy var profileImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "AddProfileImage3")
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.layer.cornerRadius = imageView.frame.size.width/2
        imageView.clipsToBounds = true
        imageView.contentMode = .scaleAspectFill
        
        imageView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleSelectProfileImageView)))
        imageView.isUserInteractionEnabled = true
        return imageView
    }()
    
    let passwordImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "lock")
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFill
        return imageView
    }()
    
    let emailImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "email")
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFill
        return imageView
    }()
    
    let nameImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "profile")
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFill
        return imageView
    }()
    
    lazy var registerButton: UIButton = {
        let button = UIButton(type: .system)
        button.backgroundColor = UIColor(r: 80, g: 101, b: 161)
        button.setTitle("Register", for: UIControlState())
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitleColor(UIColor.white, for: UIControlState())
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 16)
        
        button.addTarget(self, action: #selector(handleClassSelection), for: .touchUpInside)
        
        return button
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
    
    let termsAndConditionsLabel: UILabel = {
        let tac = UILabel()
        tac.text = "By registering, I accept the\nTerms of Service and Privacy Policy"
        tac.textAlignment = NSTextAlignment.center
        tac.textColor = UIColor.white
        tac.font = UIFont.boldSystemFont(ofSize: 12)
        tac.translatesAutoresizingMaskIntoConstraints = false
        tac.numberOfLines = 2
        return tac
    }()
    
    func setupNameTextField(){
        nameTextField.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        nameTextField.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: -20).isActive = true
        nameTextField.widthAnchor.constraint(equalTo: view.widthAnchor, constant: -140).isActive = true
        nameTextField.heightAnchor.constraint(equalToConstant: 35).isActive = true

        nameTextField.backgroundColor = UIColor.white
        nameTextField.layer.cornerRadius = 6.0
    }
    
    func setupEmailTextField(){
        emailTextField.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        emailTextField.topAnchor.constraint(equalTo: nameTextField.bottomAnchor, constant: 15).isActive = true
        emailTextField.widthAnchor.constraint(equalTo: view.widthAnchor, constant: -140).isActive = true
        emailTextField.heightAnchor.constraint(equalToConstant: 35).isActive = true
        
        emailTextField.backgroundColor = UIColor.white
        emailTextField.layer.cornerRadius = 6.0
    }
    
    func setupPasswordTextField(){
        passwordTextField.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        passwordTextField.topAnchor.constraint(equalTo: emailTextField.bottomAnchor, constant: 15).isActive = true
        passwordTextField.widthAnchor.constraint(equalTo: view.widthAnchor, constant: -140).isActive = true
        passwordTextField.heightAnchor.constraint(equalToConstant: 35).isActive = true
        
        passwordTextField.backgroundColor = UIColor.white
        passwordTextField.layer.cornerRadius = 6.0
    }
    
    func setupProfileImageView(){
        profileImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        profileImageView.bottomAnchor.constraint(equalTo: nameTextField.centerYAnchor, constant: -70).isActive = true
        profileImageView.widthAnchor.constraint(equalToConstant: 125).isActive = true
        profileImageView.heightAnchor.constraint(equalToConstant: 125).isActive = true
    }
    
    func setupNameImageView(){
        nameImageView.centerXAnchor.constraint(equalTo: nameTextField.leftAnchor, constant: -20).isActive = true
        nameImageView.centerYAnchor.constraint(equalTo: nameTextField.centerYAnchor, constant: 2).isActive = true
        nameImageView.widthAnchor.constraint(equalToConstant: 35).isActive = true
        nameImageView.heightAnchor.constraint(equalToConstant: 35).isActive = true
    }
    
    func setupEmailImageView(){
        emailImageView.centerXAnchor.constraint(equalTo: emailTextField.leftAnchor, constant: -20).isActive = true
        emailImageView.centerYAnchor.constraint(equalTo: emailTextField.centerYAnchor, constant: 2).isActive = true
        emailImageView.widthAnchor.constraint(equalToConstant: 20).isActive = true
        emailImageView.heightAnchor.constraint(equalToConstant: 20).isActive = true
    }
    
    func setupPasswordImageView(){
        passwordImageView.centerXAnchor.constraint(equalTo: passwordTextField.leftAnchor, constant: -20).isActive = true
        passwordImageView.centerYAnchor.constraint(equalTo: passwordTextField.centerYAnchor, constant: 2).isActive = true
        passwordImageView.widthAnchor.constraint(equalToConstant: 33).isActive = true
        passwordImageView.heightAnchor.constraint(equalToConstant: 33).isActive = true
    }
    
    func setupRegisterButton(){
        registerButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        registerButton.topAnchor.constraint(equalTo: passwordTextField.bottomAnchor, constant: 20).isActive = true
        registerButton.widthAnchor.constraint(equalTo: passwordTextField.widthAnchor).isActive = true
        registerButton.heightAnchor.constraint(equalToConstant: 45).isActive = true
    }
    
    func setupBackButton(){
        cancelButton.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 10).isActive = true
        cancelButton.topAnchor.constraint(equalTo: view.topAnchor, constant: 25).isActive = true
    }
    
    func setupTermsAndConditionsLabel() {
        termsAndConditionsLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        termsAndConditionsLabel.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -25).isActive = true
    }
    
    
    override var preferredStatusBarStyle : UIStatusBarStyle {
        return .lightContent
    }
}
