//
//  UserMessagesController.swift
//  CateChat
//
//  Created by Chayce Heiberg on 7/15/17.
//  Copyright © 2017 wsuv. All rights reserved.
//

import UIKit
import Firebase

class UserMessageController: UITableViewController {
    
    var ref = Database.database().reference()
    
    var messages = [Message]()
    var messagesDictionary = [String: Message]()
    
    var accounts = [Account]()
    
    let cellID = "CellID"
        
    override func viewDidLoad() {
        super.viewDidLoad()
        
        observeUserMessages()
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(AccountCell.self, forCellReuseIdentifier: cellID)
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Back", style: .plain, target: self, action: #selector(backToHome))
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "New Message", style: .plain, target: self, action: #selector(handleNewMessage))
        navigationItem.title = "Messages"
    }
    
    func backToHome() {
        dismiss(animated: true, completion: nil)
    }
    
    func handleNewMessage() {
        let navController = UINavigationController(rootViewController: NewMessageController())
        present(navController, animated: true, completion: nil)
    }
    
    func observeUserMessages() {
        
        guard let userID = Auth.auth().currentUser?.uid else {
            print("No user logged in ---observeUserMessage()")
            return
        }
        let ref = Database.database().reference().child("user-messages").child(userID)
        ref.observe(.childAdded, with: { (snapshot) in
            
            let messageId = snapshot.key
            let messageReference = Database.database().reference().child("messages").child(messageId)
            
            messageReference.observeSingleEvent(of: .value, with: { (snapshot) in
                
                if let dictionary = snapshot.value as? [String: AnyObject] {
                    let message = Message()
                    message.setValuesForKeys(dictionary)
                    self.messages.append(message)
                    
                    if let chatPartnerID = message.chatPartnerId() {
                        self.messagesDictionary[chatPartnerID] = message
                        self.messages = Array(self.messagesDictionary.values)
                        self.messages.sort(by: { (m1, m2) -> Bool in
                            return (m1.timeStamp?.intValue)! > (m2.timeStamp?.intValue)!
                        })
                    }
                    
                    DispatchQueue.main.async {
                        self.tableView.reloadData()
                    }
                }
            }, withCancel: nil)
            
        }, withCancel: nil)
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return messages.count
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 72
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellID, for: indexPath) as! AccountCell
        let message = messages[indexPath.row]
        cell.message = message
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let message = messages[indexPath.row]
        
        guard let chatPartnerID = message.chatPartnerId() else {
            print("Could not get chatPartnerID when row was selected")
            return
        }
        
        let ref = Database.database().reference().child("users").child(chatPartnerID)
        ref.observeSingleEvent(of: .value, with: { (snapshot) in
            
            guard let dictionary = snapshot.value as? [String: AnyObject] else {
                return
            }
            let account = Account(dictionary)
            account.id = chatPartnerID
            account.setValuesForKeys(dictionary)
            let chatController = ChatController(collectionViewLayout: UICollectionViewFlowLayout())
            chatController.account = account
            self.navigationController?.pushViewController(chatController, animated: true)
            
        }, withCancel: nil)
    }

}
