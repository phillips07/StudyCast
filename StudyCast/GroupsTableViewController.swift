//
//  GroupsController.swift
//  StudyCast
//
//  Created by Dennis Huebert on 2016-11-18.
//  Copyright © 2016 Apollo. All rights reserved.
//


import UIKit
import Firebase
import Foundation


class GroupsTableViewController: UITableViewController {
    
    var classSectionHeaders: [String] = []
    
    
    var groupsDataSet: [[Group]] = [[]]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavBar()

        fetchGroups()

        
        tableView.register(Header.self, forHeaderFooterViewReuseIdentifier: "headerId")
        tableView.register(GroupCell.self, forCellReuseIdentifier: "groupCell")
        
        tableView.sectionHeaderHeight = 50
        
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        fetchGroups()
    }
    
    func fetchGroups () {
        
        let uid = FIRAuth.auth()?.currentUser?.uid
        
        FIRDatabase.database().reference().child("users").child(uid!).child("groups").observe(.childAdded, with: { (snapshot) in
            //iterator for setting up arrays

            let numClassSections = self.classSectionHeaders.count
            
            var group = Group()
            var duplicate = false
            
            if let groupDictionary = snapshot.value as? [String: AnyObject] {
                let name = groupDictionary["groupName"] as? String
                let groupClass = groupDictionary["groupClass"] as? String
                let imgUrl = groupDictionary["groupPictureURL"] as? String
                
                group = Group(id: nil, name: name, photoUrl: imgUrl, users: nil, groupClass: groupClass)
                
            }

            for i in self.groupsDataSet {
                for g in i {
                    if g.name == group.name {
                        duplicate = true
                    }
                }
            }
            
            if group.groupClass == nil {
            }
            else if !duplicate {
                //Set up all Data for TableView
                if numClassSections == 0 {
                    self.classSectionHeaders.append(group.groupClass!)
                    self.groupsDataSet[0] = [group]
                }
                else {
                    var i = 0
                    var added = false
                    for g in self.classSectionHeaders {
                        if (group.groupClass)! == g {
                            self.groupsDataSet[i].append(group)
                            added = true
                        }
                        i += 1
                    }
                    if !added {
                        self.classSectionHeaders.append(group.groupClass!)
                        self.groupsDataSet.append([group])
                    }
                    
                }
                self.tableView.reloadData()
            }
        })
        
    }
    
    
    func setupNavBar() {
        let image = UIImage(named: "GroupAddIcon")
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(image: image, style: .plain, target: self, action: #selector(handleAddGroup))
        self.navigationController?.navigationBar.barTintColor = UIColor(r: 61, g: 91, b: 151)
        self.tabBarController?.tabBar.barTintColor = UIColor(r: 61, g: 91, b: 151)
        self.navigationItem.rightBarButtonItem?.tintColor = UIColor.white
        
        let titleView = UIView()
        titleView.frame = CGRect(x: 0, y: 0, width: 5, height: 40)
        
        let containerView = UIView()
        containerView.translatesAutoresizingMaskIntoConstraints = false
        titleView.addSubview(containerView)
        
        let titleLabel = UILabel()
        titleLabel.text = "Groups"
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        containerView.addSubview(titleLabel)

        titleLabel.leftAnchor.constraint(equalTo: containerView.leftAnchor, constant: -175).isActive = true
        titleLabel.centerYAnchor.constraint(equalTo: containerView.centerYAnchor).isActive = true
        titleLabel.rightAnchor.constraint(equalTo: containerView.rightAnchor).isActive = true
        titleLabel.heightAnchor.constraint(equalTo: containerView.heightAnchor).isActive = true
        
        titleLabel.textColor = UIColor.white
        
        containerView.rightAnchor.constraint(equalTo: titleView.rightAnchor).isActive = true
        containerView.centerYAnchor.constraint(equalTo: titleView.centerYAnchor).isActive = true
        
        self.navigationItem.titleView = titleView
    }
    
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let header = tableView.dequeueReusableHeaderFooterView(withIdentifier: "headerId") as! Header
        header.nameLabel.text = classSectionHeaders[section]
        return header
    }

    override func numberOfSections(in tableView: UITableView) -> Int {
        
        return classSectionHeaders.count
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return groupsDataSet[section].count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        
        //let cell = UITableViewCell()
        let cell = tableView.dequeueReusableCell(withIdentifier: "groupCell", for: indexPath) as! GroupCell
        
        //if indexPath.section
        cell.nameLabel.text = groupsDataSet[indexPath.section][indexPath.row].name

        return cell
    }
    

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}

class Group: NSObject {
    
    
    init(id: String?, name: String?, photoUrl: String?, users: [User]?, groupClass: String?) {
        self.id = id
        self.name = name
        self.photoUrl = photoUrl
        self.users = users
        self.groupClass = groupClass
    }
    
    override init () {
        self.id = nil
        self.name = nil
        self.photoUrl = nil
        self.users = nil
        self.groupClass = nil
    }
    
    var id: String?
    var name: String?
    var photoUrl: String?
    var users: [User]?
    var groupClass: String?

}

class User: NSObject {
    
    init(id: String?, name: String?, photo: UIImage?, email: String?, classes: [String]?) {
        self.id   = id
        self.name = name
        self.photo  = photo
        self.email = email
        self.classes = classes
        
    }
    
    override init () {
        self.id   = nil
        self.name =  nil
        self.photo  =  nil
        self.email =  nil
        self.classes =  nil
    }
    
    let id: String?
    let name: String?
    let photo: UIImage?
    let email: String?
    let classes: [String]?
    
}

class GroupCell: UITableViewCell {
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
    
    
//    let groupImage: UIImage = {
//        let image = UIImage()
//        image.translatesAutoresizingMaskIntoConstraints = false
//        return image
//    }()
    
    func setupViews(){
        //addSubview(groupImage)
        addSubview(nameLabel)
        addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-16-[v0]|", options: NSLayoutFormatOptions(), metrics: nil, views: ["v0": nameLabel]))
        addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|[v0]|", options: NSLayoutFormatOptions(), metrics: nil, views: ["v0": nameLabel]))
        
    }
}



