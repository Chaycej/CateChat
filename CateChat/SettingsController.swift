//
//  SettingsController.swift
//  CateChat
//
//  Created by Chayce Heiberg on 7/16/17.
//  Copyright © 2017 wsuv. All rights reserved.
//

import UIKit
import Firebase

class SettingsController: UIViewController {
    
    var account: Account? {
        didSet {
            usernameTextField.placeholder = account?.name
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = UIColor.white
        
        navigationItem.title = "Settings"
        view.addSubview(userNameLabel)
        view.addSubview(usernameTextField)
        
        setupUserNameLabel()
        setupUsernameTextField()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(true)
        updateUser()
    }
    
//    func fetchUser() {
//        guard let uid = Auth.auth().currentUser?.uid else {
//            print("Could not fetch user uid")
//            return
//        }
//        
//        Database.database().reference().child("users").child(uid).observeSingleEvent(of: .value, with: { (snapshot) in
//            
//            if let dictionary = snapshot.value as? [String: AnyObject] {
//                let account = Account(dictionary)
//                self.account? = account
//            }
//        }, withCancel: nil)
//    }
    
    func updateUser() {
        guard let username = usernameTextField.text, let uid = self.account?.id! else {
            print("Culd not")
            return
        }
        print("hello")
        Database.database().reference().child("users").child(uid).observeSingleEvent(of: .value, with: { (snapshot) in
            print("hey")
            print(snapshot)
        }, withCancel: nil)
    }
    
    lazy var userNameLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.backgroundColor = UIColor.white
        label.textAlignment = .center
        label.textColor = UIColor.black
        label.text = "username"
        return label
    }()
    
    lazy var usernameTextField: UITextField = {
        let tf = UITextField()
        tf.translatesAutoresizingMaskIntoConstraints = false
        tf.textAlignment = .center
        tf.placeholder = "name"
        tf.layer.cornerRadius = 5
        tf.borderStyle = .roundedRect
        return tf
    }()

    func setupUserNameLabel() {
        userNameLabel.bottomAnchor.constraint(equalTo: usernameTextField.topAnchor, constant: -12).isActive = true
        userNameLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        userNameLabel.widthAnchor.constraint(equalTo: usernameTextField.widthAnchor).isActive = true
        userNameLabel.heightAnchor.constraint(equalToConstant: 20).isActive = true
    }
    
    func setupUsernameTextField() {
        usernameTextField.topAnchor.constraint(equalTo: view.topAnchor, constant: 200).isActive = true
        usernameTextField.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        usernameTextField.widthAnchor.constraint(equalToConstant: 2*view.bounds.width/3).isActive = true
        usernameTextField.heightAnchor.constraint(equalToConstant: 20).isActive = true
    }
}
