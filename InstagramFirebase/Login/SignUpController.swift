//
//  ViewController.swift
//  InstagramFirebase
//
//  Created by Will Wang on 11/22/18.
//  Copyright © 2018 Will Wang. All rights reserved.
//

import UIKit
import Firebase
import Foundation

class SignUpController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    
    let photoBtn: UIButton = {
        let btn = UIButton(type: .system)
        btn.setImage(#imageLiteral(resourceName: "plus_photo"), for: .normal)

        btn.addTarget(self, action: #selector(handlePhotoBtn), for: .touchUpInside)
        
        return btn
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
    
    let userNameTextField: UITextField = {
        let tf = UITextField()
        tf.placeholder = "Username"
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
    
    let signUpBtn: UIButton = {
        let btn = UIButton(type: .system)
        btn.backgroundColor = UIColor.rgb(red: 149, green: 204, blue: 244)
        btn.setTitle("Sign Up", for: .normal)
        btn.titleLabel?.font = .boldSystemFont(ofSize: 14)
        btn.setTitleColor(.white, for: .normal)
        btn.layer.cornerRadius = 5
        btn.isEnabled = false
        
        btn.addTarget(self, action: #selector(handleSignUp), for: .touchUpInside)
        
        return btn
    }()
    
    let alreadyHaveAccountButton: UIButton = {
        let btn = UIButton(type: .system)
        let attributedTitle = NSMutableAttributedString(string: "Already have an account? ", attributes: [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 14), NSAttributedString.Key.foregroundColor: UIColor.lightGray])
        attributedTitle.append(NSAttributedString(string: "Login.", attributes: [NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 14), NSAttributedString.Key.foregroundColor: UIColor.rgb(red: 17, green: 154, blue: 237)]))
        btn.setAttributedTitle(attributedTitle, for: .normal)
        btn.addTarget(self, action: #selector(handleAlreadyHaveAccount), for: .touchUpInside)
        return btn
    }()
    
    @objc func handleAlreadyHaveAccount() {
        navigationController?.popViewController(animated: true)
    }
    
    @objc func handlePhotoBtn() {
        let imagePickerController = UIImagePickerController()
        imagePickerController.delegate = self
        imagePickerController.allowsEditing = true
        present(imagePickerController, animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let editedImage = info[UIImagePickerController.InfoKey.editedImage] as? UIImage {
            photoBtn.setImage(editedImage.withRenderingMode(.alwaysOriginal), for: .normal)
        } else if let originalImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            photoBtn.setImage(originalImage.withRenderingMode(.alwaysOriginal), for: .normal)
        }
        
        photoBtn.layer.cornerRadius = photoBtn.layer.frame.width/2
        photoBtn.layer.masksToBounds = true
        photoBtn.layer.borderColor = UIColor.black.cgColor
        photoBtn.layer.borderWidth = 3
        
        dismiss(animated: true, completion: nil)
    }
    
    @objc func handleInputChange() {
        
        let isFormValid = emailTextField.text?.count ?? 0 > 0 && userNameTextField.text?.count ?? 0 > 0 && passwordTextField.text?.count ?? 0 > 0
        
        if isFormValid {
            signUpBtn.isEnabled = true
            signUpBtn.backgroundColor = UIColor.rgb(red: 17, green: 154, blue: 237)
        } else {
            signUpBtn.isEnabled = false
            signUpBtn.backgroundColor = UIColor.rgb(red: 149, green: 204, blue: 244)
        }
        
    }
    
    @objc func handleSignUp() {
        
        guard let email = emailTextField.text, email.count > 0 else { return }
        guard let username = userNameTextField.text, username.count > 0 else { return }
        guard let password = passwordTextField.text, password.count > 0 else { return }
        
        Auth.auth().createUser(withEmail: email, password: password) { (response, error) in
            if let err = error {
                print("Sign up failed, error is \(err)")
                return
            }
            
            print("Created a user! \(response?.user.uid ?? "")")
            
            guard let image = self.photoBtn.imageView?.image else { return }
            
            guard let updateData = image.jpegData(compressionQuality: 0.3) else { return }
            
            let filename = UUID.init().uuidString
            let storageRef = Storage.storage().reference().child("profile_image").child(filename)
            storageRef.putData(updateData, metadata: nil, completion: { (metadata, err) in
                if let err = err {
                    print("upload data failed, \(err)")
                    return
                }
                
                storageRef.downloadURL(completion: { (downloadURL, err) in
                    if let err = err {
                        print("Failed to fetch downloadURL:", err)
                        return
                    }
                    
                    guard let profileImageURL = downloadURL?.absoluteString else { return }
                    
                    print("Successfully uploaded profile image:", profileImageURL)
                    
                    guard let uid = response?.user.uid else { return }
                    
                    let dictionaryValues = ["username" : username, "profile_image" : profileImageURL]
                    let value = [uid : dictionaryValues]
                    
                    Database.database().reference().child("users").updateChildValues(value) { (error: Error?, ref: DatabaseReference?) in
                        
                        if let error = error {
                            print("update data failed \(error)")
                            return
                        } else {
                            guard let mainTabBarController = UIApplication.shared.keyWindow?.rootViewController as? MainTabBarViewController else { return }
                            mainTabBarController.setupViewController()
                            self.dismiss(animated: true, completion: nil)
                            print("Successfully saved user info to db", ref ?? "")
                        }
                    }
                })
            })
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        
        view.addSubview(photoBtn)
        
        photoBtn.anchor(top: view?.safeAreaLayoutGuide.topAnchor, bottom: nil, left: nil, right: nil, paddingTop: 50, paddingBottom: 0, paddingLeft: 0, paddingRight: 0, width: 140, height: 140)
        photoBtn.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        
        setupInputFields()
        
        view.addSubview(alreadyHaveAccountButton)
        alreadyHaveAccountButton.anchor(top: nil, bottom: view.safeAreaLayoutGuide.bottomAnchor, left: view.leftAnchor, right: view.rightAnchor, paddingTop: 0, paddingBottom: 0, paddingLeft: 0, paddingRight: 0, width: 0, height: 50)
    }

    fileprivate func setupInputFields() {
        
        let stackView = UIStackView(arrangedSubviews: [emailTextField, userNameTextField, passwordTextField, signUpBtn])
        
        stackView.distribution = .fillEqually
        stackView.spacing = 10
        stackView.axis = .vertical
        
        view.addSubview(stackView)

        stackView.anchor(top: photoBtn.bottomAnchor, bottom: nil, left: view.leftAnchor, right: view.rightAnchor, paddingTop: 40, paddingBottom: 0, paddingLeft: 40, paddingRight: 40, width: 0, height: 200)
    }

}

extension UIColor {
    static func rgb(red: CGFloat, green: CGFloat, blue: CGFloat) -> UIColor {
        return UIColor(red: red/255, green: green/255, blue: blue/255, alpha: 1)
    }
}
