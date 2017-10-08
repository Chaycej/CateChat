//
//  SettingsController.swift
//  CateChat
//
//  Created by Chayce Heiberg on 7/16/17.
//  Copyright © 2017 wsuv. All rights reserved.
//

import UIKit
import Firebase

class SettingsViewController: UIViewController {
    
    var homeController: HomeViewController?
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
        view.addSubview(updateUsernameButton)
        
        setupUserNameLabel()
        setupUsernameTextField()
        setupUpdateUsernameButton()
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Back", style: .plain, target: self, action: #selector(presentHomeViewController))
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(true)
        self.account = homeController?.account
    }
    
    @objc func presentHomeViewController() {
//        let homeController = HomeController()
//        homeController.account = account
//        let navController = UINavigationController(rootViewController: homeController)
//        present(navController, animated: true, completion: nil)
        if let present = presentingViewController as? HomeViewController {
            present.account = account
        }
        dismiss(animated: true, completion: nil)
    }
        
    @objc func updateUser() {
        print("hello")
        guard let username = usernameTextField.text, let uid = Auth.auth().currentUser?.uid else {
            print("Problem with textField")
            return
        }
        let usernameRef = Database.database().reference().child("users").child(uid)
        usernameRef.updateChildValues(["name": username])
        self.account?.name = usernameRef.child("name").key
        presentHomeViewController()
    }
    
    lazy var userNameLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.backgroundColor = UIColor.white
        label.textAlignment = .center
        label.textColor = UIColor.black
        label.text = " Change username"
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
    
    lazy var updateUsernameButton: UIButton = {
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("Update User", for: UIControlState())
        button.setTitleColor(UIColor.white, for: UIControlState())
        button.backgroundColor = UIColor(r: 0, g: 52, b: 89)
        button.layer.cornerRadius = 5
        button.addTarget(self, action: #selector(updateUser), for: .touchUpInside)
        return button
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
    
    func setupUpdateUsernameButton() {
        updateUsernameButton.topAnchor.constraint(equalTo: usernameTextField.bottomAnchor, constant: 20).isActive = true
        updateUsernameButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        updateUsernameButton.widthAnchor.constraint(equalToConstant: 140).isActive = true
        updateUsernameButton.heightAnchor.constraint(equalToConstant: 40).isActive = true
    }
}
