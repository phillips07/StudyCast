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
        collectionView?.contentInset = UIEdgeInsets(top: 8, left: 0, bottom: 8, right: 0)
        collectionView?.register(ChatMessageCell.self, forCellWithReuseIdentifier: "cellId")
        
        collectionView?.keyboardDismissMode = .interactive
        
        observeMessages()
    }
    
    lazy var inputContainerView: UIView = {
        let containerView = UIView()
        containerView.frame = CGRect(x: 0, y: 0, width: self.view.frame.width, height: 50)
        containerView.backgroundColor = UIColor.white
        
        let uploadImageView = UIImageView()
        uploadImageView.isUserInteractionEnabled = true
        uploadImageView.image = UIImage(named: "add_photos")
        uploadImageView.translatesAutoresizingMaskIntoConstraints = false
        uploadImageView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleUploadTap)))
        containerView.addSubview(uploadImageView)
        //x,y,w,h
        uploadImageView.leftAnchor.constraint(equalTo: containerView.leftAnchor).isActive = true
        uploadImageView.centerYAnchor.constraint(equalTo: containerView.centerYAnchor).isActive = true
        uploadImageView.widthAnchor.constraint(equalToConstant: 44).isActive = true
        uploadImageView.heightAnchor.constraint(equalToConstant: 44).isActive = true
        
        
        let sendButton = UIButton(type: .system)
        sendButton.setTitle("Send", for: .normal)
        sendButton.translatesAutoresizingMaskIntoConstraints = false
        sendButton.addTarget(self, action: #selector(handleSend), for: .touchUpInside)
        containerView.addSubview(sendButton)
        //x,y,w,h
        sendButton.rightAnchor.constraint(equalTo: containerView.rightAnchor).isActive = true
        sendButton.centerYAnchor.constraint(equalTo: containerView.centerYAnchor).isActive = true
        sendButton.widthAnchor.constraint(equalToConstant:  80).isActive = true
        sendButton.heightAnchor.constraint(equalTo: containerView.heightAnchor).isActive = true
        
        containerView.addSubview(self.inputTextField)
        //x,y,w,h
        self.inputTextField.leftAnchor.constraint(equalTo: uploadImageView.rightAnchor, constant: 8).isActive = true
        self.inputTextField.centerYAnchor.constraint(equalTo: containerView.centerYAnchor).isActive = true
        self.inputTextField.rightAnchor.constraint(equalTo: sendButton.leftAnchor).isActive = true
        self.inputTextField.heightAnchor.constraint(equalTo: containerView.heightAnchor).isActive = true
        
        let separatorLineView = UIView()
        separatorLineView.backgroundColor = UIColor(r: 220, g: 220, b: 220)
        separatorLineView.translatesAutoresizingMaskIntoConstraints = false
        containerView.addSubview(separatorLineView)
        //x,y,w,h
        separatorLineView.leftAnchor.constraint(equalTo: containerView.leftAnchor).isActive = true
        separatorLineView.topAnchor.constraint(equalTo: containerView.topAnchor).isActive = true
        separatorLineView.widthAnchor.constraint(equalTo: containerView.widthAnchor).isActive = true
        separatorLineView.heightAnchor.constraint(equalToConstant: 1).isActive = true
        
        return containerView
    }()
    
    func handleUploadTap() {
        
    }

    override var inputAccessoryView: UIView? {
        get {
            return inputContainerView
        }
    }
    override var canBecomeFirstResponder: Bool {
        get {
            return true
        }
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        
        NotificationCenter.default.removeObserver(self)
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
        
        let width = UIScreen.main.bounds.width
        return CGSize(width: width, height: height)
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
    
    func handleSend() {
        let ref = FIRDatabase.database().reference().child("groups").child(group.id!).child("messages")
        let childRef = ref.childByAutoId()
        
        let timeStamp = Int(NSDate().timeIntervalSince1970)
        
        let value = ["text" : inputTextField.text!, "name" : sender.name!, "timeStamp" : timeStamp, "senderID" : sender.id!] as [String : Any]
        childRef.updateChildValues(value)
        
        self.inputTextField.text = nil
    }
}

