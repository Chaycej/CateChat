//
//  LoginController.swift
//  CateChat
//
//  Created by Chayce Heiberg on 7/12/17.
//  Copyright © 2017 wsuv. All rights reserved.
//

import UIKit
import Firebase

class LoginViewController: UIViewController {

    var homeController: HomeViewController?
    var ref = Database.database().reference()
    var keyboardAdjusted = false
    var lastKeyboardOffset: CGFloat = 0.0
    
    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = UIColor.white
        
        view.addSubview(cancelButton)
        view.addSubview(emailTextField)
        view.addSubview(passwordNameTextField)
        view.addSubview(signInButton)
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(backgroundTapped))
        view.addGestureRecognizer(tapGesture)

        setupcancelButton()
        setupEmailTextField()
        setupPasswordTextField()
        setupSignInButton()
    }
    
    override var prefersStatusBarHidden: Bool {
        get {
            return true
        }
    }
    
    @objc func backgroundTapped() {
        view.endEditing(true)
    }
    
    let cancelButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("Cancel", for: UIControlState())
        button.titleLabel?.font = UIFont.systemFont(ofSize: 20)
        button.titleLabel?.adjustsFontSizeToFitWidth = true
        button.setTitleColor(UIColor(r: 123, g: 158, b: 168), for: UIControlState())
        button.backgroundColor = UIColor.white
        button.addTarget(self, action: #selector(cancelSignIn), for: .touchUpInside)
        return button
    }()
    
    lazy var emailTextField: UITextField = {
        let tf = UITextField()
        tf.translatesAutoresizingMaskIntoConstraints = false
        tf.textAlignment = .center
        tf.placeholder = "Email"
        tf.layer.cornerRadius = 5
        tf.borderStyle = .roundedRect
        return tf
    }()
    
    lazy var passwordNameTextField: UITextField = {
        let tf = UITextField()
        tf.translatesAutoresizingMaskIntoConstraints = false
        tf.textAlignment = .center
        tf.placeholder = "Password"
        tf.isSecureTextEntry = true
        tf.layer.cornerRadius = 5
        tf.borderStyle = .roundedRect
        return tf
    }()
    
    lazy var signInButton: UIButton  = {
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.backgroundColor = UIColor(r: 123, g: 158, b: 168)
        button.setTitle("Sign In", for: UIControlState())
        button.setTitleColor(UIColor.white, for: UIControlState())
        button.addTarget(self, action: #selector(signInUser), for: .touchUpInside)
        button.layer.cornerRadius = 5
        return button
    }()
    
    func setupcancelButton() {
        cancelButton.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 10).isActive = true
        cancelButton.topAnchor.constraint(equalTo: view.topAnchor, constant: 10).isActive = true
        cancelButton.widthAnchor.constraint(equalToConstant: 60).isActive = true
        cancelButton.heightAnchor.constraint(equalToConstant: 60).isActive = true
    }
    
    func setupEmailTextField() {
        emailTextField.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        emailTextField.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: -50).isActive = true
        emailTextField.widthAnchor.constraint(equalToConstant: 2 * view.bounds.width/3).isActive = true
        emailTextField.heightAnchor.constraint(equalToConstant: 35).isActive = true
    }
    
    func setupPasswordTextField() {
        passwordNameTextField.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        passwordNameTextField.topAnchor.constraint(equalTo: emailTextField.bottomAnchor, constant: 30).isActive = true
        passwordNameTextField.widthAnchor.constraint(equalToConstant: 2 * view.bounds.width/3).isActive = true
        passwordNameTextField.heightAnchor.constraint(equalToConstant: 35).isActive = true
    }
    
    func setupSignInButton() {
        signInButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        signInButton.topAnchor.constraint(equalTo: passwordNameTextField.bottomAnchor, constant: 40).isActive = true
        signInButton.widthAnchor.constraint(equalToConstant: view.bounds.width/2).isActive = true
        signInButton.heightAnchor.constraint(equalToConstant: 50).isActive = true
    }
}
