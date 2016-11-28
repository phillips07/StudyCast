//
//  ChatLogController.swift
//  StudyCast
//
//  Created by Austin Phillips on 2016-11-24.
//  Copyright © 2016 Austin Phillips. All rights reserved.
//

import UIKit
import Firebase

class ChatLogController: UICollectionViewController, UICollectionViewDelegateFlowLayout {
    
    var group = Group()
    var sender = User()
    var messages = [Message]()
    
    let inputTextField: UITextField = {
        
        let inputTextField = UITextField()
        inputTextField.placeholder = "Enter message..."
        inputTextField.translatesAutoresizingMaskIntoConstraints = false
        
        return inputTextField
    
    }()
    
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: view.frame.width, height: 80)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        navigationItem.title = group.name
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Back", style: .plain, target: self, action: #selector(handleBack))
        collectionView?.backgroundColor = UIColor.white
        
        collectionView?.register(ChatMessageCell.self, forCellWithReuseIdentifier: "cellId")
        
        setupInputComponents()
        
        observeMessages()
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return messages.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cellId", for: indexPath) as! ChatMessageCell
        
        cell.textView.text = messages[indexPath.row].text!
        
        return cell
    }
    
    func observeMessages() {
        let ref = FIRDatabase.database().reference().child("groups").child(group.id!).child("messages")
        ref.observe(.childAdded, with: { (snapshot) in

            if let messageDictionary = snapshot.value as? [String:AnyObject] {
                let message = Message()
                message.name = messageDictionary["name"] as? String
                message.text = messageDictionary["text"] as? String
                message.timeStamp = messageDictionary["timeStamp"] as? Int
                message.senderID = messageDictionary["senderID"] as? String
                self.messages.append(message)
                
                
                DispatchQueue.main.async {
                    self.collectionView?.reloadData()
                }
                print(message.text!)
            }
            }, withCancel: nil)
    }
    
    func setInfo(group: Group, user: User) {
        self.sender = user
        self.group = group
    }
    
    func handleBack() {
        self.dismiss(animated: true, completion: nil)
    }
    
    func setupInputComponents() {
        //input area container
        let containerView = UIView()
        containerView.backgroundColor = UIColor.white
        containerView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(containerView)
        
        containerView.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        containerView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        containerView.widthAnchor.constraint(equalTo: view.widthAnchor).isActive = true
        containerView.heightAnchor.constraint(equalToConstant: 50).isActive = true
        
        //send Button
        let sendButton = UIButton(type: .system)
        sendButton.setTitle("Send", for: .normal)
        sendButton.addTarget(self, action: #selector(handleSend), for: .touchUpInside)
        sendButton.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(sendButton)
        
        sendButton.rightAnchor.constraint(equalTo: containerView.rightAnchor).isActive = true
        sendButton.centerYAnchor.constraint(equalTo: containerView.centerYAnchor).isActive = true
        sendButton.widthAnchor.constraint(equalToConstant: 80).isActive = true
        sendButton.heightAnchor.constraint(equalTo: containerView.heightAnchor).isActive = true
        

        //Text Field
        view.addSubview(inputTextField)
        
        inputTextField.leftAnchor.constraint(equalTo: containerView.leftAnchor, constant: 8).isActive = true
        inputTextField.centerYAnchor.constraint(equalTo: containerView.centerYAnchor).isActive = true
        inputTextField.rightAnchor.constraint(equalTo: sendButton.leftAnchor).isActive = true
        inputTextField.heightAnchor.constraint(equalTo: containerView.heightAnchor).isActive = true
        
        
        //Line above input area
        let seperatorLine = UIView()
        seperatorLine.translatesAutoresizingMaskIntoConstraints = false
        seperatorLine.backgroundColor = UIColor(r: 220, g: 220, b: 220)
        view.addSubview(seperatorLine)
        
        seperatorLine.leftAnchor.constraint(equalTo: containerView.leftAnchor).isActive = true
        seperatorLine.topAnchor.constraint(equalTo: containerView.topAnchor).isActive = true
        seperatorLine.widthAnchor.constraint(equalTo: containerView.widthAnchor).isActive = true
        seperatorLine.heightAnchor.constraint(equalToConstant: 1).isActive = true

    }
    
    func handleSend() {
        let ref = FIRDatabase.database().reference().child("groups").child(group.id!).child("messages")
        let childRef = ref.childByAutoId()
        
        let timeStamp = Int(NSDate().timeIntervalSince1970)
        
        let value = ["text" : inputTextField.text!, "name" : sender.name!, "timeStamp" : timeStamp, "senderID" : sender.id!] as [String : Any]
        childRef.updateChildValues(value)
    }
}

