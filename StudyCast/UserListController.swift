//
//  UserListController.swift
//  StudyCast
//
//  Created by Dennis Huebert on 2016-11-19.
//  Copyright © 2016 Apollo. All rights reserved.
//

import UIKit
import Firebase

class UserListController: UITableViewController {

    //var usersInClass = [ChatUser]()
    var usersInClass: [ChatUser] = []
    var selectedUsers: [ChatUser] = []
    var className = "ENSC 351"
    var notificationSender = NotificationSender()
    var i = 0
    var groupInfo: Group = Group()
    var senderName: String = ""
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        fetchUsers()
        setName()
        self.navigationController?.navigationBar.barTintColor = UIColor(r: 61, g: 91, b: 151)
        self.navigationController?.navigationBar.tintColor = UIColor.white
        let titleDict: NSDictionary = [NSForegroundColorAttributeName: UIColor.white]
        self.navigationController?.navigationBar.titleTextAttributes = titleDict as? [String : Any]
        self.navigationItem.title = "Invite Classmates"
        //navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Back", style: .plain, target: self, action: #selector(handleBack))
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Send", style: .plain, target: self, action: #selector(handleSend))
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Skip", style: .plain, target: self, action: #selector(handleSkip))
        tableView.register(GroupCell.self, forCellReuseIdentifier: "userCell")
    }
    
    func fetchUsers() {
        var userIds = [String]()
        let ref = FIRDatabase.database().reference().child(self.className)
        var userRef = FIRDatabase.database().reference().child(self.className).child("users")
        let loggedInUser = FIRAuth.auth()?.currentUser
        let loggedInUserUid = loggedInUser?.uid
        ref.observe(.value, with: { (snapshot) in
            if let userDictionary = snapshot.value as? [String: AnyObject]{
                userIds = Array(userDictionary.keys)
                for uid in userIds {
                    userRef = FIRDatabase.database().reference().child("users").child(uid)
                    userRef.observe(.value, with: { (snapshot) in
                        if let nameDictionary = snapshot.value as? [String: AnyObject]{
                            let userInClass = ChatUser()
                            var added = false
                            if self.groupInfo.users != nil {
                                for user in self.groupInfo.users! {
                                    if user == uid {
                                        added = true
                                    }
                                }
                            }
                            if !added {
                                if loggedInUserUid != uid {
                                    userInClass.name = nameDictionary["name"] as? String
                                    userInClass.uid = uid
                                    userInClass.profileURL = nameDictionary["profileImage"] as? String
                                    self.usersInClass.append(userInClass)
                                }
                                self.tableView.reloadData()
                            }

                        }
                    })
                }
            }
        })
    }
    
    func setInfoForInvite(cn: String, group: Group, sn: String) {
        self.className = cn
        self.senderName = sn
        self.groupInfo.name = group.name
        self.groupInfo.id = group.id
        self.groupInfo.photoUrl = group.photoUrl
        self.groupInfo.users = group.users
    }
    
    func handleBack() {
        dismiss(animated: true, completion: nil)
    }
    
    func handleSend() {
        

        notificationSender.gid = self.groupInfo.id
        notificationSender.groupName = self.groupInfo.name
        notificationSender.senderName = self.senderName
        notificationSender.groupPictureURL = self.groupInfo.photoUrl
        
        
        //let i: UInt = 0
        
        
        let loggedInUser = FIRAuth.auth()?.currentUser
        let loggedInUserUid = loggedInUser?.uid
        var userRef = FIRDatabase.database().reference().child("users")
        var notificationsRef = userRef
        if selectedUsers.count > 0 {
            for user in selectedUsers{
                userRef = userRef.child(user.uid!)
                notificationsRef = userRef.child("notifications")
                
                //notificationsRef = notificationsRef.child("\(i)")
                notificationsRef = notificationsRef.childByAutoId()
                let nid = notificationsRef.key
                notificationsRef.updateChildValues(["nid" : nid])
                notificationsRef.updateChildValues(["gid": self.notificationSender.gid!])
                notificationsRef.updateChildValues(["senderName" : self.notificationSender.senderName!])
                notificationsRef.updateChildValues(["groupName" : self.notificationSender.groupName!])
                notificationsRef.updateChildValues(["class" : self.className])
                notificationsRef.updateChildValues(["accepted" : "false"])
                notificationsRef.updateChildValues(["SenderUid" : loggedInUserUid!])
                //notificationsRef.updateChildValues(["groupPictureURL" : self.notificationSender.groupPictureURL!])
                userRef = FIRDatabase.database().reference().child("users")
                notificationsRef = userRef
            }
             self.view.window!.rootViewController?.dismiss(animated: true, completion: nil)
        }
    }
    
    func handleSkip() {
        self.view.window!.rootViewController?.dismiss(animated: true, completion: nil)
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
    
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let cell = tableView.cellForRow(at: indexPath)
        let user = usersInClass[indexPath.row]
        user.selected = !user.selected
        if user.selected {
            cell?.accessoryType = UITableViewCellAccessoryType.checkmark
            selectedUsers.append(user)
        } else {
            cell?.accessoryType = UITableViewCellAccessoryType.none
            while selectedUsers.contains(user) {
                if let itemToRemoveIndex = selectedUsers.index(of: user) {
                    selectedUsers.remove(at: itemToRemoveIndex)
                }
            }
        }
    }
    
    func setName() {
        guard let uid = FIRAuth.auth()?.currentUser?.uid else {
            return
        }
        FIRDatabase.database().reference().child("users").child(uid).child("name").observe(.value, with: { (snapshot) in
            if let userN = snapshot.value as? String {
                self.senderName = userN
            }
        })
    }
}

class ChatUser: NSObject {
    var name: String?
    var uid: String?
    var profileURL: String?
    var selected = false
}

class NotificationSender: NSObject {
    var className: String?
    var gid: String?
    var groupName: String?
    var accepted: String?
    var senderName: String?
    var senderUid: String?
    var groupPictureURL: String?
    var nid: String?
}

