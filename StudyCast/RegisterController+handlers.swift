//
//  RegisterController+handlers.swift
//  StudyCast
//
//  Created by Dennis on 2016-11-03.
//  Copyright © 2016 Apollo. All rights reserved.
//

import UIKit
import Firebase

extension RegisterController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func handleSelectProfileImageView() {
        let picker = UIImagePickerController()
        
        picker.delegate = self
        picker.allowsEditing = true
        
        present(picker, animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        
        var selectedImageFromPicker: UIImage?
        
        if let editedImage = info["UIImagePickerControllerEditedImage"] as? UIImage{
            selectedImageFromPicker = editedImage
        } else if let originalImage = info["UIImagePickerControllerOriginalImage"] as? UIImage{
            selectedImageFromPicker = originalImage
        }
        
        if let selectedImage = selectedImageFromPicker {
            profileImageView.image = selectedImage
            profileImageView.layer.cornerRadius = profileImageView.frame.size.width/2
            profileImageView.clipsToBounds = true
        }
        
        dismiss(animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
    
    func handleBack() {
        dismiss(animated: false, completion: nil)
    }
    
    func handleClassSelection() {
        guard let email = emailTextField.text, let password = passwordTextField.text, let name = nameTextField.text else {
            print("Form is not valid")
            return
        }
        
        
        FIRAuth.auth()?.createUser(withEmail: email, password: password, completion: { (user: FIRUser?, error) in
            if error != nil {
                print(error)
                return
            }
            
            guard let uid = user?.uid else {
                return
            }
            
            let profileName = UUID().uuidString
            let storage = FIRStorage.storage().reference().child("profileImages").child("\(profileName).png")
            if let imageToUpload = UIImagePNGRepresentation(self.profileImageView.image!) {
                storage.put(imageToUpload, metadata: nil, completion: { (metadata, error) in
                    if error != nil {
                        print(error)
                        return
                    }
                    
                    if let profileImage = metadata?.downloadURL()?.absoluteString {
                        let values = ["name": name, "email": email, "profileImage": profileImage]
                        self.registerUser(uid, values: values as [String : AnyObject])
                    }
                    print(metadata)
                })
            }
        })
    }
    
    fileprivate func registerUser(_ uid: String, values: [String : AnyObject]) {
        
        let ref = FIRDatabase.database().reference(fromURL: "https://studycast-d3bf9.firebaseio.com/")
        let usersReference = ref.child("users").child(uid)
        usersReference.updateChildValues(values, withCompletionBlock: { (err, ref) in
            if err != nil{
                print(err)
                return
            } else {
                //Need to add code here to move current view to the class selection view (replace the line below)
                let classSelectController = ClassSelectController()
                self.present(classSelectController, animated: true, completion: nil)
            }
        })
    }
}
