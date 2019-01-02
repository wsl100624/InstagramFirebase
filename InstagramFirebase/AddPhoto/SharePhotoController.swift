//
//  SharePhotoController.swift
//  InstagramFirebase
//
//  Created by Will Wang on 11/30/18.
//  Copyright © 2018 Will Wang. All rights reserved.
//

import UIKit
import Firebase

class SharePhotoController: UIViewController {
    
    static let updateFeedNotificationName = Notification.Name("UpdateFeed")
    
    var selectedImage: UIImage? {
        didSet {
            imageView.image = selectedImage
        }
    }
    
    
    let imageView: UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFill
        iv.clipsToBounds = true
        return iv
    }()
    
    let textView: UITextView = {
        let tv = UITextView()
        tv.font = .systemFont(ofSize: 14)
        return tv
    }()
    
    let containerView: UIView = {
       
        let view = UIView()
        view.backgroundColor = .white
        return view
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Share", style: .plain, target: self, action: #selector(handleShare))

        view.backgroundColor = UIColor.rgb(red: 240, green: 240, blue: 240)
        
        view.addSubview(containerView)
        containerView.anchor(top: view.safeAreaLayoutGuide.topAnchor, bottom: nil, left: view.leftAnchor, right: view.rightAnchor, paddingTop: 0, paddingBottom: 0, paddingLeft: 0, paddingRight: 0, width: 0, height: 120)
        
        containerView.addSubview(imageView)
        imageView.anchor(top: containerView.topAnchor, bottom: containerView.bottomAnchor, left: view.leftAnchor, right: nil, paddingTop: 8, paddingBottom: 8, paddingLeft: 8, paddingRight: 0, width: 104, height: 0)
        
        containerView.addSubview(textView)
        textView.anchor(top: imageView.topAnchor, bottom: imageView.bottomAnchor, left: imageView.rightAnchor, right: containerView.rightAnchor, paddingTop: 0, paddingBottom: 0, paddingLeft: 8, paddingRight: 8, width: 0, height: 0)
        
    }
    
    @objc func handleShare() {

        guard let caption = textView.text, caption.count > 0 else { return }
        guard let selectedImage = selectedImage else { return }
        guard let uploadData = selectedImage.jpegData(compressionQuality: 0.5) else { return }
        
        navigationItem.rightBarButtonItem?.isEnabled = false
        
        let filename = NSUUID().uuidString
        
        let storageRef = Storage.storage().reference().child("posts").child(filename)
        storageRef.putData(uploadData, metadata: nil) { (metadata, error) in
            if let error = error {
                print("failed to upload post image", error)
                return
            }
            
            storageRef.downloadURL(completion: { (downloadURL, error) in
                
                if let error = error {
                    self.navigationItem.rightBarButtonItem?.isEnabled = true
                    print("Failed to fetch download url", error)
                    return
                }
                guard let imageURL = downloadURL?.absoluteString else { return }
                print("Successfully uploaded post image:", imageURL)
                self.saveToDatabaseWithImageUrl(imageURL)
            })
        }
    }
    
    fileprivate func saveToDatabaseWithImageUrl(_ imageURL: String) {
        
        guard let postImage = selectedImage else { return }
        guard let caption = textView.text else { return }
        
        guard let uid = Auth.auth().currentUser?.uid else { return }
        
        let userPostRef = Database.database().reference().child("posts").child(uid)
        let ref = userPostRef.childByAutoId()
        
        
        let value = ["imageURL" : imageURL, "imageWidth" : postImage.size.width, "imageHeight" : postImage.size.height, "caption" : caption, "creationDate" : Date().timeIntervalSince1970] as [String : Any]
        
        ref.updateChildValues(value) { (error, ref) in
            if let error = error {
                self.navigationItem.rightBarButtonItem?.isEnabled = true

                print("Failed to update data in database", error)
                return
            }

            print("Successfully to update data in database")
            
            
            NotificationCenter.default.post(name: SharePhotoController.updateFeedNotificationName, object: nil)
            
            self.dismiss(animated: true, completion: nil)
        }
        
        
        
        
        
    }
    
    
}
