//
//  LoginController.swift
//  CateChat
//
//  Created by Chayce Heiberg on 7/12/17.
//  Copyright © 2017 wsuv. All rights reserved.
//

import UIKit
import Firebase

class LoginController: UIViewController {

    var homeController: HomeController?
    var ref = Database.database().reference()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = UIColor.white
        
        view.addSubview(cancelButton)
        view.addSubview(emailTextField)
        view.addSubview(passwordNameTextField)
        view.addSubview(signInButton)
        view.addSubview(forgotPasswordButton)
        
        
        setupcancelButton()
        setupEmailTextField()
        setupPasswordTextField()
        setupSignInButton()
        setupForgotPasswordButton()
    }
    
    override var prefersStatusBarHidden: Bool {
        get {
            return true
        }
    }
    
    let cancelButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("Cancel", for: UIControlState())
        button.titleLabel?.font = UIFont.systemFont(ofSize: 20)
        button.titleLabel?.adjustsFontSizeToFitWidth = true
        button.setTitleColor(UIColor(r: 142, g: 68, b: 61), for: UIControlState())
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
        button.backgroundColor = UIColor(r: 142, g: 68, b: 61)
        button.setTitle("Sign In", for: UIControlState())
        button.setTitleColor(UIColor.white, for: UIControlState())
        button.addTarget(self, action: #selector(signInUser), for: .touchUpInside)
        button.layer.cornerRadius = 5
        return button
    }()
    
    lazy var forgotPasswordButton: UIButton = {
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.backgroundColor = UIColor.white
        button.setTitle("Forgot Password?", for: UIControlState())
        button.setTitleColor(UIColor.black, for: UIControlState())
        button.addTarget(self, action: #selector(forgotPassword), for: .touchUpInside)
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
        emailTextField.heightAnchor.constraint(equalToConstant: 20).isActive = true
    }
    
    func setupPasswordTextField() {
        passwordNameTextField.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        passwordNameTextField.topAnchor.constraint(equalTo: emailTextField.bottomAnchor, constant: 30).isActive = true
        passwordNameTextField.widthAnchor.constraint(equalToConstant: 2 * view.bounds.width/3).isActive = true
        passwordNameTextField.heightAnchor.constraint(equalToConstant: 20).isActive = true
    }
    
    func setupSignInButton() {
        signInButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        signInButton.topAnchor.constraint(equalTo: passwordNameTextField.bottomAnchor, constant: 40).isActive = true
        signInButton.widthAnchor.constraint(equalToConstant: view.bounds.width/2).isActive = true
        signInButton.heightAnchor.constraint(equalToConstant: 50).isActive = true
    }
    
    func setupForgotPasswordButton() {
        forgotPasswordButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        forgotPasswordButton.topAnchor.constraint(equalTo: signInButton.bottomAnchor, constant: 30).isActive = true
        forgotPasswordButton.heightAnchor.constraint(equalToConstant: 30).isActive = true
        forgotPasswordButton.widthAnchor.constraint(equalToConstant: view.bounds.width/2).isActive = true
    }
    
}
