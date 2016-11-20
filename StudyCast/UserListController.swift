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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Back", style: .plain, target: self, action: #selector(handleBack))
        
        fetchUser()
    }
    
    func fetchUser() {
        FIRDatabase.database().reference().child("users").observe(.childAdded, with: { (snapshot) in
            
            //if let dictionary = snapshot.value as? [String: AnyObject] {
                //let user = User()
                
                //if you use this setter, your app will crash if your class properties don't exactly match up with the firebase dictionary keys
                //user.setValuesForKeysWithDictionary(dictionary)
                //self.users.append(user)
                
                //this will crash because of background thread, so lets use dispatch_async to fix
                //DispatchQueue.main.asynchronously(execute: {
                self.tableView.reloadData()
                //})
                
                //                user.name = dictionary["name"]
            //}
            
        }, withCancel: nil)
    }
    
    func handleBack() {
        dismiss(animated: true, completion: nil)
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 5
    }
    
    //override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        
        
    //}
}

class ChatUser: NSObject {
    var name: String?
    var email: String?
    var courses: [String]?
}
