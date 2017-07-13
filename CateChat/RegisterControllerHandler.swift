//
//  RegisterControllerHandler.swift
//  CateChat
//
//  Created by Chayce Heiberg on 7/12/17.
//  Copyright © 2017 wsuv. All rights reserved.
//

import UIKit
import Firebase

extension RegisterController {
    
    func cancelRegister() {
        dismiss(animated: true, completion: nil)
    }
    
    func registerUser() {
        
        guard let name = userNameTextField.text, let email = emailTextField.text, let password = passwordNameTextField.text else {
            print("Incorrect name or email")
            return
        }
        
        Auth.auth().createUser(withEmail: email, password: password, completion: { (user: User?, error) in
            
            if error != nil {
                print(error!)
                return
            }
            // User was created
            
            guard let uid = user?.uid else {
                
                print("No user associated with auth()")
                return
            }
            
            let childReference = self.ref.child("users").child(uid)
            let values: [String: Any] = ["name": name, "email": email]
            childReference.updateChildValues(values, withCompletionBlock: { (error, ref) in
                
                if error != nil {
                    print(error!)
                    return
                }
                
                // User uid child nodes updated
                
            })
            
            let navController = UINavigationController(rootViewController: HomeController())
            self.present(navController, animated: true, completion: nil)
        })
    }
    
    func handleSelectProfileImageView() {
        
    }
}
