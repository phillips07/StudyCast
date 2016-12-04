//
//  CastMenuController.swift
//  StudyCast
//
//  Created by Dennis Huebert on 2016-12-01.
//  Copyright © 2016 Austin Phillips. All rights reserved.
//

import UIKit
import Firebase

class CastMenuController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {
    
    var userCourses = [String]()
    var castClass = ""
    var previousClass = ""
    var userLocation: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.isOpaque = false
        self.view.backgroundColor = UIColor.black.withAlphaComponent(0.8)
        view.addSubview(popUp)
        fetchClasses()
        fetchPreviousClass()
        setupPopUpView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        showAnimate()
    }
    
    func setLocation(location: String) {
        userLocation = location
    }
    
    lazy var castButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Cast", for: UIControlState())
        button.backgroundColor = UIColor(r: 80, g: 101, b: 161)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitleColor(UIColor.white, for: UIControlState())
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 16)
        button.addTarget(self, action: #selector(removeAnimate), for: .touchUpInside)
        return button
    }()
    
    let popUp: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(r: 61, g: 91, b: 151)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.layer.cornerRadius = 8.0
        return view
    }()
    
    let titleLabel: UILabel = {
        let label = UILabel()
        label.textColor = UIColor.white
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Select your Class\nto Cast"
        label.numberOfLines = 2
        label.textAlignment = NSTextAlignment.center
        label.font = UIFont.boldSystemFont(ofSize: 16)
        return label
    }()
    
    lazy var classPicker: UIPickerView = {
        let pv = UIPickerView()
        pv.backgroundColor = UIColor.white
        pv.layer.cornerRadius = 6
        pv.translatesAutoresizingMaskIntoConstraints = false
        pv.dataSource = self
        pv.delegate = self
        return pv
    }()
    
    func setupPopUpView() {
        popUp.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        popUp.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        popUp.widthAnchor.constraint(equalToConstant: 300).isActive = true
        popUp.heightAnchor.constraint(equalToConstant: 250).isActive = true
        
        popUp.addSubview(titleLabel)
        
        titleLabel.topAnchor.constraint(equalTo: popUp.topAnchor, constant: 30).isActive = true
        titleLabel.centerXAnchor.constraint(equalTo: popUp.centerXAnchor).isActive = true
        
        popUp.addSubview(classPicker)
        
        classPicker.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 30).isActive = true
        classPicker.widthAnchor.constraint(equalTo: popUp.widthAnchor, constant: -40).isActive = true
        classPicker.centerXAnchor.constraint(equalTo: popUp.centerXAnchor).isActive = true
        classPicker.heightAnchor.constraint(equalToConstant: 60).isActive = true
        
        popUp.addSubview(castButton)
        
        castButton.bottomAnchor.constraint(equalTo: popUp.bottomAnchor, constant: -20).isActive = true
        castButton.centerXAnchor.constraint(equalTo: popUp.centerXAnchor).isActive = true
        castButton.widthAnchor.constraint(equalTo: classPicker.widthAnchor).isActive = true
        castButton.heightAnchor.constraint(equalToConstant: 50).isActive = true
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return userCourses.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return userCourses[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, rowHeightForComponent component: Int) -> CGFloat {
        return 20
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        castClass = userCourses[row]
    }
    
    func handleBack() {
        self.dismiss(animated: false, completion: nil)
    }
    
    func showAnimate() {
        self.view.transform = CGAffineTransform(scaleX: 1.3, y: 1.3)
        self.view.alpha = 0.0
        UIView.animate(withDuration: 0.25, animations: {
            self.view.alpha = 1.0
            self.view.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
        })
    }

    func removeAnimate() {
        UIView.animate(withDuration: 0.25, animations: {
            self.view.transform = CGAffineTransform(scaleX: 1.3, y: 1.3)
            self.view.alpha = 0.0
            guard let uid = FIRAuth.auth()?.currentUser?.uid else {
                return
            }
            if self.previousClass != "" {
                let previousRef = FIRDatabase.database().reference().child(self.previousClass).child(uid).child("location")
                previousRef.removeValue()
            }
            let userRef = FIRDatabase.database().reference().child("users").child(uid).child("cast")
            let classRef = FIRDatabase.database().reference().child(self.castClass).child(uid)
            userRef.updateChildValues(["course" : self.castClass])
            classRef.updateChildValues(["location" : self.userLocation!])
        }, completion: {( finished : Bool ) in
            if (finished) {
                NotificationCenter.default.post(name: NSNotification.Name(rawValue: "refresh"), object: nil)
                self.dismiss(animated: false, completion: nil)
            }
        })
    }
    
    func fetchPreviousClass() {
        guard let uid = FIRAuth.auth()?.currentUser?.uid else {
            return
        }
        FIRDatabase.database().reference().child("users").child(uid).child("cast").child("course").observe(.value, with: { (snapshot) in
            //print(snapshot)
            
            if snapshot.exists() == true {
                self.previousClass = snapshot.value as! String
            } else {
                self.previousClass = ""
            }
        })
    }
    
    func fetchClasses() {
        userCourses.removeAll()
        guard let uid = FIRAuth.auth()?.currentUser?.uid else {
            return
        }
        FIRDatabase.database().reference().child("users").child(uid).child("courses").observe(.childAdded, with: { (snapshot) in
            self.userCourses.append(snapshot.value as! String)
            self.castClass = self.userCourses[0]
            self.classPicker.reloadAllComponents()
        })
    }
}
