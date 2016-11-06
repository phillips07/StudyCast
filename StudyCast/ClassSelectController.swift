//
//  ClassSelectController.swift
//  StudyCastv2
//
//  Created by Dennis on 2016-11-04.
//  Copyright © 2016 Apollo. All rights reserved.
//

import UIKit
import Firebase

class ClassSelectController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor(r: 61, g: 91, b: 151)
        
        view.addSubview(facultyTableView)
        view.addSubview(userClassesTableView)
        view.addSubview(classesTableView)
        view.addSubview(userClassLabel)
        view.addSubview(doneButton)
        view.addSubview(classSearchBar)
        //view.addSubview(navBar)
        view.addSubview(viewLabel)
        view.addSubview(cancelButton)
        
        setupUserClassesTableView()
        setupClassesTableView()
        setupFacultyTableView()
        setupUserClassLabel()
        setupDoneButton()
        setupClassSearchBar()
        //setupNavBar()
        setupViewLabel()
        setupCancelButton()
        
        //UITableView
        //UITableView.register(UserCell.self, forCellReuseIdentifier: "cellId")
        
        self.facultyTableView.register(UserCell.self, forCellReuseIdentifier: "cell")
        self.userClassesTableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell2")
        self.classesTableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell3")
    }

    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableView == facultyTableView {
            return facultyDataSet.count
        } else if tableView == classesTableView {
            return enscDataSet.count
        } else if tableView == userClassesTableView {
            return busDataSet.count
        } else {
            return 1
        }
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1;
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if tableView == facultyTableView {
            let cell:UITableViewCell = self.facultyTableView.dequeueReusableCell(withIdentifier: "cell")! as     UITableViewCell
            cell.textLabel?.text = String(self.facultyDataSet[indexPath.row])
            return cell
        } else if tableView == userClassesTableView {
            let cell2:UITableViewCell = self.userClassesTableView.dequeueReusableCell(withIdentifier: "cell2")! as UITableViewCell
            cell2.textLabel?.text = String(self.enscDataSet[indexPath.row])
            return cell2
        } else if tableView == classesTableView {
            let cell3:UITableViewCell = self.classesTableView.dequeueReusableCell(withIdentifier: "cell3")! as UITableViewCell
            cell3.textLabel?.text = String(self.enscDataSet[indexPath.row])
            return cell3
        } else {
            let cell = UITableViewCell (style: .subtitle, reuseIdentifier: "default")
            
            cell.textLabel?.text = "default text"
            
            return cell
        }
    }
    
    
    /*
     Dummy data for Tableviews
     ***** Remember that the dummy data was placed in the faculty data set to be used in the top table view, however to impliment the actual idea, the classes should be in something like classDataSet and the rest of the code will need to be updated to support.
    */
    let facultyDataSet = ["ENSC 100W", "ENSC 105", "ENSC 252", "ENSC 254", "ENSC 351", "ENSC 424","BUS 100W", "BUS 105", "BUS 252", "BUS 254", "BUS 351", "BUS 424","ARCH 100W", "ARCH 105", "ARCH 252", "ARCH 254", "ARCH 351", "ARCH 424","CMPS 100W", "CMPS 105", "CMPS 252", "CMPS 254", "CMPS 351", "CMPS 424"]
    
    let enscDataSet = ["ENSC 100W", "ENSC 105", "ENSC 252", "ENSC 254", "ENSC 351", "ENSC 424"]
    
    let busDataSet = ["BUS 100W", "BUS 105", "BUS 252", "BUS 254", "BUS 351", "BUS 424"]
    
    let archDataSet = ["ARCH 100W", "ARCH 105", "ARCH 252", "ARCH 254", "ARCH 351", "ARCH 424"]
    
    let cmpsDataSet = ["CMPS 100W", "CMPS 105", "CMPS 252", "CMPS 254", "CMPS 351", "CMPS 424"]
    
    
    lazy var facultyTableView: UITableView = {
        let tv = UITableView()
        tv.translatesAutoresizingMaskIntoConstraints = false
        tv.layer.cornerRadius = 6
        tv.dataSource = self
        let backButton = UIBarButtonItem(title: "back", style: .plain, target: self, action: #selector(handleTap))
        self.navigationItem.leftBarButtonItem = backButton
        //UINavigationItem.setLeftBarButton(UINavigationItem(UITabBarSystemItem: .Stop, target: self, action: nil), animated: true)
        return tv
    }()
    
    lazy var classesTableView: UITableView = {
        let tv = UITableView()
        tv.translatesAutoresizingMaskIntoConstraints = false
        tv.layer.cornerRadius = 6
        tv.dataSource = self
        return tv
    }()
    
    lazy var userClassesTableView: UITableView = {
        let tv = UITableView()
        tv.translatesAutoresizingMaskIntoConstraints = false
        tv.layer.cornerRadius = 6
        tv.dataSource = self
        return tv
    }()
    
    let userClassLabel: UILabel = {
        let ul = UILabel()
        ul.translatesAutoresizingMaskIntoConstraints = false
        ul.text = "My Classes:"
        ul.textColor = UIColor.white
        ul.font = UIFont.boldSystemFont(ofSize: 16)
        return ul
    }()
    
    lazy var doneButton: UIButton = {
        let button = UIButton(type: .system)
        button.backgroundColor = UIColor(r: 80, g: 101, b: 161)
        button.setTitle("Done", for: UIControlState())
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitleColor(UIColor.white, for: UIControlState())
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 16)
        button.addTarget(self, action: #selector(handleDone), for: .touchUpInside)
        return button
    }()
    
    let classSearchBar: UISearchBar = {
        let cs = UISearchBar()
        cs.translatesAutoresizingMaskIntoConstraints = false
        var textFieldSearchBar = cs.value(forKey: "searchField") as? UITextField
        textFieldSearchBar?.textColor = UIColor.white
        cs.searchBarStyle = UISearchBarStyle.minimal
        return cs
    }()
    
    /*class facultyTableViewController: UITableViewController {
        
       override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
            return facultyDataSet.count
        }
        
        
    }*/
    
    /*lazy var navBar: UINavigationBar = {
        let nb = UINavigationBar()
        nb.translatesAutoresizingMaskIntoConstraints = false
        nb.barTintColor = UIColor(r: 61, g: 91, b: 151)
        nb.tintColor = UIColor.whiteColor()
        return nb
    }()*/
    
    let viewLabel: UILabel = {
        let ul = UILabel()
        ul.translatesAutoresizingMaskIntoConstraints = false
        ul.text = "Select your Classes"
        ul.textColor = UIColor.white
        ul.font = UIFont.boldSystemFont(ofSize: 18)
        return ul
    }()
    
    lazy var cancelButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Cancel", for: UIControlState())
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitleColor(UIColor.white, for: UIControlState())
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 16)
        button.addTarget(self, action: #selector(handleCancel), for: .touchUpInside)
        return button
    }()

    
    func setupFacultyTableView() {
        facultyTableView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        facultyTableView.widthAnchor.constraint(equalTo: view.widthAnchor, constant: -35).isActive = true
        facultyTableView.heightAnchor.constraint(equalToConstant: 185).isActive = true
        facultyTableView.topAnchor.constraint(equalTo: view.topAnchor, constant: 145).isActive = true
        
    }
    
    func setupClassesTableView() {
        facultyTableView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        facultyTableView.widthAnchor.constraint(equalTo: view.widthAnchor, constant: -35).isActive = true
        facultyTableView.heightAnchor.constraint(equalToConstant: 185).isActive = true
        facultyTableView.topAnchor.constraint(equalTo: view.topAnchor, constant: 145).isActive = true
        
    }
    
    func setupUserClassesTableView() {
        userClassesTableView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        userClassesTableView.widthAnchor.constraint(equalTo: facultyTableView.widthAnchor).isActive = true
        userClassesTableView.heightAnchor.constraint(equalTo: facultyTableView.heightAnchor).isActive = true
        userClassesTableView.topAnchor.constraint(equalTo: facultyTableView.bottomAnchor, constant: 40).isActive = true
    }
    
    func setupUserClassLabel() {
        userClassLabel.leftAnchor.constraint(equalTo: userClassesTableView.leftAnchor).isActive = true
        userClassLabel.bottomAnchor.constraint(equalTo: userClassesTableView.topAnchor, constant: -5).isActive = true
    }
    
    /*func setupDoneButton(){
        //need x, y, width, height constraints
        doneButton.centerXAnchor.constraintEqualToAnchor(view.centerXAnchor).active = true
        doneButton.bottomAnchor.constraintEqualToAnchor(view.bottomAnchor).active = true
        doneButton.widthAnchor.constraintEqualToAnchor(view.widthAnchor).active = true
        doneButton.heightAnchor.constraintEqualToConstant(75).active = true
    }*/
    
    func setupDoneButton(){
        doneButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        doneButton.topAnchor.constraint(equalTo: userClassesTableView.bottomAnchor, constant: 30).isActive = true
        doneButton.widthAnchor.constraint(equalTo: userClassesTableView.widthAnchor).isActive = true
        doneButton.heightAnchor.constraint(equalToConstant: 45).isActive = true
    }
    
    func setupClassSearchBar(){
        classSearchBar.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        classSearchBar.bottomAnchor.constraint(equalTo: facultyTableView.topAnchor, constant: -8).isActive = true
        classSearchBar.widthAnchor.constraint(equalTo: facultyTableView.widthAnchor, multiplier: 1.045).isActive = true
        classSearchBar.heightAnchor.constraint(equalToConstant: 50).isActive = true
    }
    
    /*func setupNavBar(){
        navBar.centerXAnchor.constraintEqualToAnchor(view.centerXAnchor).active = true
        navBar.widthAnchor.constraintEqualToAnchor(view.widthAnchor).active = true
        navBar.heightAnchor.constraintEqualToConstant(70).active = true
    }*/
    
    func setupViewLabel() {
        viewLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        viewLabel.bottomAnchor.constraint(equalTo: classSearchBar.topAnchor, constant: -15).isActive = true
    }
    
    func setupCancelButton(){
        cancelButton.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 10).isActive = true
        cancelButton.topAnchor.constraint(equalTo: view.topAnchor, constant: 25).isActive = true
    }
    
}

class UserCell: UITableViewCell {
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: .subtitle, reuseIdentifier: reuseIdentifier)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func addGestureRecognizer(_ gestureRecognizer: UIGestureRecognizer) {
        //let registerController = RegisterController()
        //present(registerController, animated: true, completion: nil)
        
        //self.present
        
    }
}
