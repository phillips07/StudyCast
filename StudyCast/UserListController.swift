//
//  UserListController.swift
//  StudyCast
//
//  Created by Dennis Huebert on 2016-11-19.
//  Copyright © 2016 Austin Phillips. All rights reserved.
//

import UIKit
import Firebase

class UserListController: UITableViewController {

    var users = [ChatUser]()
    let cellId = "cellId"
    var userNames = [String]()
    var className = String()
    //bool finished = false
    var finished = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Back", style: .plain, target: self, action: #selector(handleBack))
        
        fetchUser()
        while !(finished) {
            sleep(UInt32(0.1))
        }
        print(self.userNames)
    }
    
    func fetchUser() {
        self.className = "ENSC 351"
        var userIds = [String]()
        
        //var finished2 = false
        
        //var localNames = [String]()
        let ref = FIRDatabase.database().reference().child(self.className)
        var userRef = FIRDatabase.database().reference().child(self.className).child("users")
        ref.observe(.value, with: { (snapshot) in
            if let userDictionary = snapshot.value as? [String: AnyObject]{
                userIds = Array(userDictionary.keys)
                //self.userNames = self.storeUsersInArray(uids: userIds)
                
                //print(userIds)
                for uid in userIds {
                    //print(uid)
                    userRef = FIRDatabase.database().reference().child("users").child(uid)
                    userRef.observe(.value, with: { (snapshot) in
                        
                        //print(snapshot)
                        if let nameDictionary = snapshot.value as? [String: AnyObject]{
                            self.userNames.append(nameDictionary["name"] as! String)
                            //let test = self.userNames
                            //print(self.userNames)
                        }
                        print(self.userNames)
                        
                        if self.userNames.count == userIds.count{
                            self.finished = true
                        }
                    })
                }
                /*self.storeUsersInArray(uids: userIds, completion: {success in
                    //if success {
                        localNames = success
                        print(localNames)
                    //}
                })*/
            }
        })
        while !finished{
            sleep(UInt32(0.1))
        }
        //finished = true
    }
    
    
    /*func storeUsersInArray(uids: [String], completion: ([String]) -> ()) {
        //userIds = Array(userDictionary.keys)
        //print(userIds)
        var local = [String]()
        var userRef = FIRDatabase.database().reference().child(self.className).child("users")
        for uid in uids {
            //print(uid)
            userRef = FIRDatabase.database().reference().child("users").child(uid)
            userRef.observe(.value, with: { (snapshot) in
                
                //print(snapshot)
                if let nameDictionary = snapshot.value as? [String: AnyObject]{
                    local.append(nameDictionary["name"] as! String)
                    //let test = self.userNames
                    //print(self.userNames)
                }
                //print(local)
            })
        }
        completion(local)
    }*/
    
    
    func handleBack() {
        dismiss(animated: true, completion: nil)
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 5
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .subtitle, reuseIdentifier: cellId)
        cell.textLabel?.text = "asdafasf"
        return cell
    }
}

class ChatUser: NSObject {
    var name: String?
    var email: String?
    var courses: [String]?
    var uid: String?
}
