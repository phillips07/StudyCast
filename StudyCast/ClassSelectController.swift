//
//  ClassSelectController.swift
//  StudyCastv2
//
//  Created by Dennis on 2016-11-04.
//  Copyright © 2016 Apollo. All rights reserved.
//

import UIKit
import Firebase

class ClassSelectController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor(r: 61, g: 91, b: 151)
        
        view.addSubview(classTableView)
        view.addSubview(userTableView)
        view.addSubview(userClassLabel)
        view.addSubview(doneButton)
        view.addSubview(classSearchBar)
        //view.addSubview(navBar)
        view.addSubview(viewLabel)
        view.addSubview(cancelButton)
        
        setupUserTableView()
        setupClassTableView()
        setupUserClassLabel()
        setupDoneButton()
        setupClassSearchBar()
        //setupNavBar()
        setupViewLabel()
        setupCancelButton()
    }
    
    let classTableView: UITableView = {
        let tv = UITableView()
        tv.translatesAutoresizingMaskIntoConstraints = false
        tv.layer.cornerRadius = 6
        return tv
    }()
    
    let userTableView: UITableView = {
        let tv = UITableView()
        tv.translatesAutoresizingMaskIntoConstraints = false
        tv.layer.cornerRadius = 6
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
    
    func setupClassTableView() {
        classTableView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        classTableView.widthAnchor.constraint(equalTo: view.widthAnchor, constant: -35).isActive = true
        classTableView.heightAnchor.constraint(equalToConstant: 185).isActive = true
        classTableView.topAnchor.constraint(equalTo: view.topAnchor, constant: 145).isActive = true
    }
    
    func setupUserTableView() {
        userTableView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        userTableView.widthAnchor.constraint(equalTo: classTableView.widthAnchor).isActive = true
        userTableView.heightAnchor.constraint(equalTo: classTableView.heightAnchor).isActive = true
        userTableView.topAnchor.constraint(equalTo: classTableView.bottomAnchor, constant: 40).isActive = true
    }
    
    func setupUserClassLabel() {
        userClassLabel.leftAnchor.constraint(equalTo: userTableView.leftAnchor).isActive = true
        userClassLabel.bottomAnchor.constraint(equalTo: userTableView.topAnchor, constant: -5).isActive = true
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
        doneButton.topAnchor.constraint(equalTo: userTableView.bottomAnchor, constant: 30).isActive = true
        doneButton.widthAnchor.constraint(equalTo: userTableView.widthAnchor).isActive = true
        doneButton.heightAnchor.constraint(equalToConstant: 45).isActive = true
    }
    
    func setupClassSearchBar(){
        classSearchBar.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        classSearchBar.bottomAnchor.constraint(equalTo: classTableView.topAnchor, constant: -8).isActive = true
        classSearchBar.widthAnchor.constraint(equalTo: classTableView.widthAnchor, multiplier: 1.045).isActive = true
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
