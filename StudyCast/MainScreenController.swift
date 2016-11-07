//
//  ViewController.swift
//  StudyCastv2
//
//  Created by Dennis on 2016-11-03.
//  Copyright © 2016 Apollo. All rights reserved.
//

import UIKit
import Firebase

class MainScreenController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Logout", style: .plain, target: self, action: #selector(handleLogout))
        self.navigationController?.setNavigationBarHidden(false, animated: false)
        if FIRAuth.auth()?.currentUser?.uid == nil {
            perform(#selector(handleLogout), with: nil, afterDelay: 0)
        } else {
            let uid = FIRAuth.auth()?.currentUser?.uid
            FIRDatabase.database().reference().child("users").child(uid!).observeSingleEvent(of: .value, with: { (snapshot) in
                
                if let userDictionary = snapshot.value as?[String: AnyObject] {
                    self.navigationItem.title = userDictionary["name"] as? String
                }
            }, withCancel: nil)
        }
        
        view.addSubview(tableView)
        setupTableView()
    }
    
    let tableView: UITableView = {
       let tv = UITableView()
       tv.translatesAutoresizingMaskIntoConstraints = false
       return tv
    }()
    
    func setupTableView() {
        tableView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        tableView.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        tableView.widthAnchor.constraint(equalTo: view.widthAnchor).isActive = true
        tableView.heightAnchor.constraint(equalTo: view.heightAnchor).isActive = true
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
}

