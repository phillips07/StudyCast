//
//  ChatMessageCell.swift
//  StudyCast
//
//  Created by Austin Phillips on 2016-11-28.
//  Copyright © 2016 Austin Phillips. All rights reserved.
//

import UIKit

class ChatMessageCell: UICollectionViewCell {
    
    let textView: UITextView = {
        let tv = UITextView()
        tv.font = UIFont.systemFont(ofSize: 16)
        tv.translatesAutoresizingMaskIntoConstraints = false
        tv.backgroundColor = UIColor.clear
        tv.textColor = .white
        return tv
    }()
    
    let senderNameView: UILabel = {
        let tv = UILabel()
        tv.font = UIFont.systemFont(ofSize: 12)
        tv.translatesAutoresizingMaskIntoConstraints = false
        tv.backgroundColor = UIColor.clear
        tv.textColor = .black
        return tv
    }()
    
    static let blueColor = UIColor(r: 0, g: 137, b: 249)
    
    let bubbleView: UIView = {
        let bv = UIView()
        bv.backgroundColor = blueColor
        bv.translatesAutoresizingMaskIntoConstraints = false
        bv.layer.cornerRadius = 16
        bv.layer.masksToBounds = true
        return bv
    }()
    
    var bubbleWidthAnchor: NSLayoutConstraint?
    var bubbleRightAnchor: NSLayoutConstraint?
    var bubbleLeftAnchor: NSLayoutConstraint?
    var bubbleHeight: NSLayoutConstraint?
    var senderNameHeight: NSLayoutConstraint?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        

        addSubview(bubbleView)
        addSubview(textView)
        addSubview(senderNameView)
        
        senderNameView.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 8).isActive = true
        senderNameView.topAnchor.constraint(equalTo: self.topAnchor, constant: 6).isActive = true
        senderNameView.widthAnchor.constraint(equalTo: self.widthAnchor).isActive = true
        senderNameHeight = senderNameView.heightAnchor.constraint(equalToConstant: 20)
        senderNameHeight?.isActive = true
        
        
        
        bubbleLeftAnchor = bubbleView.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 8)
        bubbleRightAnchor = bubbleView.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -8)
        bubbleRightAnchor?.isActive = true
        bubbleView.topAnchor.constraint(equalTo: senderNameView.bottomAnchor).isActive = true
        bubbleHeight = bubbleView.heightAnchor.constraint(equalTo: self.heightAnchor)
        bubbleHeight?.isActive = true
        bubbleWidthAnchor = bubbleView.widthAnchor.constraint(equalToConstant: 200)
        bubbleWidthAnchor?.isActive = true
        
        textView.leftAnchor.constraint(equalTo: bubbleView.leftAnchor, constant: 8).isActive = true
        textView.rightAnchor.constraint(equalTo: bubbleView.rightAnchor).isActive = true
        textView.topAnchor.constraint(equalTo: bubbleView.topAnchor).isActive = true
        textView.heightAnchor.constraint(equalTo: bubbleView.heightAnchor).isActive = true
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("Errorrrrrrr")
    }
    
}
