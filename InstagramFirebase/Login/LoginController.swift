//
//  LoginController.swift
//  InstagramFirebase
//
//  Created by Will Wang on 11/25/18.
//  Copyright © 2018 Will Wang. All rights reserved.
//

import UIKit
import Firebase

class LoginController: UIViewController {
    
    let logoContainerView: UIView = {
        let view = UIView()
        let logoImageView = UIImageView(image: #imageLiteral(resourceName: "Instagram_logo_white"))
        logoImageView.contentMode = .scaleAspectFit
        view.addSubview(logoImageView)
        logoImageView.anchor(top: view.safeAreaLayoutGuide.topAnchor, bottom: nil, left: nil, right: nil, paddingTop: 20, paddingBottom: 0, paddingLeft: 0, paddingRight: 0, width: 200, height: 50)
        logoImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        
        view.backgroundColor = UIColor.rgb(red: 0, green: 120, blue: 175)
        return view
    }()
    
    let emailTextField: UITextField = {
        let tf = UITextField()
        tf.placeholder = "Email"
        tf.borderStyle = .roundedRect
        tf.backgroundColor = UIColor(white: 0, alpha: 0.03)
        tf.font = .systemFont(ofSize: 14)
        
        tf.addTarget(self, action: #selector(handleInputChange), for: .editingChanged)
        
        return tf
    }()
    
    let passwordTextField: UITextField = {
        let tf = UITextField()
        tf.placeholder = "password"
        tf.borderStyle = .roundedRect
        tf.backgroundColor = UIColor(white: 0, alpha: 0.03)
        tf.font = .systemFont(ofSize: 14)
        tf.isSecureTextEntry = true
        
        tf.addTarget(self, action: #selector(handleInputChange), for: .editingChanged)
        
        return tf
    }()
    
    let loginButton: UIButton = {
        let btn = UIButton(type: .system)
        btn.backgroundColor = UIColor.rgb(red: 149, green: 204, blue: 244)
        btn.setTitle("Login", for: .normal)
        btn.titleLabel?.font = .boldSystemFont(ofSize: 14)
        btn.setTitleColor(.white, for: .normal)
        btn.layer.cornerRadius = 5
        btn.isEnabled = false
        
        btn.addTarget(self, action: #selector(handleLogin), for: .touchUpInside)
        
        return btn
    }()
    
    let dontHaveAccountButton: UIButton = {
        let btn = UIButton(type: .system)
        let attributedTitle = NSMutableAttributedString(string: "Don't have an accout? ", attributes: [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 14), NSAttributedString.Key.foregroundColor: UIColor.lightGray])
        attributedTitle.append(NSAttributedString(string: "Sign Up.", attributes: [NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 14), NSAttributedString.Key.foregroundColor: UIColor.rgb(red: 17, green: 154, blue: 237)]))
        btn.setAttributedTitle(attributedTitle, for: .normal)        
        btn.addTarget(self, action: #selector(handleShowSignUp), for: .touchUpInside)
        return btn
    }()

    @objc func handleInputChange() {
        
        let isFormValid = emailTextField.text?.count ?? 0 > 0 && passwordTextField.text?.count ?? 0 > 0
        
        if isFormValid {
            loginButton.isEnabled = true
            loginButton.backgroundColor = UIColor.rgb(red: 17, green: 154, blue: 237)
        } else {
            loginButton.isEnabled = false
            loginButton.backgroundColor = UIColor.rgb(red: 149, green: 204, blue: 244)
        }
        
    }
    
    @objc func handleLogin() {
        guard let email = emailTextField.text else { return }
        guard let password = passwordTextField.text else { return }
        Auth.auth().signIn(withEmail: email, password: password) { (data, error) in
            if let error = error {
                print("Failed to sign in with email: ", error)
                return
            }
            
            print("Successfully logged back in with user: ", data?.user.uid ?? "")
            guard let mainTabBarController = UIApplication.shared.keyWindow?.rootViewController as? MainTabBarViewController else { return }
            mainTabBarController.setupViewController()
            self.dismiss(animated: true, completion: nil)
        }
    }
    
    @objc func handleShowSignUp() {
        
        let signUpController = SignUpController()
        navigationController?.pushViewController(signUpController, animated: true)
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        navigationController?.isNavigationBarHidden = true
        view.addSubview(dontHaveAccountButton)
        dontHaveAccountButton.anchor(top: nil, bottom: view.safeAreaLayoutGuide.bottomAnchor, left: view.leftAnchor, right: view.rightAnchor, paddingTop: 0, paddingBottom: 0, paddingLeft: 0, paddingRight: 0, width: 0, height: 50)
        
        view.addSubview(logoContainerView)
        logoContainerView.anchor(top: view.topAnchor, bottom: nil, left: view.leftAnchor, right: view.rightAnchor, paddingTop: 0, paddingBottom: 0, paddingLeft: 0, paddingRight: 0, width: 0, height: 150)
        
        setupInputField()
        
    }
    
    fileprivate func setupInputField() {
        
        let stackView = UIStackView.init(arrangedSubviews: [emailTextField, passwordTextField, loginButton])
        
        stackView.axis = .vertical
        stackView.spacing = 10
        stackView.distribution = .fillEqually
        
        view.addSubview(stackView)
        stackView.anchor(top: logoContainerView.bottomAnchor, bottom: nil, left: view.leftAnchor, right: view.rightAnchor, paddingTop: 40, paddingBottom: 0, paddingLeft: 40, paddingRight: 40, width: 0, height: 140)
        
    }
}
