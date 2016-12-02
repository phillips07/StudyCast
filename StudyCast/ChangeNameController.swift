//
//  ChangePasswordController.swift
//  StudyCast
//
//  Created by Ziyi Zhao on 2016-11-19.
//  Copyright © 2016 Austin Phillips. All rights reserved.
//

import UIKit
import Firebase

class ChangeNameController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.hideKeyboardWhenTappedAround()
        view.backgroundColor = UIColor(r: 61, g: 91, b: 151)
        self.navigationController?.navigationBar.barTintColor = UIColor(r: 61, g: 91, b: 151)
        self.navigationController?.navigationBar.tintColor = UIColor.white
        self.navigationItem.title = "Name"
        
        view.addSubview(currentPasswordTextField)
        view.addSubview(newNameTextField)
        view.addSubview(confirmNewNameTextField)
        view.addSubview(confirmButton)
        //view.addSubview(logoImageView)
        
        setupCurrentPasswordTextField()
        setupNewNameTextField()
        setupConfrimNewNameTextField()
        //setupLogoImageView()
        setupConfirmButton()
    }
    
    /**********************************************************************************************************/
    /****************************************** Text Field & Bottom ******************************************/
    /********************************************************************************************************/
    
    let currentPasswordTextField: UITextField = {
        let tf = UITextField()
        tf.placeholder = " Current Password"
        tf.translatesAutoresizingMaskIntoConstraints = false
        tf.isSecureTextEntry = true
        tf.backgroundColor = UIColor.white
        tf.layer.cornerRadius = 6.0
        return tf
    }()
    
    let newNameTextField: UITextField = {
        let tf = UITextField()
        tf.placeholder = " New Name"
        tf.translatesAutoresizingMaskIntoConstraints = false
        tf.isSecureTextEntry = false
        tf.backgroundColor = UIColor.white
        tf.layer.cornerRadius = 6.0
        return tf
    }()
    
    let confirmNewNameTextField: UITextField = {
        let tf = UITextField()
        tf.placeholder = " Confirm New Name"
        tf.translatesAutoresizingMaskIntoConstraints = false
        tf.isSecureTextEntry = false
        tf.backgroundColor = UIColor.white
        tf.layer.cornerRadius = 6.0
        return tf
    }()
    
    /*
    lazy var logoImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "studyCast_book3")
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFill
        return imageView
    }()
    */
    
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
    
    /*****************************************************************************************************/
    /****************************************** Setup Function ******************************************/
    /***************************************************************************************************/
    
    func setupNewNameTextField() {
        newNameTextField.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        newNameTextField.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: -60).isActive = true
        newNameTextField.bottomAnchor.constraint(equalTo: newNameTextField.topAnchor, constant: 40).isActive = true
        newNameTextField.widthAnchor.constraint(equalTo: view.widthAnchor, constant: -140).isActive = true
        newNameTextField.heightAnchor.constraint(equalToConstant: 35).isActive = true
        
        /*
         currentPasswordTextField.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
         currentPasswordTextField.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: -20).isActive = true
         currentPasswordTextField.widthAnchor.constraint(equalTo: view.widthAnchor, constant: -140).isActive = true
         currentPasswordTextField.heightAnchor.constraint(equalToConstant: 35).isActive = true
        */
    }
    
    func setupConfrimNewNameTextField() {
        confirmNewNameTextField.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        confirmNewNameTextField.topAnchor.constraint(equalTo: newNameTextField.bottomAnchor, constant: 15).isActive = true
        currentPasswordTextField.bottomAnchor.constraint(equalTo: currentPasswordTextField.topAnchor, constant: 40).isActive = true
        confirmNewNameTextField.widthAnchor.constraint(equalTo: view.widthAnchor, constant: -140).isActive = true
        confirmNewNameTextField.heightAnchor.constraint(equalToConstant: 35).isActive = true
    }
    
    func setupCurrentPasswordTextField() {
        currentPasswordTextField.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        currentPasswordTextField.topAnchor.constraint(equalTo: confirmNewNameTextField.bottomAnchor, constant: 15).isActive = true
        currentPasswordTextField.bottomAnchor.constraint(equalTo: currentPasswordTextField.topAnchor, constant: 40).isActive = true
        currentPasswordTextField.widthAnchor.constraint(equalTo: view.widthAnchor, constant: -140).isActive = true
        currentPasswordTextField.heightAnchor.constraint(equalToConstant: 35).isActive = true
        
        /*
         newPasswordTextField.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
         newPasswordTextField.topAnchor.constraint(equalTo: currentPasswordTextField.bottomAnchor, constant: 15).isActive = true
         newPasswordTextField.widthAnchor.constraint(equalTo: currentPasswordTextField.widthAnchor).isActive = true
         newPasswordTextField.heightAnchor.constraint(equalToConstant: 35).isActive = true
        */
        
    }
    
    /*
    func setupLogoImageView() {
        logoImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        logoImageView.bottomAnchor.constraint(equalTo: currentPasswordTextField.centerYAnchor, constant: -50).isActive = true
        logoImageView.widthAnchor.constraint(equalToConstant: 170).isActive = true
        logoImageView.heightAnchor.constraint(equalToConstant: 170).isActive = true
     }
    */
    
    func setupConfirmButton(){
        confirmButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        confirmButton.topAnchor.constraint(equalTo: currentPasswordTextField.bottomAnchor, constant: 25).isActive = true
        confirmButton.widthAnchor.constraint(equalTo: currentPasswordTextField.widthAnchor).isActive = true
        confirmButton.heightAnchor.constraint(equalToConstant: 45).isActive = true
    }
    
    /*******************************************************************************************************/
    /****************************************** Handler Function ******************************************/
    /*****************************************************************************************************/
    
    func handleConfirmation() {
        guard let currentPassword =  currentPasswordTextField.text , let newName = newNameTextField.text,
                let confirmName = confirmNewNameTextField.text
                /* let confirmPassword = confirmNewPasswordTextField.text*/ else {
                print("Form is not valid")
                return
        }
        
        var ref: FIRDatabaseReference!
        ref = FIRDatabase.database().reference()
        let user = FIRAuth.auth()?.currentUser
        let userID = FIRAuth.auth()?.currentUser?.uid
        let credential = FIREmailPasswordAuthProvider.credential(withEmail: (user?.email)!, password: currentPassword)
        
        user?.reauthenticate(with: credential) { error in
            if let error = error {
                print(error)
                let alertController = UIAlertController(title: "Wrong Password", message:
                    "Please Try Again", preferredStyle: UIAlertControllerStyle.alert)
                alertController.addAction(UIAlertAction(title: "Dismiss", style: UIAlertActionStyle.default,handler: nil))
                
                self.present(alertController, animated: true, completion: nil)
            }
                
            else if newName == "" || newName != confirmName{
                //print(error)
                let alertController = UIAlertController(title: "Input Not Valid", message:
                    "Please Try Again", preferredStyle: UIAlertControllerStyle.alert)
                alertController.addAction(UIAlertAction(title: "Dismiss", style: UIAlertActionStyle.default,handler: nil))
                
                self.present(alertController, animated: true, completion: nil)
            }
            
            else {
            ref.child("users").child(userID!).updateChildValues(["name": newName])
            self.dismiss(animated: true)
            }
        }
    }
}
