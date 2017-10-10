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
