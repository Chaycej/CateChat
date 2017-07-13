//
//  AccountController.swift
//  CateChat
//
//  Created by Chayce Heiberg on 7/12/17.
//  Copyright © 2017 wsuv. All rights reserved.
//

import UIKit

class AccountController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = UIColor.white
        
        view.addSubview(logoImage)
        view.addSubview(loginButton)
        view.addSubview(registerButton)
        
        setupLogoImage()
        setupLoginButton()
        setupRegisterButton()
    }
    
    
    
    lazy var logoImage: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "PlorioLogo")
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFill
        return imageView
    }()
    
    // Log In button
    lazy var loginButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Log In", for: UIControlState())
        button.setTitleColor(UIColor.white, for: UIControlState())
        button.titleLabel?.font = UIFont(name: "plain", size: 30)
        button.backgroundColor = UIColor(r: 142, g: 68, b: 61)
        button.addTarget(self, action: #selector(presentLoginController), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.layer.cornerRadius = 5
        return button
    }()
    
    // Register Button
    lazy var registerButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Sign Up", for: UIControlState())
        button.setTitleColor(UIColor.white, for: UIControlState())
        button.titleLabel?.font = UIFont(name: "plain", size: 30)
        button.backgroundColor = UIColor(r: 161, g: 181, b: 216)
        button.addTarget(self, action: #selector(presentRegisterController), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.layer.cornerRadius = 5
        return button
    }()
    
    func setupLogoImage() {
        logoImage.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        logoImage.bottomAnchor.constraint(equalTo: loginButton.topAnchor, constant: -1 * view.bounds.height/6).isActive = true
        logoImage.heightAnchor.constraint(equalToConstant: 150).isActive = true
        logoImage.widthAnchor.constraint(equalToConstant: 150).isActive = true
    }
    
    func setupLoginButton() {
        loginButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        loginButton.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        loginButton.widthAnchor.constraint(equalToConstant: view.bounds.width/2).isActive = true
        loginButton.heightAnchor.constraint(equalToConstant: view.bounds.height/8).isActive = true
    }
    
    func setupRegisterButton() {
        registerButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        registerButton.topAnchor.constraint(equalTo: loginButton.bottomAnchor, constant: 30).isActive = true
        registerButton.widthAnchor.constraint(equalToConstant: view.bounds.width/2).isActive = true
        registerButton.heightAnchor.constraint(equalToConstant: view.bounds.height/8).isActive = true
    }



}
