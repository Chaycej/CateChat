//
//  HomeController.swift
//  CateChat
//
//  Created by Chayce Heiberg on 7/12/17.
//  Copyright © 2017 wsuv. All rights reserved.
//

import UIKit
import Firebase

class HomeController: UIViewController {

    var ref = Database.database().reference()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        view.backgroundColor = UIColor.white
        
        setupNavigationItems()
        checkIfUserIsLoggedIn()
    }
    
    func setupNavigationItems() {
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Logout", style: .plain, target: self, action: #selector(handleLogout))
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Message", style: .plain, target: self, action: #selector(handleNewMessage))
        let currentUser = Auth.auth().currentUser
        navigationItem.title = currentUser?.displayName
    }
    
    func handleNewMessage() {
        let navController = UINavigationController(rootViewController: MessageController())
        present(navController, animated: true, completion: nil)
    }
    
    func handleLogout() {
        
        do {
            try Auth.auth().signOut()
        } catch let logoutError {
            print(logoutError)
        }
        
        let accountController = AccountController()
        present(accountController, animated: true, completion: nil)
    }
    
    func getUser() {
        
        guard let uid = Auth.auth().currentUser?.uid else{
            print("Could not retrieve user")
            return
        }
        
        ref.child("users").child(uid).observe(.value, with: { (snapshot) in
            
            if let dictionary = snapshot.value as? [String: AnyObject] {
                let user = Account()
                self.navigationItem.title = user.name
            }
        } , withCancel: nil)
    }

    
    func checkIfUserIsLoggedIn() {
        
        if Auth.auth().currentUser?.uid == nil {
            perform(#selector(handleLogout), with: nil, afterDelay: 0)
        } else {
            let uid = Auth.auth().currentUser?.uid
            ref.child("users").child(uid!).observeSingleEvent(of: .value, with: { (snapshot) in
                
                if let dictionary = snapshot.value as? [String: AnyObject] {
                    self.navigationItem.title = dictionary["name"] as? String
                }
                
            }, withCancel: nil)
        }
    }
    
    let settingsButton: UIButton = {
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("Settings", for: UIControlState())
        button.setTitleColor(UIColor.black, for: UIControlState())
        button.layer.cornerRadius = 5
        button.layer.masksToBounds = true
        return button
    }()

}
