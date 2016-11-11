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

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Logout", style: .plain, target: self, action: #selector(handleLogout))
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Settings", style: .plain, target: self, action: #selector(handleSettings))
        self.navigationController?.navigationBar.barTintColor = UIColor(r: 61, g: 91, b: 151)
        self.tabBarController?.tabBar.barTintColor = UIColor(r: 61, g: 91, b: 151)
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
        
        self.navigationItem.rightBarButtonItem?.tintColor = UIColor.white
        self.navigationItem.leftBarButtonItem?.tintColor = UIColor.white
        //view.addSubview(tableView)
        //setupTableView()
        //view.addSubview(tabBar)
        //setupTabBar()
    }
    
    
    /*let tableView: UITableView = {
       let tv = UITableView()
       tv.translatesAutoresizingMaskIntoConstraints = false
       return tv
    }()
    
    func setupTableView() {
        tableView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        tableView.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        tableView.widthAnchor.constraint(equalTo: view.widthAnchor).isActive = true
        //tableView.heightAnchor.constraint(equalTo: view.heightAnchor).isActive = true
        tableView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
    }*/
    
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
    
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection
        section: Int) -> Int {
        return 5
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .subtitle, reuseIdentifier: "hello")
        cell.textLabel?.text = "HAHAHAHHA"
        return cell
    }
}

