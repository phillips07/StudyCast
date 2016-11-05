//
//  LoginController.swift
//  StudyCastv2
//
//  Created by Dennis on 2016-11-03.
//  Copyright © 2016 Apollo. All rights reserved.
//

import UIKit

class LoginController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = UIColor(r: 61, g: 91, b: 151)
        
        view.addSubview(emailTextField)
        view.addSubview(passwordTextField)
        view.addSubview(profileImageView)
        view.addSubview(emailImageView)
        view.addSubview(passwordImageView)
        view.addSubview(loginButton)
        view.addSubview(passwordResetButton)
        view.addSubview(registerNewUserButton)
        view.addSubview(registerNewUserSeperatorView)
        
        setupEmailTextField()
        setupPasswordTextField()
        setupProfileImageView()
        setupEmailImageView()
        setupPasswordImageView()
        setupLoginButton()
        setupPasswordResetButton()
        setupRegisterNewUserButton()
        setupRegisterNewUserSeperatorView()
    }
    
    let emailTextField: UITextField = {
        let tf = UITextField()
        tf.placeholder = " Email Address"
        tf.translatesAutoresizingMaskIntoConstraints = false
        return tf
    }()
    
    let passwordTextField: UITextField = {
        let tf = UITextField()
        tf.placeholder = " Password"
        tf.translatesAutoresizingMaskIntoConstraints = false
        tf.isSecureTextEntry = true
        return tf
    }()
    
    lazy var profileImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "studyCast_book3")
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFill
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
        imageView.image = UIImage(named: "profile")
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFill
        return imageView
    }()
    
    lazy var loginButton: UIButton = {
        let button = UIButton(type: .system)
        button.backgroundColor = UIColor(r: 80, g: 101, b: 161)
        button.setTitle("Login", for: UIControlState())
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitleColor(UIColor.white, for: UIControlState())
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 16)
        
        button.addTarget(self, action: #selector(handleLogin), for: .touchUpInside)
        
        return button
    }()
    
    lazy var passwordResetButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Forgot your password?", for: UIControlState())
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitleColor(UIColor.white, for: UIControlState())
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 12)
        button.addTarget(self, action: #selector(handlePasswordReset), for: .touchUpInside)
        return button
    }()
    
    lazy var registerNewUserButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Don't have an account? Sign Up", for: UIControlState())
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitleColor(UIColor.white, for: UIControlState())
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 12)
        button.addTarget(self, action: #selector(handleRegisterNewUser), for: .touchUpInside)
        return button
    }()
    
    let registerNewUserSeperatorView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(r: 80, g: 101, b: 161)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    

    func setupEmailTextField(){
        emailTextField.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        emailTextField.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: -20).isActive = true
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
        profileImageView.bottomAnchor.constraint(equalTo: emailTextField.centerYAnchor, constant: -70).isActive = true
        profileImageView.widthAnchor.constraint(equalToConstant: 170).isActive = true
        profileImageView.heightAnchor.constraint(equalToConstant: 170).isActive = true
    }
    
    func setupEmailImageView(){
        emailImageView.centerXAnchor.constraint(equalTo: emailTextField.leftAnchor, constant: -20).isActive = true
        emailImageView.centerYAnchor.constraint(equalTo: emailTextField.centerYAnchor, constant: 3).isActive = true
        emailImageView.widthAnchor.constraint(equalToConstant: 40).isActive = true
        emailImageView.heightAnchor.constraint(equalToConstant: 40).isActive = true
    }
    
    func setupPasswordImageView(){
        passwordImageView.centerXAnchor.constraint(equalTo: passwordTextField.leftAnchor, constant: -20).isActive = true
        passwordImageView.centerYAnchor.constraint(equalTo: passwordTextField.centerYAnchor, constant: 3).isActive = true
        passwordImageView.widthAnchor.constraint(equalToConstant: 40).isActive = true
        passwordImageView.heightAnchor.constraint(equalToConstant: 40).isActive = true
    }
    
    func setupLoginButton(){
        loginButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        loginButton.topAnchor.constraint(equalTo: passwordTextField.bottomAnchor, constant: 20).isActive = true
        loginButton.widthAnchor.constraint(equalTo: passwordTextField.widthAnchor).isActive = true
        loginButton.heightAnchor.constraint(equalToConstant: 45).isActive = true
    }
    
    func setupPasswordResetButton(){
        passwordResetButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        passwordResetButton.topAnchor.constraint(equalTo: loginButton.bottomAnchor, constant: 10).isActive = true
    }
    
    func setupRegisterNewUserButton(){
        registerNewUserButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        registerNewUserButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -20).isActive = true
    }
    
    func setupRegisterNewUserSeperatorView(){
        registerNewUserSeperatorView.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        registerNewUserSeperatorView.widthAnchor.constraint(equalTo: view.widthAnchor).isActive = true
        registerNewUserSeperatorView.bottomAnchor.constraint(equalTo: registerNewUserButton.topAnchor, constant: -7).isActive = true
        registerNewUserSeperatorView.heightAnchor.constraint(equalToConstant: 1).isActive = true
    }
    
    override var preferredStatusBarStyle : UIStatusBarStyle {
        return .lightContent
    }
}

extension UIColor {
    convenience init(r: CGFloat, g: CGFloat, b: CGFloat) {
        self.init(red: r/255, green: g/255, blue: b/255, alpha: 1)
    }
}
