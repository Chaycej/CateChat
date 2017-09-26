//
//  ChatControllerViewController.swift
//  CateChat
//
//  Created by Chayce Heiberg on 7/15/17.
//  Copyright © 2017 wsuv. All rights reserved.
//

import UIKit
import Firebase
import TKKeyboardControl

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
    
    // Mark: ViewController lifeycle ------------------------------------------
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        collectionView?.alwaysBounceVertical = true
        collectionView?.backgroundColor = UIColor.white
        collectionView?.register(MessageCell.self, forCellWithReuseIdentifier: cellID)
        collectionView?.contentInset = UIEdgeInsets(top: 8, left: 0, bottom: 58, right: 0)
        collectionView?.scrollIndicatorInsets = UIEdgeInsets(top: 0, left: 0, bottom: 50, right: 0)
        collectionView?.keyboardDismissMode = .interactive
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(backgroundTapped))
        view.addGestureRecognizer(tapGesture)
        
        view.addSubview(inputMessageContainer)
        view.addSubview(inputSeperator)
        inputMessageContainer.addSubview(sendButton)
        inputMessageContainer.addSubview(inputTextField)
        
        setupInputMessageContainer()
        setupInputSeperator()
        setupSendButton()
        setupInputTextField()
        
        //setupkeyboard()
        self.view.keyboardTriggerOffset = inputMessageContainer.bounds.height
        self.view.addKeyboardPanningWithFrameBasedActionHandler({ [weak self](keyboardFrameInView, opening, closing) in
            
            guard let weakSelf = self else {
                return
            }
            
            weakSelf.inputMessageContainer.frame.origin.y = keyboardFrameInView.origin.y - weakSelf.inputMessageContainer.frame.height
            weakSelf.inputSeperator.frame.origin.y = keyboardFrameInView.origin.y - weakSelf.inputMessageContainer.frame.height
            
        }, constraintBasedActionHandler: nil)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        
        inputMessageContainerBottomConstant = (inputMessageContainerBottomAnchor?.constant)!
    }
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        collectionView?.collectionViewLayout.invalidateLayout()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(true)
    }
    
    func observeMessages() {
        
        guard let uid = Auth.auth().currentUser?.uid, let toID = account?.id else {
            print("No current user")
            return
        }
        
        let userMessagesReference = Database.database().reference().child("user-messages").child(uid).child(toID)
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
                self.messages.append(message)
                DispatchQueue.main.async(execute: {
                    self.collectionView?.reloadData()
                    //scroll to the last index
                    let indexPath = IndexPath(item: self.messages.count - 1, section: 0)
                    self.collectionView?.scrollToItem(at: indexPath, at: .bottom, animated: false)
                })
            }, withCancel: nil)
        }, withCancel: nil)
    }
    
    func sendMessage() {
        
        if inputTextField.text == "" {
            return
        }
        
        let childRef = ref.child("messages").childByAutoId()
        let fromID = Auth.auth().currentUser!.uid
        let toID = account!.id!
        let timeStamp = Int(NSDate().timeIntervalSince1970)
        let values = ["text": inputTextField.text!, "toID": toID, "fromID": fromID, "timeStamp": timeStamp] as [String : Any]
        childRef.updateChildValues(values) { (error, ref) in
            if error != nil {
                print(error!)
                return
            }
            self.inputTextField.text = nil
            let userMessagesRef = Database.database().reference().child("user-messages").child(fromID)
            .child(toID)
            let messageID = childRef.key
            userMessagesRef.updateChildValues([messageID: 1])
            
            Database.database().reference().child("user-messages").child(toID).child(fromID).updateChildValues([messageID: 1])
        }
        if messages.count > 0 {
            let indexPath = IndexPath(item: self.messages.count - 1, section: 0)
            self.collectionView?.scrollToItem(at: indexPath, at: .bottom, animated: false)
        }
    }
    
    // Mark: Views
    
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
        button.setTitleColor(UIColor(r: 29, g: 78, b: 137), for: UIControlState())
        button.backgroundColor = UIColor.white
        button.addTarget(self, action: #selector(sendMessage), for: .touchUpInside)
        return button
    }()
    
    lazy var inputTextField: UITextField = {
        let tf = UITextField()
        tf.translatesAutoresizingMaskIntoConstraints = false
        tf.delegate = self
        tf.placeholder = "Enter a message..."
        return tf
    }()
    
    // Mark: View Constraints (x, y, width, height)
    
    var inputMessageContainerBottomAnchor: NSLayoutConstraint?
    var inputMessageContainerTopAnchor: NSLayoutConstraint?
    var inputMessageContainerBottomConstant: CGFloat = 0.0
    
    func setupInputMessageContainer() {
        inputMessageContainer.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        inputMessageContainerBottomAnchor = inputMessageContainer.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        inputMessageContainerBottomAnchor?.isActive = true
        inputMessageContainerTopAnchor?.isActive = true
        inputMessageContainer.widthAnchor.constraint(equalToConstant: view.bounds.width).isActive = true
        inputMessageContainer.heightAnchor.constraint(equalToConstant: 50).isActive = true
    }
    
    func setupInputSeperator() {
        inputSeperator.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        inputSeperator.bottomAnchor.constraint(equalTo: inputTextField.topAnchor).isActive = true
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
    
    // Mark: CollectionView functions
    
    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return messages.count
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        var height: CGFloat = 100
        
        if let text = messages[indexPath.item].text {
            height = textViewHeight(text).height + 20
        }
        
        
        return CGSize(width: view.frame.width, height: height)
    }
    
    func textViewHeight(_ text: String) -> CGRect{
        
        let size = CGSize(width: 200, height: 1000)
        let options = NSStringDrawingOptions.usesFontLeading.union(.usesLineFragmentOrigin)
        
        return NSString(string: text).boundingRect(with: size, options: options, attributes: [NSFontAttributeName: UIFont.systemFont(ofSize: 16)], context: nil)
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellID, for: indexPath) as! MessageCell
        
        let message = messages[indexPath.row]
        
        cell.textView.text = message.text
        
        if message.fromID == Auth.auth().currentUser?.uid {
            cell.backgroundTextView.backgroundColor = UIColor(r: 29, g: 78, b: 137)
            cell.backgroundLeftAnchor?.isActive = false
            cell.backgroundRightAnchor?.isActive = true
        } else {
            cell.backgroundTextView.backgroundColor = UIColor(r: 200, g: 200, b: 200)
            cell.backgroundRightAnchor?.isActive = false
            cell.backgroundLeftAnchor?.isActive = true
        }
        
        cell.backgroundWidthAnchor?.constant = textViewHeight(message.text!).width + 20
    
        return cell
    }
    
    func backgroundTapped() {
        view.endEditing(true)
    }
}
