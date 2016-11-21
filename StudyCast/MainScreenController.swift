//
//  ViewController.swift
//  StudyCastv2
//
//  Created by Dennis on 2016-11-03.
//  Copyright © 2016 Apollo. All rights reserved.
//

import UIKit
import Firebase

class MainScreenController: UITableViewController {

    var userCourses = [String]()
    var userNotifications = [[String]]()
    var notificationSectionHeaders = [String]()
    var notificationSender = NotificationSender()
    var userName = String()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let image = UIImage(named: "SettingsIcon")
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(image: image, style: .plain, target: self, action: #selector(handleSettings))
        tableView.register(GroupCell.self, forCellReuseIdentifier: "userCell")
        tableView.register(Header.self, forHeaderFooterViewReuseIdentifier: "headerId")
        tableView.sectionHeaderHeight = 50
        self.navigationController?.navigationBar.barTintColor = UIColor(r: 61, g: 91, b: 151)
        self.tabBarController?.tabBar.barTintColor = UIColor(r: 61, g: 91, b: 151)
        
        //code to render the original icon (remove applied gray mask which is default)
        let aTabArray: [UITabBarItem] = (self.tabBarController?.tabBar.items)!
        for item in aTabArray {
            item.image = item.image?.withRenderingMode(UIImageRenderingMode.alwaysOriginal)
            item.imageInsets = UIEdgeInsetsMake(0, 0, 0, 0)
        }
        
        if FIRAuth.auth()?.currentUser?.uid == nil {
            perform(#selector(handleLogout), with: nil, afterDelay: 0)
        }
        userCourses.removeAll()
        fetchNotifications()
        fetchCurrentName()
        self.tableView.reloadData()
    }
    
    //Not a really a good fix, but it will do for now.
    //This is bad because everytime the mainScreen re-opend it reloads all data on that screen
    //we only need to do this when something changes on that screen such as, a change of classes, logout and login as a 
    //different user, etc.
    override func viewWillAppear(_ animated: Bool) {
        if FIRAuth.auth()?.currentUser?.uid == nil {
            perform(#selector(handleLogout), with: nil, afterDelay: 0)
        } else {
            fetchNameSetupNavBar()
            fetchClasses()
            fetchNotifications()
            fetchCurrentName()
        }
    }
    
    func fetchNameSetupNavBar() {
        guard let uid = FIRAuth.auth()?.currentUser?.uid else {
            return
        }
        FIRDatabase.database().reference().child("users").child(uid).observeSingleEvent(of: .value, with: { (snapshot) in
            
            if let userDictionary = snapshot.value as? [String: AnyObject] {
                self.navigationItem.rightBarButtonItem?.tintColor = UIColor.white
                self.navigationItem.leftBarButtonItem?.tintColor = UIColor.white
                
                let titleView = UIView()
                titleView.frame = CGRect(x: 0, y: 0, width: 5, height: 40)
                
                let containerView = UIView()
                containerView.translatesAutoresizingMaskIntoConstraints = false
                titleView.addSubview(containerView)
                
                let profileImageView = UIImageView()
                profileImageView.translatesAutoresizingMaskIntoConstraints = false
                profileImageView.contentMode = .scaleAspectFill
                profileImageView.layer.cornerRadius = 20
                profileImageView.clipsToBounds = true
                
                //profileImageView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(self.handleSelectProfileImageView)))
                
                if let profileImageUrl = userDictionary["profileImage"] as? String{
                    profileImageView.loadImageUsingCacheWithUrlString(urlString: profileImageUrl)
                }
                containerView.addSubview(profileImageView)
                
                profileImageView.leftAnchor.constraint(equalTo: containerView.leftAnchor).isActive = true
                profileImageView.centerYAnchor.constraint(equalTo: containerView.centerYAnchor).isActive = true
                profileImageView.widthAnchor.constraint(equalToConstant: 40).isActive = true
                profileImageView.heightAnchor.constraint(equalToConstant: 40).isActive = true
                
                let nameLabel = UILabel()
                containerView.addSubview(nameLabel)
                nameLabel.text = userDictionary["name"] as? String
                nameLabel.translatesAutoresizingMaskIntoConstraints = false
                nameLabel.leftAnchor.constraint(equalTo: profileImageView.rightAnchor, constant: 8).isActive = true
                nameLabel.centerYAnchor.constraint(equalTo: profileImageView.centerYAnchor).isActive = true
                nameLabel.rightAnchor.constraint(equalTo: containerView.rightAnchor).isActive = true
                nameLabel.heightAnchor.constraint(equalTo: profileImageView.heightAnchor).isActive = true
                
                nameLabel.textColor = UIColor.white
        
                containerView.rightAnchor.constraint(equalTo: titleView.rightAnchor).isActive = true
                containerView.centerYAnchor.constraint(equalTo: titleView.centerYAnchor).isActive = true
                
                self.navigationItem.titleView = titleView
            }
        }, withCancel: nil)
    }
    
    
    func fetchNotifications() {
        let uid = FIRAuth.auth()?.currentUser?.uid
        FIRDatabase.database().reference().child("users").child(uid!).child("notifications").child("0").observe(.value, with: { (snapshot) in
            print(snapshot)
            //notificationSectionHeaders.append()
            
            if let notificationsDictionary = snapshot.value as? [String: AnyObject] {
                self.notificationSender.senderName = notificationsDictionary["senderName"] as? String
                self.notificationSender.groupName = notificationsDictionary["groupName"] as? String
                self.notificationSender.gid = notificationsDictionary["gid"] as? String
                self.notificationSender.senderName = notificationsDictionary["senderName"] as? String
                self.notificationSender.className = notificationsDictionary["class"] as? String
            } else {
                self.notificationSender.senderName = nil
                self.notificationSender.groupName = nil
                self.notificationSender.gid = nil
                self.notificationSender.senderName = nil
                self.notificationSender.className = nil
            }
            self.tableView.reloadData()
        })
    }
    

    func fetchClasses() {
        userCourses.removeAll()
        let uid = FIRAuth.auth()?.currentUser?.uid
        FIRDatabase.database().reference().child("users").child(uid!).child("courses").observe(.childAdded, with: { (snapshot) in
            print(snapshot.value as! String)
            
            self.userCourses.append(snapshot.value as! String)
            self.tableView.reloadData()
        })
    }
    
    
    func fetchCurrentName() {
        let uid = FIRAuth.auth()?.currentUser?.uid
        FIRDatabase.database().reference().child("users").child(uid!).child("name").observe(.childAdded, with: { (snapshot) in
            self.userName = snapshot.value as! String
        })
    }
    
    func handleLogout() {
        
        do {
            try FIRAuth.auth()?.signOut()
        } catch let logoutError {
            print(logoutError)
        }
        let loginController = LoginController()
        //let loginController = ClassSelectController()
        present(loginController, animated: false, completion: nil)
    }
    
    func handleSettings(){
        let settingsController = SettingsController()
        //let settingsController = UserListController()
        let settingsNavController = UINavigationController(rootViewController: settingsController)
        present(settingsNavController, animated: true, completion: nil)
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection
        section: Int) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "userCell", for: indexPath) as! GroupCell
        if notificationSender.senderName != nil && notificationSender.groupName != nil {
            cell.nameLabel.numberOfLines = 2
            cell.nameLabel.text = notificationSender.senderName! + " has invited you to group \n" + notificationSender.groupName!
            return cell
        }
        cell.nameLabel.text = ""
        return cell
    }
    
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let header = tableView.dequeueReusableHeaderFooterView(withIdentifier: "headerId") as! Header
        header.nameLabel.text = notificationSender.className
        return header
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        if notificationSender.className != nil {
            return 1
        } else {
            return 0
        }
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        //let cell = tableView.cellForRow(at: indexPath)
        //let user = usersInClass[indexPath.row]
        //user.selected = !user.selected
        let uid = FIRAuth.auth()?.currentUser?.uid
        if notificationSender.className != nil {
            let alertController = UIAlertController(title: "Group Invite", message: self.notificationSender.senderName! + " would like to invite you to group "
                + self.notificationSender.groupName!, preferredStyle: .alert)
            
            let okAction = UIAlertAction(title: "Accept", style: UIAlertActionStyle.default) {
                UIAlertAction in
                let groupRef = FIRDatabase.database().reference().child("groups").child(self.notificationSender.gid!).child("members")
                let userRef = FIRDatabase.database().reference().child("users").child(uid!)
                groupRef.updateChildValues([uid! : self.userName])
                NSLog("OK Pressed")
            }
            
            let cancelAction = UIAlertAction(title: "Cancel", style: UIAlertActionStyle.cancel) {
                UIAlertAction in
                NSLog("Cancel Pressed")
            }
            
            alertController.addAction(okAction)
            alertController.addAction(cancelAction)
            self.present(alertController, animated: true, completion: nil)
        }
    }
}

