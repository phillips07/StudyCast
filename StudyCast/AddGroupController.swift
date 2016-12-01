//
//  AddGroupController.swift
//  StudyCast
//
//  Created by Dennis Huebert on 2016-11-18.
//  Copyright © 2016 Austin Phillips. All rights reserved.
//

import UIKit

class AddGroupController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {
    
    var userCourses = [String]()
    var userName = String()
    var groupClass = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor(r: 61, g: 91, b: 151)
        self.navigationController?.navigationBar.barTintColor = UIColor(r: 61, g: 91, b: 151)
        self.navigationController?.navigationBar.tintColor = UIColor.white
        
        view.addSubview(cancelButton)
        view.addSubview(nameTextField)
        view.addSubview(groupImageView)
        view.addSubview(classLabel)
        view.addSubview(userClassPicker)
        view.addSubview(createGroupButton)
        
        setupCancelButton()
        setupNameTextField()
        setupGroupImageView()
        setupClassLabel()
        setupUserClassPicker()
        setupCreateGroupButton()
        
        fetchClasses()
        //setCurrentClass(row: 0)
    }
    
    let cancelButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Cancel", for: UIControlState())
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitleColor(UIColor.white, for: UIControlState())
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 16)
        button.addTarget(nil, action: #selector(handleBack), for: .touchUpInside)
        return button
    }()
    
    lazy var groupImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "AddProfileImage3")
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.layer.cornerRadius = imageView.frame.size.width/2
        imageView.clipsToBounds = true
        imageView.contentMode = .scaleAspectFill
        
        imageView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleSelectProfileImageView)))
        imageView.isUserInteractionEnabled = true
        return imageView
    }()
    
    let nameTextField: UITextField = {
        let tf = UITextField()
        tf.placeholder = " Group Name"
        tf.translatesAutoresizingMaskIntoConstraints = false
        return tf
    }()
    
    lazy var userClassPicker: UIPickerView = {
        let picker = UIPickerView()
        picker.backgroundColor = UIColor.white
        picker.layer.cornerRadius = 6
        picker.translatesAutoresizingMaskIntoConstraints = false
        picker.dataSource = self
        picker.delegate = self
        return picker
    }()
    
    let classLabel: UILabel = {
        let label = UILabel()
        label.text = "Select Group Class"
        label.textColor = UIColor.white
        label.font = UIFont.boldSystemFont(ofSize: 14)
        label.textAlignment = NSTextAlignment.center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    lazy var createGroupButton: UIButton = {
        let button = UIButton(type: .system)
        button.backgroundColor = UIColor(r: 80, g: 101, b: 161)
        button.setTitle("Create Group", for: UIControlState())
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitleColor(UIColor.white, for: UIControlState())
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 16)
        button.addTarget(self, action: #selector(handleCreateGroup), for: .touchUpInside)
        return button
    }()
    
    func setupCancelButton() {
        cancelButton.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 10).isActive = true
        cancelButton.topAnchor.constraint(equalTo: view.topAnchor, constant: 25).isActive = true
    }
    
    func setupGroupImageView(){
        groupImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        groupImageView.bottomAnchor.constraint(equalTo: nameTextField.centerYAnchor, constant: -70).isActive = true
        groupImageView.widthAnchor.constraint(equalToConstant: 125).isActive = true
        groupImageView.heightAnchor.constraint(equalToConstant: 125).isActive = true
    }
    
    func setupNameTextField(){
        nameTextField.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        nameTextField.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: -20).isActive = true
        nameTextField.widthAnchor.constraint(equalTo: view.widthAnchor, constant: -140).isActive = true
        nameTextField.heightAnchor.constraint(equalToConstant: 35).isActive = true
        nameTextField.backgroundColor = UIColor.white
        nameTextField.layer.cornerRadius = 6.0
    }
    
    func setupClassLabel() {
        classLabel.leftAnchor.constraint(equalTo: nameTextField.leftAnchor).isActive = true
        classLabel.topAnchor.constraint(equalTo: nameTextField.bottomAnchor, constant: 15).isActive = true
    }
    
    func setupUserClassPicker(){
        userClassPicker.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        userClassPicker.topAnchor.constraint(equalTo: classLabel.bottomAnchor, constant: 8).isActive = true
        userClassPicker.widthAnchor.constraint(equalTo: nameTextField.widthAnchor).isActive = true
        userClassPicker.heightAnchor.constraint(equalToConstant: 50).isActive = true
    }
    
    func setupCreateGroupButton() {
        createGroupButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        createGroupButton.topAnchor.constraint(equalTo: userClassPicker.bottomAnchor, constant: 20).isActive = true
        createGroupButton.widthAnchor.constraint(equalTo: nameTextField.widthAnchor).isActive = true
        createGroupButton.heightAnchor.constraint(equalToConstant: 45).isActive = true
    }
}
