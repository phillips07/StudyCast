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
    var userId = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Back", style: .plain, target: self, action: #selector(handleBack))
        
        fetchUser()
    }
    
    func fetchUser() {
        var i = 0
        let ref = FIRDatabase.database().reference()//.child("users")
        ref.observe(.value, with: { (snapshot) in
            if let userDictionary = snapshot.value as? [String: AnyObject]{
                if let userID = userDictionary["users"] as? String {
                    self.userId[i] = userID
                    print(userID)
                    
                    i += 1
                }
                
                //print(userDictionary)
            }
            
            //print(snapshot)
        })
        
        //print(self.userId)
        
    }
    
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
}
