//
//  MessageCell.swift
//  CateChat
//
//  Created by Chayce Heiberg on 7/17/17.
//  Copyright © 2017 wsuv. All rights reserved.
//

import UIKit

class MessageCell: UICollectionViewCell {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
    
        addSubview(backgroundTextView)
        addSubview(textView)
        
        setupTextView()
        setupBackgroundTextView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    let textView: UITextView = {
        let view = UITextView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.text = "TExt"
        view.font = UIFont.systemFont(ofSize: 16)
        view.backgroundColor = UIColor.clear
        view.textColor = UIColor.white
        view.isEditable = false
        view.isScrollEnabled = false
        return view
    }()
    
    let backgroundTextView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        // Set background color in the controller based on chat ID
        view.layer.cornerRadius = 5
        return view
    }()
    
    func setupTextView() {
        textView.leftAnchor.constraint(equalTo: backgroundTextView.leftAnchor, constant: 4).isActive = true
        textView.rightAnchor.constraint(equalTo: backgroundTextView.rightAnchor, constant: -4).isActive = true
        textView.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        textView.widthAnchor.constraint(equalToConstant: 200).isActive = true
        textView.heightAnchor.constraint(equalTo: self.heightAnchor, constant: 10).isActive = true
    }
    
    var backgroundWidthAnchor: NSLayoutConstraint?
    var backgroundRightAnchor: NSLayoutConstraint?
    var backgroundLeftAnchor: NSLayoutConstraint?
    
    func setupBackgroundTextView() {
        backgroundTextView.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        backgroundRightAnchor = backgroundTextView.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -2)
        backgroundRightAnchor?.isActive = false
        backgroundLeftAnchor = backgroundTextView.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 2)
        backgroundLeftAnchor?.isActive = false
        backgroundWidthAnchor = backgroundTextView.widthAnchor.constraint(equalToConstant: 200)
        backgroundWidthAnchor?.isActive = true
        backgroundTextView.heightAnchor.constraint(equalTo: self.heightAnchor).isActive = true
    }
}
