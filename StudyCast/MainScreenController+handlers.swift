//
//  MainScreenController+handlers.swift
//  StudyCast
//
//  Created by Dennis Huebert on 2016-11-17.
//  Copyright © 2016 Austin Phillips. All rights reserved.
//

import UIKit
import Firebase


extension MainScreenController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func handleSelectProfileImageView() {
        let picker = UIImagePickerController()
        
        picker.delegate = self
        picker.allowsEditing = true
        
        present(picker, animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        
        var selectedImageFromPicker: UIImage?
        let user = FIRAuth.auth()?.currentUser
        
        if let editedImage = info["UIImagePickerControllerEditedImage"] as? UIImage{
            selectedImageFromPicker = editedImage
        } else if let originalImage = info["UIImagePickerControllerOriginalImage"] as? UIImage{
            selectedImageFromPicker = originalImage
        }
        
        let profileImageName = UUID().uuidString
        let storage = FIRStorage.storage().reference().child("profileImages").child("\(profileImageName).jpg")
        if let imageToUpload = UIImageJPEGRepresentation(selectedImageFromPicker!, 0.1) {
            storage.put(imageToUpload, metadata: nil, completion: { (metadata, error) in
                if error != nil {
                    print(error!)
                    return
                }
                
                if let profileImage = metadata?.downloadURL()?.absoluteString {
                    let changeRequest = user?.profileChangeRequest()
                    changeRequest?.photoURL = NSURL(string: profileImage) as URL?
                    changeRequest?.commitChanges(completion: { (error) in
                        if let error = error {
                            print(error)
                        } else {
                            self.dismiss(animated: true, completion: nil)
                        }
                    })
                }
            })
        }
    }
}
