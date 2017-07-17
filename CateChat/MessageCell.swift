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
        return view
    }()
    
    let backgroundTextView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = UIColor(r: 232, g: 95, b: 92)
        view.layer.cornerRadius = 5
        return view
    }()
    
    func setupTextView() {
        textView.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -2).isActive = true
        textView.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        textView.widthAnchor.constraint(equalToConstant: 200).isActive = true
        textView.heightAnchor.constraint(equalTo: self.heightAnchor).isActive = true
    }
    
    func setupBackgroundTextView() {
        backgroundTextView.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -2).isActive = true
        backgroundTextView.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        backgroundTextView.widthAnchor.constraint(equalToConstant: 200).isActive = true
        backgroundTextView.heightAnchor.constraint(equalTo: self.heightAnchor).isActive = true

    }
}
