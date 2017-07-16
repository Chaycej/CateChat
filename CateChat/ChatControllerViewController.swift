//
//  ChatControllerViewController.swift
//  CateChat
//
//  Created by Chayce Heiberg on 7/15/17.
//  Copyright © 2017 wsuv. All rights reserved.
//

import UIKit
import Firebase

class ChatController: UICollectionViewController, UITextFieldDelegate {

    let ref = Database.database().reference().child("messages")
    var account: Account? {
        
        didSet {
            navigationItem.title = account?.name
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        collectionView?.backgroundColor = UIColor.white
        
        view.addSubview(inputMessageContainer)
        view.addSubview(inputSeperator)
        inputMessageContainer.addSubview(sendButton)
        inputMessageContainer.addSubview(inputTextField)
        
        setupInputMessageContainer()
        setupInputSeperator()
        setupSendButton()
        setupInputTextField()
    }
    
    func sendMessage() {
     
        let childRef = ref.childByAutoId()
        let fromID = Auth.auth().currentUser!.uid
        let timeStamp = Int(NSDate().timeIntervalSince1970)
        let values = ["text": inputTextField.text!, "toID": account!.id!, "fromID": fromID, "timeStamp": timeStamp] as [String : Any]
        childRef.updateChildValues(values)
        observeMessages()
    }
    
    func observeMessages() {
        
        ref.observe(.childAdded, with: { (snapshot) in
            
            if let dictionary = snapshot.value as? [String: AnyObject] {
                let message = Message()
                message.setValuesForKeys(dictionary)
                print(message.text)
            }
        }, withCancel: nil)
    }
    

    let inputMessageContainer: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = UIColor.white
        return view
    }()
    let inputSeperator: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = UIColor.gray
        return view
    }()
    
    let sendButton: UIButton = {
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("Send", for: UIControlState())
        button.setTitleColor(UIColor.red, for: UIControlState())
        button.backgroundColor = UIColor.white
        button.addTarget(self, action: #selector(sendMessage), for: .touchUpInside)
        return button
    }()
    
    lazy var inputTextField: UITextField = {
        let tf = UITextField()
        tf.delegate = self
        tf.translatesAutoresizingMaskIntoConstraints = false
        tf.placeholder = "Enter a message..."
        return tf
    }()
    
    func setupInputMessageContainer() {
        inputMessageContainer.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        inputMessageContainer.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        inputMessageContainer.widthAnchor.constraint(equalToConstant: view.bounds.width).isActive = true
        inputMessageContainer.heightAnchor.constraint(equalToConstant: 50).isActive = true
    }
    
    func setupInputSeperator() {
        inputSeperator.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        inputSeperator.bottomAnchor.constraint(equalTo: inputMessageContainer.topAnchor).isActive = true
        inputSeperator.widthAnchor.constraint(equalToConstant: view.bounds.width).isActive = true
        inputSeperator.heightAnchor.constraint(equalToConstant: 1).isActive = true
    }
    
    func setupSendButton() {
        sendButton.rightAnchor.constraint(equalTo: inputMessageContainer.rightAnchor).isActive = true
        sendButton.centerYAnchor.constraint(equalTo: inputMessageContainer.centerYAnchor).isActive = true
        sendButton.widthAnchor.constraint(equalToConstant: 80).isActive = true
        sendButton.heightAnchor.constraint(equalTo: inputMessageContainer.heightAnchor).isActive = true
    }
    
    func setupInputTextField() {
        inputTextField.leftAnchor.constraint(equalTo: inputMessageContainer.leftAnchor, constant: 8).isActive = true
        inputTextField.centerYAnchor.constraint(equalTo: inputMessageContainer.centerYAnchor).isActive = true
        inputTextField.rightAnchor.constraint(equalTo: sendButton.leftAnchor).isActive = true
        inputTextField.heightAnchor.constraint(equalTo: inputMessageContainer.heightAnchor).isActive = true
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        sendMessage()
        return true
    }
    
}
