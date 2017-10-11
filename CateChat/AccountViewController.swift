import UIKit

class AccountViewController: UIViewController {

    @objc    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = UIColor.white
        
        view.addSubview(logoImage)
        view.addSubview(loginButton)
        view.addSubview(buttonSeperator)
        view.addSubview(registerButton)
        
        setupLogoImage()
        setupLoginButton()
        setupButtonSeperator()
        setupRegisterButton()
    }
    
    lazy var logoImage: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "Logo")
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFill
        return imageView
    }()

    lazy var loginButton: UIButton = {
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("Log In", for: UIControlState())
        button.setTitleColor(UIColor.white, for: UIControlState())
        button.titleLabel?.font = UIFont(name: "plain", size: 30)
        button.backgroundColor = UIColor(r: 123, g: 158, b: 168)
        button.addTarget(self, action: #selector(presentLoginViewController), for: .touchUpInside)
        return button
    }()
    
    lazy var buttonSeperator: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.gray
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    lazy var registerButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Sign Up", for: UIControlState())
        button.setTitleColor(UIColor.white, for: UIControlState())
        button.titleLabel?.font = UIFont(name: "plain", size: 30)
        button.backgroundColor = UIColor(r: 0, g: 52, b: 89)
        button.addTarget(self, action: #selector(presentRegisterViewController), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
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
        loginButton.bottomAnchor.constraint(equalTo: buttonSeperator.topAnchor).isActive = true
        loginButton.widthAnchor.constraint(equalToConstant: view.bounds.width).isActive = true
        loginButton.heightAnchor.constraint(equalToConstant: view.bounds.height/8).isActive = true
    }
    
    func setupButtonSeperator() {
        buttonSeperator.bottomAnchor.constraint(equalTo: registerButton.topAnchor).isActive = true
        buttonSeperator.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        buttonSeperator.widthAnchor.constraint(equalToConstant: view.bounds.width).isActive = true
        buttonSeperator.heightAnchor.constraint(equalToConstant: 1).isActive = true
    }
    
    func setupRegisterButton() {
        registerButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        registerButton.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        registerButton.widthAnchor.constraint(equalToConstant: view.bounds.width).isActive = true
        registerButton.heightAnchor.constraint(equalToConstant: view.bounds.height/8).isActive = true
    }
}
