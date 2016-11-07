//
//  ClassSelectController+handlers.swift
//  StudyCastv2
//
//  Created by Dennis on 2016-11-04.
//  Copyright © 2016 Apollo. All rights reserved.
//

import UIKit
import Firebase


extension ClassSelectController {
    
    func handleDone() {
        if let user = FIRAuth.auth()?.currentUser {
            let uid = user.uid
            self.addUserCourses(uid, values: pickedClassesDataSet.indexedDictionary)
        } else {
            print("User is not currently signed in")
        }
    }
    
    /*func handleBack(){
        let registerController = RegisterController()
        present(registerController, animated: true, completion: nil)
    }*/
    
    fileprivate func addUserCourses(_ uid: String, values: [String : AnyObject]) {
        
        let ref = FIRDatabase.database().reference(fromURL: "https://studycast-11ca5.firebaseio.com")
        let coursesReference = ref.child("users").child(uid).child("courses")
        print(coursesReference)
        coursesReference.updateChildValues(values, withCompletionBlock: { (err, ref) in
            if err != nil{
                print(err)
                return
            } else {
                self.view.window!.rootViewController?.dismiss(animated: false, completion: nil)
            }
        })
    }
    
    func handleTap(recognizer: UITapGestureRecognizer){

        if recognizer.state == UIGestureRecognizerState.ended {
            let tapLocation = recognizer.location(in: self.facultyTableView)
            if let tapIndexPath = self.facultyTableView.indexPathForRow(at: tapLocation) {
                if let tappedCell = self.facultyTableView.cellForRow(at: tapIndexPath) as? UserCell {
                    
                    var i = numCells - 1
                    var added = false
                    while i >= 0 {
                        if ((tappedCell.textLabel?.text)! == pickedClassesDataSet[i]) {
                            added = true
                            break
                        }
                        i -= 1
                    }
                    
                    if !added {
                        //print("****************************")
                    
                        numCells += 1
                        //print(numCells)
                        //print((tappedCell.textLabel?.text)!)
                        pickedClassesDataSet.append((tappedCell.textLabel?.text)!)
                    
                        //print(pickedClassesDataSet)
                        userClassesTableView.reloadData()
                        
                    }
                }
            }
        }
    }
}
