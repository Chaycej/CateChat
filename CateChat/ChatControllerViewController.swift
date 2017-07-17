//
//  ChatControllerViewController.swift
//  CateChat
//
//  Created by Chayce Heiberg on 7/15/17.
//  Copyright © 2017 wsuv. All rights reserved.
//

import UIKit
import Firebase

class ChatController: UICollectionViewController, UITextFieldDelegate, UICollectionViewDelegateFlowLayout {

    let ref = Database.database().reference()
    var messages = [Message]()
    
    var account: Account? {
        
        didSet {
            navigationItem.title = account?.name
            observeMessages()
        }
    }
    
    let cellID = "cellID"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        collectionView?.alwaysBounceVertical = true
        collectionView?.backgroundColor = UIColor.white
        collectionView?.register(MessageCell.self, forCellWithReuseIdentifier: cellID)
        
        view.addSubview(inputMessageContainer)
        view.addSubview(inputSeperator)
        inputMessageContainer.addSubview(sendButton)
        inputMessageContainer.addSubview(inputTextField)
        
        setupInputMessageContainer()
        setupInputSeperator()
        setupSendButton()
        setupInputTextField()
    }
    
    func observeMessages() {
        
        guard let uid = Auth.auth().currentUser?.uid else {
            print("No current user")
            return
        }
        
        let userMessagesReference = Database.database().reference().child("user-messages").child(uid)
        userMessagesReference.observe(.childAdded, with: { (snapshot) in
            
            let messageID = snapshot.key
            let messageRef = Database.database().reference().child("messages").child(messageID)
            messageRef.observeSingleEvent(of: .value, with: { (snapshot) in
                
                guard let dictionary = snapshot.value as? [String: AnyObject] else {
                    print("could not get snapshot value")
                    return
                }
                
                let message = Message()
                message.setValuesForKeys(dictionary)
                
                if message.chatPartnerId() == self.account?.id {
                    self.messages.append(message)
                    
                    DispatchQueue.main.async {
                        self.collectionView?.reloadData()
                    }
                }
                
            }, withCancel: nil)
            
        }, withCancel: nil)
    }
    
    func sendMessage() {
     
        let childRef = ref.child("messages").childByAutoId()
        let fromID = Auth.auth().currentUser!.uid
        let toID = account!.id!
        let timeStamp = Int(NSDate().timeIntervalSince1970)
        let values = ["text": inputTextField.text!, "toID": toID, "fromID": fromID, "timeStamp": timeStamp] as [String : Any]
//        childRef.updateChildValues(values)
        childRef.updateChildValues(values) { (error, ref) in
            if error != nil {
                print(error!)
                return
            }
            
            self.inputTextField.text = nil
            
            let userMessagesRef = Database.database().reference().child("user-messages").child(fromID)
            let messageID = childRef.key
            userMessagesRef.updateChildValues([messageID: 1])
            
            let recipientMessageRef = Database.database().reference().child("user-messages").child(toID)
            recipientMessageRef.updateChildValues([messageID: 1])
        }
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
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return messages.count
    }
    
    // Note: To change the actual font within the chat text views, you have to change the system font in the computed view height
    // "textViewHeight()"
    func textViewHeight(_ text: String) -> CGRect{
        
        let size = CGSize(width: 200, height: 1000)
        let options = NSStringDrawingOptions.usesFontLeading.union(.usesLineFragmentOrigin)
        
        return NSString(string: text).boundingRect(with: size, options: options, attributes: [NSFontAttributeName: UIFont.systemFont(ofSize: 16)], context: nil)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        var height: CGFloat = 100
        
        if let text = messages[indexPath.item].text {
            height = textViewHeight(text).height + 20
        }
        return CGSize(width: view.frame.width, height: height)
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellID, for: indexPath) as! MessageCell
        
        let message = messages[indexPath.row]
        
        cell.textView.text = message.text
        
        return cell
    }
    
}
