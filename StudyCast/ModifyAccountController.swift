//
//  ModifyAccountController.swift
//  StudyCast
//
//  Created by Dennis Huebert on 2016-11-16.
//  Copyright © 2016 Austin Phillips. All rights reserved.
//

import UIKit

class ModifyAccountController: UITableViewController {

    var accountItems = ["Change your Password", "Password Reset", "Edit your Name", "Change your Profile Picture"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationBar.barTintColor = UIColor(r: 61, g: 91, b: 151)
        self.navigationController?.navigationBar.tintColor = UIColor.white
        self.navigationItem.title = "Account"
        
        tableView.register(MyCell.self, forCellReuseIdentifier: "cellId")
        tableView.register(Header.self, forHeaderFooterViewReuseIdentifier: "headerId")

    }

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return accountItems.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cellId", for: indexPath) as! MyCell
        cell.nameLabel.text = accountItems[indexPath.row]
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if indexPath.row == 0 {
            let changePasswordController = ChangePasswordController()
            navigationController?.pushViewController(changePasswordController, animated: true)
        } else if indexPath.row == 1 {
            let passwordResetController = PasswordResetController()
            navigationController?.pushViewController(passwordResetController, animated: true)
        }
    }
}
