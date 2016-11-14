//
//  LoginController+handlers.swift
//  StudyCastv2
//
//  Created by Dennis on 2016-11-03.
//  Copyright © 2016 Apollo. All rights reserved.
//

import UIKit
import Firebase

extension LoginController {
    
    func handleLogin() {
        
        guard let email = emailTextField.text, let password = passwordTextField.text else {
            print("Form is not valid")
            return
        }
        
        FIRAuth.auth()?.signIn(withEmail: email, password: password, completion: { (user, error) in
            if error != nil{
                print(error!)
                return
            }
            self.dismiss(animated: true, completion: nil)
        })
    }
    
    func handlePasswordReset() {
    
    }
    
    func handleRegisterNewUser() {
        let registerController = RegisterController()
        present(registerController, animated: true, completion: nil)
    }
}
