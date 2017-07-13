//
//  RegisterController.swift
//  CateChat
//
//  Created by Chayce Heiberg on 7/12/17.
//  Copyright © 2017 wsuv. All rights reserved.
//

import UIKit
import Firebase

class RegisterController: UIViewController {

    var ref = Database.database().reference()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = UIColor.white
        
        view.addSubview(profileImageView)
        view.addSubview(profileImageLabel)
        view.addSubview(cancelButton)
        view.addSubview(userNameTextField)
        view.addSubview(emailTextField)
        view.addSubview(passwordNameTextField)
        view.addSubview(registerButton)
        
        setupProfileImageView()
        setupProfileImageLabel()
        setupcancelButton()
        setupUserNameTextField()
        setupEmailTextField()
        setupPasswordTextField()
        setupRegisterButton()
    }

    override var prefersStatusBarHidden: Bool {
        get {
            return true
        }
    }

    lazy var profileImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "")
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFill
        imageView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleSelectProfileImageView)))
        imageView.isUserInteractionEnabled = true
        return imageView
    }()
    
    lazy var profileImageLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = UIColor.black
        label.backgroundColor = UIColor.white
        label.adjustsFontSizeToFitWidth = true
        label.font = UIFont.systemFont(ofSize: 15)
        return label
    }()
    
    let cancelButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("Cancel", for: UIControlState())
        button.titleLabel?.font = UIFont.systemFont(ofSize: 20)
        button.titleLabel?.adjustsFontSizeToFitWidth = true
        button.setTitleColor(UIColor(r: 161, g: 190, b: 250), for: UIControlState())
        button.backgroundColor = UIColor.white
        button.addTarget(self, action: #selector(cancelRegister), for: .touchUpInside)
        return button
    }()
    
    lazy var userNameTextField: UITextField = {
        let tf = UITextField()
        tf.translatesAutoresizingMaskIntoConstraints = false
        tf.textAlignment = .center
        tf.font = UIFont.systemFont(ofSize: 15)
        tf.placeholder = "Username"
        tf.layer.cornerRadius = 5
        tf.borderStyle = .roundedRect
        return tf
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
    
    lazy var registerButton: UIButton  = {
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.backgroundColor = UIColor(r: 161, g: 181, b: 216)
        button.setTitle("Register", for: UIControlState())
        button.setTitleColor(UIColor.white, for: UIControlState())
        button.addTarget(self, action: #selector(registerUser), for: .touchUpInside)
        button.layer.cornerRadius = 5
        return button
    }()
    
    func setupProfileImageView() {
        profileImageView.topAnchor.constraint(equalTo: view.topAnchor, constant: 100)
        profileImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        profileImageView.widthAnchor.constraint(equalToConstant: 150).isActive = true
        profileImageView.heightAnchor.constraint(equalToConstant: 150).isActive = true
    }
    
    func setupProfileImageLabel() {
        profileImageLabel.topAnchor.constraint(equalTo: profileImageView.bottomAnchor, constant: 15).isActive = true
        profileImageLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        profileImageLabel.widthAnchor.constraint(equalToConstant: 150).isActive = true
        profileImageLabel.heightAnchor.constraint(equalToConstant: 20).isActive = true
    }

    func setupcancelButton() {
        cancelButton.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 10).isActive = true
        cancelButton.topAnchor.constraint(equalTo: view.topAnchor, constant: 10).isActive = true
        cancelButton.widthAnchor.constraint(equalToConstant: 60).isActive = true
        cancelButton.heightAnchor.constraint(equalToConstant: 60).isActive = true
    }
    
    func setupUserNameTextField() {
        userNameTextField.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        userNameTextField.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: -50).isActive = true
        userNameTextField.widthAnchor.constraint(equalToConstant: 2 * view.bounds.width/3).isActive = true
        userNameTextField.heightAnchor.constraint(equalToConstant: 20).isActive = true
    }

    func setupEmailTextField() {
        emailTextField.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        emailTextField.topAnchor.constraint(equalTo: userNameTextField.bottomAnchor, constant: 30).isActive = true
        emailTextField.widthAnchor.constraint(equalToConstant: 2 * view.bounds.width/3).isActive = true
        emailTextField.heightAnchor.constraint(equalToConstant: 20).isActive = true
    }
    
    func setupPasswordTextField() {
        passwordNameTextField.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        passwordNameTextField.topAnchor.constraint(equalTo: emailTextField.bottomAnchor, constant: 30).isActive = true
        passwordNameTextField.widthAnchor.constraint(equalToConstant: 2 * view.bounds.width/3).isActive = true
        passwordNameTextField.heightAnchor.constraint(equalToConstant: 20).isActive = true
    }
    
    func setupRegisterButton() {
        registerButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        registerButton.topAnchor.constraint(equalTo: passwordNameTextField.bottomAnchor, constant: 40).isActive = true
        registerButton.widthAnchor.constraint(equalToConstant: view.bounds.width/2).isActive = true
        registerButton.heightAnchor.constraint(equalToConstant: 50).isActive = true
    }
    
}
