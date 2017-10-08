//
//  AccountControllerHandler.swift
//  CateChat
//
//  Created by Chayce Heiberg on 7/12/17.
//  Copyright © 2017 wsuv. All rights reserved.
//

import UIKit

extension AccountViewController {
    
    @objc func presentLoginViewController() {
        let loginController = LoginViewController()
        present(loginController, animated: true, completion: nil)
    }
    
    @objc func presentRegisterViewController() {
        let registerController = RegisterViewController()
        present(registerController, animated: true, completion: nil)
    }
}
