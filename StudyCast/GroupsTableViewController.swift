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

    //let userClassesDataSet: [String]?
    //let groupsDataSet: [Group]?
    

    //Dummy data for this page, all to be pulled from db later.
    let userClassesDataSet = ["ENSC 380", "CMPT 275", "ENSC 252", "MACM 201"]
    
    var groupsForClassSection: [Int] = []
    var classSectionHeaders: [String] = []
    
    var Dennis: User?
    var Austin: User?
    var Roy: User?
    
    var currentUser: User?
    
    var users: [User]?
    
    var group1: Group?
    var group2: Group?
    var group3: Group?
    
    var testingList: [Group] = []
    
    var groupsList: [Group] = []
    
    var groupsDataSet: [[Group]] = [[]]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavBar()
        
        initalizeTestingData()
        setGroupsForClassSection()
        setGroupArrays()
        
        tableView.register(Header.self, forHeaderFooterViewReuseIdentifier: "headerId")
        tableView.register(GroupCell.self, forCellReuseIdentifier: "groupCell")
        
        tableView.sectionHeaderHeight = 50
        
        
    }
    
    
    func setGroupArrays() {
        
        let uid = FIRAuth.auth()?.currentUser?.uid
        FIRDatabase.database().reference().child("users").child(uid!).child("groups").observe(.childAdded, with: { (snapshot) in
            let group = snapshot.key 
            
            print(group)
            
            //self.userCourses.append(snapshot.value as! String)
            //self.tableView.reloadData()
        })
        
        //declaring iterator
        var i = 0
        //iterates through the classes that have been determined to have groups
        for name in classSectionHeaders {
            //places each group its respective array
            for group in groupsList {
                //checks if the current group needs to be added to this list
                if group.groupClass == name {
                    //creates new array index if necessary , or just appends the group to a prexisting list
                    if !(groupsDataSet.indices.contains(i)){
                        groupsDataSet.append([group])
                    }
                    else {
                        groupsDataSet[i].append(group)
                    }
                }
            }
            i += 1
        }
    }
    
    func setGroupsForClassSection() {
        var numGroups  = 0
        //increments through list of current User's classes
        for userClass in currentUser!.classes! {
            numGroups = 0
            //for each of those classes, checks against the User's list of groups
            for group in groupsList {
                //every time a group is found for that class add to the number of groups
                if userClass == group.groupClass {
                   numGroups += 1
                }
            }
            // if groups are found for that class, append the amount to the array
            if numGroups != 0 {
                self.groupsForClassSection.append(numGroups)
                self.classSectionHeaders.append(userClass)
            }
        }
        
    }
    
    func initalizeTestingData() {
        self.Dennis = User(id: nil, name: "Dennis", photo: nil, email: "Dennis@gmail.com", classes: userClassesDataSet)
        self.Austin = User(id: nil, name: "Austin", photo: nil, email: "Austin@gmail.com", classes: userClassesDataSet)
        self.Roy = User(id: nil, name: "Roy", photo: nil, email: "Roy@gmail.com", classes: userClassesDataSet)
        
        self.currentUser = Austin
        
        self.users = [Dennis!, Austin!, Roy!]
        
        self.group1 = Group(id: nil, name: "group1", photo: nil, users: users, groupClass: "ENSC 380")
        self.group2 = Group(id: nil, name: "group2", photo: nil, users: users, groupClass: "CMPT 275")
        self.group3 = Group(id: nil, name: "group3", photo: nil, users: users, groupClass: "ENSC 380")
        
        groupsList = [group1!, group2!, group3!]
        
    
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
        
        return groupsForClassSection.count
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return groupsForClassSection[section]
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
    
    
    init(id: String?, name: String?, photo: UIImage?, users: [User]?, groupClass: String?) {
        self.id   = id
        self.name = name
        self.photo  = photo
        self.users = users
        self.groupClass = groupClass
    }
    
    let id: String?
    let name: String?
    let photo: UIImage?
    let users: [User]?
    let groupClass: String?

}

class User: NSObject {
    
    init(id: String?, name: String?, photo: UIImage?, email: String?, classes: [String]?) {
        self.id   = id
        self.name = name
        self.photo  = photo
        self.email = email
        self.classes = classes
        
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



