//
//  LoginControllerHandler.swift
//  CateChat
//
//  Created by Chayce Heiberg on 7/13/17.
//  Copyright © 2017 wsuv. All rights reserved.
//

import UIKit
import Firebase

extension LoginViewController {
    
    @objc func cancelSignIn() {
        dismiss(animated: true, completion: nil)
    }
    
    @objc func signInUser() {
        
        guard let email = emailTextField.text, let password = passwordNameTextField.text else {
            print("email or password form is incorrect")
            return
        }
        
        Auth.auth().signIn(withEmail: email, password: password, completion: { (user, error) in
            
            if error != nil {
                print(error!)
            }
            
            let navController = UINavigationController(rootViewController: HomeViewController())
            self.present(navController, animated: true, completion: nil)
        })
    }
    
    @objc func forgotPassword() {
        
    }
}
