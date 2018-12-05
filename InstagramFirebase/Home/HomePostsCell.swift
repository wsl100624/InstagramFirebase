//
//  HomePostsCell.swift
//  InstagramFirebase
//
//  Created by Will Wang on 12/4/18.
//  Copyright © 2018 Will Wang. All rights reserved.
//

import UIKit

class HomePostsCell: UICollectionViewCell {
    
    var post: Post? {
        didSet {
            guard let imageURL = post?.imageURL else { return }
            photoImageView.loadImage(urlString: imageURL)
        }
    }
    
    let userProfileImageView: CustomImageView = {
        let iv = CustomImageView()
        iv.contentMode = .scaleAspectFill
        iv.clipsToBounds = true
        iv.layer.cornerRadius = 40/2
        return iv
    }()
    
    let userNameLabel: UILabel = {
        let label = UILabel()
        label.text = "Username"
        label.font = .systemFont(ofSize: 14, weight: .bold)
        return label
    }()
    
    let optionButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("•••", for: .normal)
        button.setTitleColor(.black, for: .normal)
        return button
    }()
    
   
    let photoImageView: CustomImageView = {
        let iv = CustomImageView()
        iv.contentMode = .scaleAspectFill
        iv.clipsToBounds = true
        return iv
    }()
    
    let likeButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(#imageLiteral(resourceName: "like_unselected-1").withRenderingMode(.alwaysOriginal), for: .normal)
        return button
    }()
    
    let commentButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(#imageLiteral(resourceName: "comment").withRenderingMode(.alwaysOriginal), for: .normal)
        return button
    }()
    
    let sentButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(#imageLiteral(resourceName: "send2").withRenderingMode(.alwaysOriginal), for: .normal)
        return button
    }()
    
    let saveButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(#imageLiteral(resourceName: "ribbon").withRenderingMode(.alwaysOriginal), for: .normal)
        return button
    }()
    
    let captionLabel: UILabel = {
        let label = UILabel()
        let attributeText = NSMutableAttributedString(string: "Username", attributes: [NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 14)])
        
        attributeText.append(NSAttributedString(string: " Today im really tired, but i don't care, because everyday is the same.", attributes: [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 14)]))
        attributeText.append(NSAttributedString(string: "\n\n", attributes: [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 4)]))
        attributeText.append(NSAttributedString(string: "1 week ago", attributes: [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 14), NSAttributedString.Key.foregroundColor: UIColor.gray]))
        
        label.attributedText = attributeText
        label.numberOfLines = 0
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        addSubview(userProfileImageView)
        addSubview(userNameLabel)
        addSubview(optionButton)
        addSubview(photoImageView)
        addSubview(captionLabel)
        
        userProfileImageView.anchor(top: topAnchor, bottom: nil, left: leftAnchor, right: nil, paddingTop: 4, paddingBottom: 0, paddingLeft: 8, paddingRight: 0, width: 40, height: 40)

        userNameLabel.anchor(top: topAnchor, bottom: photoImageView.topAnchor, left: userProfileImageView.rightAnchor, right: nil, paddingTop: 0, paddingBottom: 0, paddingLeft: 8, paddingRight: 0, width: 0, height: 0)

        optionButton.anchor(top: topAnchor, bottom: photoImageView.topAnchor, left: nil, right: rightAnchor, paddingTop: 0, paddingBottom: 0, paddingLeft: 0, paddingRight: 4, width: 0, height: 0)
        
        photoImageView.anchor(top: userProfileImageView.bottomAnchor, bottom: nil, left: leftAnchor, right: rightAnchor, paddingTop: 4, paddingBottom: 0, paddingLeft: 0, paddingRight: 0, width: 0, height: 0)
        photoImageView.heightAnchor.constraint(equalTo: widthAnchor, multiplier: 1).isActive = true

        setupActionButtons()
        
        captionLabel.anchor(top: likeButton.bottomAnchor, bottom: bottomAnchor, left: leftAnchor, right: rightAnchor, paddingTop: 0, paddingBottom: 0, paddingLeft: 8, paddingRight: 8, width: 0, height: 0)
        
        
    }
    
    fileprivate func setupActionButtons() {
        
        let stackView = UIStackView(arrangedSubviews: [likeButton, commentButton, sentButton])
        stackView.axis = .horizontal
        stackView.distribution = .fillEqually
        addSubview(stackView)
        stackView.anchor(top: photoImageView.bottomAnchor, bottom: nil, left: leftAnchor, right: nil, paddingTop: 8, paddingBottom: 0, paddingLeft: 4, paddingRight: 0, width: 120, height: 0)
        
        addSubview(saveButton)
        saveButton.anchor(top: photoImageView.bottomAnchor, bottom: nil, left: nil, right: rightAnchor, paddingTop: 0, paddingBottom: 0, paddingLeft: 0, paddingRight: 0, width: 38, height: 38)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
