//
//  UserProfileHeader.swift
//  InstagramFirebase
//
//  Created by Will Wang on 11/23/18.
//  Copyright © 2018 Will Wang. All rights reserved.
//

import UIKit
import Firebase

protocol UserProfileHeaderDelegate {
    func didChangeToListView()
    func didChangeToGridView()
}

class UserProfileHeader: UICollectionViewCell {
    
    var delegate: UserProfileHeaderDelegate?
    
    var user: User? {
        didSet {
            guard let profileImageURL = user?.profileImageURL else { return }
            
            profileImageView.loadImage(urlString: profileImageURL)
            
            usernameLabel.text = user?.username
            
            setupEditProfileFollowButton()
        }
    }
    
    
    let profileImageView: CustomImageView = {
        let iv = CustomImageView()
        iv.layer.cornerRadius = 80 / 2
        iv.clipsToBounds = true
        return iv
    }()
    
    let usernameLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 14)
        return label
    }()
    
    lazy var editFollowButton: UIButton = {
        let btn = UIButton()
        btn.setTitle("Edit Profile", for: .normal)
        btn.setTitleColor(.black, for: .normal)
        btn.titleLabel?.font = UIFont.boldSystemFont(ofSize: 14)
        btn.layer.borderColor = UIColor.lightGray.cgColor
        btn.layer.borderWidth = 1
        btn.layer.cornerRadius = 3
        btn.addTarget(self, action: #selector(handleEditProfileOrFollow), for: .touchUpInside)
        
        return btn
    }()
    
    lazy var gridButton: UIButton = {
        let btn = UIButton(type: .system)
        btn.setImage(#imageLiteral(resourceName: "grid"), for: .normal)
        btn.addTarget(self, action: #selector(handleChangeToGridView), for: .touchUpInside)
        return btn
    }()
    
    @objc func handleChangeToGridView() {
        
        gridButton.tintColor = .mainBlue()
        listButton.tintColor = UIColor(white: 0, alpha: 0.2)
        delegate?.didChangeToGridView()
    }
    
    lazy var listButton: UIButton = {
        let btn = UIButton(type: .system)
        btn.setImage(#imageLiteral(resourceName: "list"), for: .normal)
        btn.tintColor = UIColor(white: 0, alpha: 0.2)
        
        btn.addTarget(self, action: #selector(handleChangeToListView), for: .touchUpInside)
        return btn
    }()
    
    @objc func handleChangeToListView() {
        
        listButton.tintColor = .mainBlue()
        gridButton.tintColor = UIColor(white: 0, alpha: 0.2)
        delegate?.didChangeToListView()
        
    }
    
    let bookmarkButton: UIButton = {
        let btn = UIButton(type: .system)
        btn.setImage(#imageLiteral(resourceName: "ribbon"), for: .normal)
        btn.tintColor = UIColor.lightGray
        
        return btn
    }()
    
    let postLabel: UILabel = {
        let label = UILabel()
        let attributedText = NSMutableAttributedString(string: "11\n", attributes: [NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 14)])
        attributedText.append(NSAttributedString(string: "posts", attributes: [NSAttributedString.Key.foregroundColor: UIColor.lightGray, NSAttributedString.Key.font: UIFont.systemFont(ofSize: 14)]))
        label.attributedText = attributedText
        label.textAlignment = .center
        label.numberOfLines = 0
        return label
    }()
    
    let followingLabel: UILabel = {
        let label = UILabel()
        let attributedText = NSMutableAttributedString(string: "0\n", attributes: [NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 14)])
        attributedText.append(NSAttributedString(string: "following", attributes: [NSAttributedString.Key.foregroundColor: UIColor.lightGray, NSAttributedString.Key.font: UIFont.systemFont(ofSize: 14)]))
        label.attributedText = attributedText
        label.textAlignment = .center
        label.numberOfLines = 0
        return label
    }()
    
    let followerLabel: UILabel = {
        let label = UILabel()
        let attributedText = NSMutableAttributedString(string: "0\n", attributes: [NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 14)])
        attributedText.append(NSAttributedString(string: "followers", attributes: [NSAttributedString.Key.foregroundColor: UIColor.lightGray, NSAttributedString.Key.font: UIFont.systemFont(ofSize: 14)]))
        label.attributedText = attributedText
        label.textAlignment = .center
        label.numberOfLines = 0
        return label
    }()
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        addSubview(profileImageView)
        profileImageView.anchor(top: topAnchor, bottom: nil, left: leftAnchor, right: nil, paddingTop: 12, paddingBottom: 0, paddingLeft: 12, paddingRight: 0, width: 80, height: 80)
        
        
        addSubview(usernameLabel)
        usernameLabel.anchor(top: profileImageView.bottomAnchor, bottom: nil, left: profileImageView.leftAnchor, right: rightAnchor, paddingTop: 12, paddingBottom: 0, paddingLeft: 0, paddingRight: 12, width: 0, height: 0)
        
        setupBottomToolBar()
        
        setupUserStatsView()
        
        addSubview(editFollowButton)
        editFollowButton.anchor(top: postLabel.bottomAnchor, bottom: nil, left: profileImageView.rightAnchor, right: rightAnchor, paddingTop: 8, paddingBottom: 0, paddingLeft: 10, paddingRight: 10, width: 0, height: 25)
    }
    
    fileprivate func setupEditProfileFollowButton() {
        
        guard let currentUserId = Auth.auth().currentUser?.uid else { return }
        
        guard let userId = user?.uid else { return }
        
        if userId == currentUserId {
            editFollowButton.setTitle("Edit Profile", for: .normal)
        } else {
            Database.database().reference().child("following").child(currentUserId).child(userId).observeSingleEvent(of: .value, with: { (snapshot) in
                
                if let isFollowing = snapshot.value as? Int, isFollowing == 1 {
                    self.setupUnfollowButtonStyle()
                } else {
                    self.setupFollowButtonStyle()
                }
                
            }) { (error) in
                print("Failed to get following", error)
            }
            
            
            
        }
    }
    
    @objc func handleEditProfileOrFollow() {
        
        guard let currentUserId = Auth.auth().currentUser?.uid else { return }
        guard let userId = user?.uid else { return }
        let ref = Database.database().reference().child("following").child(currentUserId)
        
        if editFollowButton.titleLabel?.text == "Unfollow" {
            ref.child(userId).removeValue { (error, ref) in
                if let error = error {
                    print("failed to unfollow", error)
                }
                print("successfully to unfollow")
                
                self.setupFollowButtonStyle()
            }
        } else {
            let value = [userId : 1]
            ref.updateChildValues(value)
            self.setupUnfollowButtonStyle()
        }
        
        
    }
    
    fileprivate func setupUnfollowButtonStyle() {
        self.editFollowButton.setTitle("Unfollow", for: .normal)
        self.editFollowButton.backgroundColor = .white
        self.editFollowButton.setTitleColor(.black, for: .normal)
    }
    
    fileprivate func setupFollowButtonStyle() {
        self.editFollowButton.setTitle("Follow", for: .normal)
        self.editFollowButton.backgroundColor = UIColor.rgb(red: 17, green: 154, blue: 237)
        self.editFollowButton.setTitleColor(.white, for: .normal)
        self.editFollowButton.layer.borderColor = UIColor(white: 0, alpha: 0.2).cgColor
    }
    
    fileprivate func setupBottomToolBar() {
        
        let topDivider: UIView = {
            let divider = UIView()
            divider.backgroundColor = .lightGray
            return divider
        }()
        
        let bottomDivider: UIView = {
            let divider = UIView()
            divider.backgroundColor = .lightGray
            return divider
        }()
        
        let stackView = UIStackView(arrangedSubviews: [gridButton, listButton, bookmarkButton])
        stackView.axis = .horizontal
        stackView.distribution = .fillEqually
        
        addSubview(topDivider)
        addSubview(bottomDivider)
        addSubview(stackView)
        stackView.anchor(top: nil, bottom: bottomAnchor, left: leftAnchor, right: rightAnchor, paddingTop: 0, paddingBottom: 0, paddingLeft: 0, paddingRight: 0, width: 0, height: 40)
        topDivider.anchor(top: nil, bottom: stackView.topAnchor, left: leftAnchor, right: rightAnchor, paddingTop: 0, paddingBottom: 0, paddingLeft: 0, paddingRight: 0, width: 0, height: 0.5)
        bottomDivider.anchor(top: stackView.bottomAnchor, bottom: nil, left: leftAnchor, right: rightAnchor, paddingTop: 0, paddingBottom: 0, paddingLeft: 0, paddingRight: 0, width: 0, height: 0.5)
        
    }
    
    fileprivate func setupUserStatsView() {
        
        let stackView = UIStackView(arrangedSubviews: [postLabel, followingLabel, followerLabel])
        stackView.axis = .horizontal
        stackView.distribution = .fillEqually
        
        addSubview(stackView)
        stackView.anchor(top: profileImageView.topAnchor, bottom: nil, left: profileImageView.rightAnchor, right: rightAnchor, paddingTop: 8, paddingBottom: 0, paddingLeft: 12, paddingRight: 12, width: 0, height: 0)
    }
    
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
