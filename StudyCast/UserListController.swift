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
    let cellId = "cellId"
    var userNames = [String]()
    var className = String()
    let group = DispatchGroup()
    let queue = DispatchQueue(label: "com.allaboutswift.dispatchgroup", attributes: .concurrent, target: .main)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
       // self.group.enter()
        //queue.async (group: self.group) {
            fetchUser()
        //    self.group.leave()
       // }
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Back", style: .plain, target: self, action: #selector(handleBack))
        tableView.register(GroupCell.self, forCellReuseIdentifier: "groupCell")
        
        /*/group.notify(queue: DispatchQueue.main) {
            self.tableView.reloadData()
        }*/
    }
    
    
    func fetchUser() {
        self.className = "ENSC 351"
        var userIds = [String]()

        let ref = FIRDatabase.database().reference().child(self.className)
        var userRef = FIRDatabase.database().reference().child(self.className).child("users")
        ref.observe(.value, with: { (snapshot) in
            if let userDictionary = snapshot.value as? [String: AnyObject]{
                userIds = Array(userDictionary.keys)
                //self.userNames = self.storeUsersInArray(uids: userIds)
                
                //print(userIds)
                for uid in userIds {
                    userRef = FIRDatabase.database().reference().child("users").child(uid)
                    userRef.observe(.value, with: { (snapshot) in
                        //print(snapshot)
                        if let nameDictionary = snapshot.value as? [String: AnyObject]{
                            self.userNames.append(nameDictionary["name"] as! String)
                            let userInClass = ChatUser()
                            userInClass.name = nameDictionary["name"] as? String
                            userInClass.uid = uid
                            userInClass.profileURL = nameDictionary["profileImage"] as? String
                            self.usersInClass.append(userInClass)
                            //self.tableView.reloadData()
                        }
                        print(self.userNames)
                    })
                    //print(self.userNames)

                }
                self.tableView.reloadData()
            }
        })
    }
    
    /*override func viewWillAppear(_ animated: Bool) {
        fetchUser()
    }*/
    
    func handleBack() {
        dismiss(animated: true, completion: nil)
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let numRows = usersInClass.count
        
        return numRows
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "userCell", for: indexPath) as! GroupCell
        cell.nameLabel.text = usersInClass[indexPath.row].name
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
