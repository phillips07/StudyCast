//
//  AddGroupController+handlers.swift
//  StudyCast
//
//  Created by Dennis Huebert on 2016-11-18.
//  Copyright © 2016 Austin Phillips. All rights reserved.
//

import UIKit
import Firebase


extension AddGroupController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {

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
            groupImageView.image = selectedImage
            groupImageView.layer.cornerRadius = groupImageView.frame.size.width/2
            groupImageView.clipsToBounds = true
        }
        
        dismiss(animated: true, completion: nil)
    }
    
    func fetchClasses() {
        userCourses.removeAll()
        let uid = FIRAuth.auth()?.currentUser?.uid
        FIRDatabase.database().reference().child("users").child(uid!).child("courses").observe(.childAdded, with: { (snapshot) in
            self.userCourses.append(snapshot.value as! String)
        })
    }
    
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return userCourses.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return userCourses[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, rowHeightForComponent component: Int) -> CGFloat {
        return 20
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        
    }
    
    func handleDone() {
    
        /*guard let groupName = nameTextField.text else {
            print("Form is not valid")
            return
        }
        
        let gid = UUID().uuidString
        let user = FIRAuth.auth()?.currentUser
        let uid = user?.uid
        let ref = FIRDatabase.database().reference(fromURL: "https://studycast-11ca5.firebaseio.com")
        let groupUsersRef = ref.child("groups").child(gid).child("users")
        groupUsersRef.updateChildValues([uid! : user?.displayName as Any])
        
        
        let groupImageName = UUID().uuidString
        let storage = FIRStorage.storage().reference().child("groupImages").child("\(groupImageName).jpg")
        if let imageToUpload = UIImageJPEGRepresentation(self.groupImageView.image!, 0.1) {
            storage.put(imageToUpload, metadata: nil, completion: { (metadata, error) in
                if error != nil {
                    print(error!)
                    return
                }
            })
        }*/
        
        dismiss(animated: true, completion: nil)
    }
}
