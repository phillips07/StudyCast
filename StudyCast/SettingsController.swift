//
//  SettingsController.swift
//  StudyCast
//
//  Created by Dennis Huebert on 2016-11-11.
//  Copyright © 2016 Austin Phillips. All rights reserved.
//

import UIKit
import Firebase

class SettingsController: UITableViewController {

    var headerTitles = ["Profile","Cast","About","Other"]
    var numberOfRowsInSection = [3,3,1,1]
    var settingItems = ["Change your Password","Select Different Classes", "Edit your Name",
                        "In Development", "In Development", "In Development", "Version 1.0.2", "Log out"]
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Back", style: .plain, target: self, action: #selector(handleCancel))
        self.navigationController?.navigationBar.barTintColor = UIColor(r: 61, g: 91, b: 151)
        self.navigationItem.leftBarButtonItem?.tintColor = UIColor.white
        let titleDict: NSDictionary = [NSForegroundColorAttributeName: UIColor.white]
        self.navigationController?.navigationBar.titleTextAttributes = titleDict as? [String : Any]
        self.navigationItem.title = "Settings"
        
        tableView.register(MyCell.self, forCellReuseIdentifier: "cellId")
        tableView.register(Header.self, forHeaderFooterViewReuseIdentifier: "headerId")
        
        tableView.sectionHeaderHeight = 50
    }


    override func numberOfSections(in tableView: UITableView) -> Int {
        return headerTitles.count
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return numberOfRowsInSection[section]
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cellId", for: indexPath) as! MyCell
        
        if indexPath.section == 0 {
            cell.nameLabel.text = settingItems[indexPath.row]
        } else if indexPath.section == 1 {
            cell.nameLabel.text = settingItems[indexPath.row + 3]
        } else if indexPath.section == 2 {
            cell.nameLabel.text = settingItems[indexPath.row + settingItems.count - 2]
        }
        else if indexPath.section == 3 {
            cell.nameLabel.text = settingItems[indexPath.row + settingItems.count - 1]
        }
        return cell
    }
    
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let header = tableView.dequeueReusableHeaderFooterView(withIdentifier: "headerId") as! Header
        header.nameLabel.text = headerTitles[section]
        return header
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if indexPath.section == 0
        {
            if indexPath.row == 0 {
                let changePasswordController = ChangePasswordController()
                navigationController?.pushViewController(changePasswordController, animated: true)
            } else if indexPath.row == 1 {
                let classSelectController = ClassSelectController()
                classSelectController.initClassesForUser()
                navigationController?.pushViewController(classSelectController, animated: true)
            } else if indexPath.row == 2 {
                let changenamecontroller = ChangeNameController()
                navigationController?.pushViewController(changenamecontroller, animated: true)
            }
            
        } else if indexPath.section == 3 {
            
            if indexPath.row == 0 {
                do {
                    try FIRAuth.auth()?.signOut()
                } catch let logoutError {
                    print(logoutError)
                }
                self.dismiss(animated: false, completion: nil)
            }
        }
    }
 
    func handleCancel() {
        self.dismiss(animated: true, completion: nil)
    }
}


class Header: UITableViewHeaderFooterView {
    override init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)
        setupViews()
    }
    
    required init?(coder aDecoder: NSCoder){
        fatalError("init(coder:) has not been implemented")
    }
    
    let nameLabel: UILabel = {
        let label = UILabel()
        label.text = "My Header"
        label.font = UIFont.boldSystemFont(ofSize: 17)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    func setupViews(){
        addSubview(nameLabel)
        addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-16-[v0]|", options: NSLayoutFormatOptions(), metrics: nil, views: ["v0": nameLabel]))
        addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|[v0]|", options: NSLayoutFormatOptions(), metrics: nil, views: ["v0": nameLabel]))
    }
}


class MyCell: UITableViewCell {
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupViews()
    }
    
    required init?(coder aDecoder: NSCoder){
        fatalError("init(coder:) has not been implemented")
    }
    
    let nameLabel: UILabel = {
        let label = UILabel()
        label.text = "My Cell"
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    func setupViews(){
        addSubview(nameLabel)
        addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-16-[v0]|", options: NSLayoutFormatOptions(), metrics: nil, views: ["v0": nameLabel]))
        addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|[v0]|", options: NSLayoutFormatOptions(), metrics: nil, views: ["v0": nameLabel]))
    }
}









