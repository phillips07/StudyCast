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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.title = group.name
        let titleDict: NSDictionary = [NSForegroundColorAttributeName: UIColor.white]
        self.navigationController?.navigationBar.titleTextAttributes = titleDict as? [String : Any]
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Back", style: .plain, target: self, action: #selector(handleBack))
        self.navigationItem.leftBarButtonItem?.tintColor = UIColor.white
        self.navigationController?.navigationBar.barTintColor = UIColor(r: 61, g: 91, b: 151)
        collectionView?.backgroundColor = UIColor.white
        collectionView?.contentInset = UIEdgeInsets(top: 8, left: 0, bottom: 58, right: 0)
        collectionView?.scrollIndicatorInsets = UIEdgeInsets(top: 0, left: 0, bottom: 50, right: 0)
        collectionView?.register(ChatMessageCell.self, forCellWithReuseIdentifier: "cellId")
        
        setupInputComponents()
        
        setupKeyboardObservers()
        
        observeMessages()
    }
    
    func setupKeyboardObservers() {
        NotificationCenter.default.addObserver(self, selector: #selector(handleKeyboardWillShow), name: .UIKeyboardWillShow, object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(handleKeyboardWillHide), name: .UIKeyboardWillHide, object: nil)
    }
    
    func handleKeyboardWillHide(notification: NSNotification) {
         containerViewBottomAnchor?.constant = 0
    }
    
    func handleKeyboardWillShow(notification: NSNotification) {
        let keyboardFrame = (notification.userInfo? [UIKeyboardFrameEndUserInfoKey] as AnyObject).cgRectValue
        let keyboardDuration = (notification.userInfo? [UIKeyboardAnimationDurationUserInfoKey] as AnyObject).doubleValue
        
        containerViewBottomAnchor?.constant = -(keyboardFrame!.height)
        UIView.animate(withDuration: keyboardDuration!, animations: {self.view.layoutIfNeeded()})
    }
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        collectionView?.collectionViewLayout.invalidateLayout()
    }
    
    private func estimatedFrameForText (string: String) -> CGRect {
        let size = CGSize(width: 200, height: 1000)
        let options = NSStringDrawingOptions.usesFontLeading.union(.usesLineFragmentOrigin)
        
        return NSString(string: string).boundingRect(with: size, options: options, attributes: [NSFontAttributeName: UIFont.systemFont(ofSize: 16)], context: nil)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        var height: CGFloat = 80
        
        if let text = messages[indexPath.item].text {
            if messages[indexPath.item].senderID == sender.id {
                height = estimatedFrameForText(string: text).height + 20
            } else {
                height = estimatedFrameForText(string: text).height + 46
            }
                    }
        
        
        return CGSize(width: view.frame.width, height: height)
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return messages.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cellId", for: indexPath) as! ChatMessageCell
        
        let message = messages[indexPath.item]
        cell.textView.text = message.text!
        
        setUpCell(cell: cell, message: message)
        
        cell.bubbleWidthAnchor?.constant = estimatedFrameForText(string: messages[indexPath.item].text!).width + 32
        cell.senderNameView.text = message.name
        
        return cell
    }
    
    private func setUpCell(cell: ChatMessageCell, message: Message) {
        if message.senderID == sender.id {
            cell.bubbleView.backgroundColor = ChatMessageCell.blueColor
            cell.textView.textColor = UIColor.white
            cell.bubbleRightAnchor?.isActive = true
            cell.bubbleLeftAnchor?.isActive = false
            cell.senderNameView.isHidden = true
            cell.senderNameHeight?.constant = 0
            cell.bubbleHeight?.constant = 0
        } else {
            cell.bubbleView.backgroundColor = UIColor(r: 240, g: 240, b: 240)
            cell.textView.textColor = UIColor.black
            cell.bubbleRightAnchor?.isActive = false
            cell.bubbleLeftAnchor?.isActive = true
            cell.senderNameView.isHidden = false
            cell.bubbleHeight?.constant = -20
            cell.senderNameHeight?.constant = 20
        }
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
    
    var containerViewBottomAnchor: NSLayoutConstraint?
    
    func setupInputComponents() {
        //input area container
        let containerView = UIView()
        containerView.backgroundColor = UIColor.white
        containerView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(containerView)
        
        containerView.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        containerViewBottomAnchor = containerView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        containerViewBottomAnchor?.isActive = true
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
        
        self.inputTextField.text = nil
    }
}

