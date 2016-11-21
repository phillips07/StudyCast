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

    //var usersInClass = [ChatUser]()
    var usersInClass: [ChatUser] = []
    var className = String()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        fetchUser()

        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Back", style: .plain, target: self, action: #selector(handleBack))
        tableView.register(GroupCell.self, forCellReuseIdentifier: "userCell")
        
    }
    
    func fetchUser() {
        self.className = "ENSC 351"
        var userIds = [String]()
        let ref = FIRDatabase.database().reference().child(self.className)
        var userRef = FIRDatabase.database().reference().child(self.className).child("users")
        ref.observe(.value, with: { (snapshot) in
            if let userDictionary = snapshot.value as? [String: AnyObject]{
                userIds = Array(userDictionary.keys)
                for uid in userIds {
                    userRef = FIRDatabase.database().reference().child("users").child(uid)
                    userRef.observe(.value, with: { (snapshot) in
                        if let nameDictionary = snapshot.value as? [String: AnyObject]{
                            let userInClass = ChatUser()
                            userInClass.name = nameDictionary["name"] as? String
                            userInClass.uid = uid
                            userInClass.profileURL = nameDictionary["profileImage"] as? String
                            self.usersInClass.append(userInClass)
                            self.tableView.reloadData()
                        }
                    })
                }
            }
        })
    }
    
    func handleBack() {
        dismiss(animated: true, completion: nil)
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let numRows = usersInClass.count
        
        return numRows
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "userCell", for: indexPath) as! GroupCell
        cell.textLabel?.text = usersInClass[indexPath.row].name
        return cell
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
}

class ChatUser: NSObject {
    var name: String?
    var uid: String?
    var profileURL: String?
}
