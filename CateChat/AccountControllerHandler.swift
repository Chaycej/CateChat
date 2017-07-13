//
//  AccountControllerHandler.swift
//  CateChat
//
//  Created by Chayce Heiberg on 7/12/17.
//  Copyright © 2017 wsuv. All rights reserved.
//

import UIKit

extension AccountController {
    
    func presentLoginController() {
        let loginController = LoginController()
        present(loginController, animated: true, completion: nil)
    }
    
    func presentRegisterController() {
        let registerController = RegisterController()
        present(registerController, animated: true, completion: nil)
    }
}
