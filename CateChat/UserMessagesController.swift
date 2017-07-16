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
        
        loadUserMessages()
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(AccountCell.self, forCellReuseIdentifier: cellID)
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Back", style: .plain, target: self, action: #selector(backToHome))
        navigationItem.title = "Messages"
    }
    
    func backToHome() {
        dismiss(animated: true, completion: nil)
    }
    
    func loadUserMessages() {
        
        guard let uid = Auth.auth().currentUser?.uid else {
            print("Could not fetch a logged in user")
            return
        }
        
        ref.child("user-messages").child(uid).observe(.childAdded, with: { (snapshot) in
            
            print("userMessages")
            print(snapshot)
            print("Snapshot key is \(snapshot.key)")
            let messageID = snapshot.key
            let messagesReference = Database.database().reference().child("messages").child(messageID)
            messagesReference.observeSingleEvent(of: .value, with: { (snapshot) in
                
                print(snapshot)
                
                if let dictionary = snapshot.value as? [String: AnyObject] {
                    let message = Message()
                    message.setValuesForKeys(dictionary)
                    self.messages.append(message)
                    
                    if let toID = message.toID {
                        self.messagesDictionary[toID] = message
                        
                        self.messages = Array(self.messagesDictionary.values)
                        self.messages.sort(by: { (m1, m2) -> Bool in
                            (m1.timeStamp?.intValue)! > (m2.timeStamp?.intValue)!
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
}
