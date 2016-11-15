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
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Logout", style: .plain, target: self, action: #selector(handleLogout))
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Settings", style: .plain, target: self, action: #selector(handleSettings))
        self.navigationController?.navigationBar.barTintColor = UIColor(r: 61, g: 91, b: 151)
        self.tabBarController?.tabBar.barTintColor = UIColor(r: 61, g: 91, b: 151)
        if FIRAuth.auth()?.currentUser?.uid == nil {
            perform(#selector(handleLogout), with: nil, afterDelay: 0)
        } else {
            fetchNameSetupNavBar()
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
            
            if let userDictionary = snapshot.value as?[String: AnyObject] {
                self.navigationItem.title = userDictionary["name"] as? String
                let titleDict: NSDictionary = [NSForegroundColorAttributeName: UIColor.white]
                self.navigationController?.navigationBar.titleTextAttributes = titleDict as? [String : Any]
                self.navigationItem.rightBarButtonItem?.tintColor = UIColor.white
                self.navigationItem.leftBarButtonItem?.tintColor = UIColor.white
            }
        }, withCancel: nil)
    }
    
    func fetchClasses() {
        userCourses.removeAll()
        let uid = FIRAuth.auth()?.currentUser?.uid
        FIRDatabase.database().reference().child("users").child(uid!).child("courses").observe(.childAdded, with: { (snapshot) in
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
        //let loginController = LoginController()
        let loginController = ClassSelectController()
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

