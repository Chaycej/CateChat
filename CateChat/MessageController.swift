//
//  MessageController.swift
//  CateChat
//
//  Created by Chayce Heiberg on 7/13/17.
//  Copyright © 2017 wsuv. All rights reserved.
//

import UIKit
import Firebase

class MessageController: UITableViewController {

    var cellID = "CellID"
    var ref = Database.database().reference()
    var accounts = [Account]()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(AccountCell.self, forCellReuseIdentifier: cellID)
        
        setupNavigationItems()
        fetchUser()
    }
    
    func setupNavigationItems() {
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(cancelMessage))
    }
    
    func cancelMessage() {
        dismiss(animated: true, completion: nil)
    }
    
    // Append users from database into model
    func fetchUser() {
        ref.child("users").observe(.childAdded, with: { (snapshot) in
            
            if let dictionary = snapshot.value as? [String: AnyObject] {
                
                let account = Account()
                account.id = snapshot.key
                account.setValuesForKeys(dictionary)
                self.accounts.append(account)
                
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }
            }
            
        }, withCancel: nil)
    }
}

// TableView datasource and delegate
extension MessageController {
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return accounts.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: cellID, for: indexPath) as! AccountCell
        let account = accounts[indexPath.row]
        cell.textLabel?.text = accounts[indexPath.row].name
        
        if let profileImageURL = account.profileImageURL {
            cell.profileImageView.loadImageUsingCacheWithURLString(URLString: profileImageURL)
        }
        return cell
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 92
    }
    
    override func tableView(_ tableView: UITableView, willSelectRowAt indexPath: IndexPath) -> IndexPath? {
        
        let account = accounts[indexPath.row]
        let chatController = ChatController(collectionViewLayout: UICollectionViewFlowLayout())
        chatController.account = account
        navigationController?.pushViewController(chatController, animated: true)
        return indexPath
    }
}
