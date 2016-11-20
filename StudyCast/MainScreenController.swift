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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let image = UIImage(named: "SettingsIcon")
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(image: image, style: .plain, target: self, action: #selector(handleSettings))
        
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
    
    func fetchClasses() {
        userCourses.removeAll()
        let uid = FIRAuth.auth()?.currentUser?.uid
        FIRDatabase.database().reference().child("users").child(uid!).child("courses").observe(.childAdded, with: { (snapshot) in
            print(snapshot.value as! String)
            
            self.userCourses.append(snapshot.value as! String)
            self.tableView.reloadData()
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
        let settingsNavController = UINavigationController(rootViewController: settingsController)
        present(settingsNavController, animated: true, completion: nil)
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection
        section: Int) -> Int {
        return userCourses.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .subtitle, reuseIdentifier: "cellId")
        if(userCourses.count > 0) {
            let course = userCourses[indexPath.row]
            cell.textLabel?.text = course
        }
        return cell
    }
}

