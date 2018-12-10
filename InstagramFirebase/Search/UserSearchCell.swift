//
//  UserSearchCell.swift
//  InstagramFirebase
//
//  Created by Will Wang on 12/9/18.
//  Copyright © 2018 Will Wang. All rights reserved.
//

import UIKit

class UserSearchCell: UICollectionViewCell {
    
    let photoImageView: CustomImageView = {
       let iv = CustomImageView()
        iv.backgroundColor = .red
        return iv
    }()
    
    let usernameLabel: UILabel = {
        let label = UILabel()
        label.text = "Username"
        label.font = .boldSystemFont(ofSize: 14)
        return label
    }()
    
    let separatorView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(white: 0, alpha: 0.5)
        return view
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        addSubview(photoImageView)
        addSubview(usernameLabel)
        addSubview(separatorView)
        
        photoImageView.anchor(top: nil, bottom: nil, left: leftAnchor, right: nil, paddingTop: 0, paddingBottom: 0, paddingLeft: 8, paddingRight: 0, width: 50, height: 50)
        photoImageView.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        photoImageView.layer.cornerRadius = 50/2
        
        usernameLabel.anchor(top: topAnchor, bottom: bottomAnchor, left: photoImageView.rightAnchor, right: rightAnchor, paddingTop: 0, paddingBottom: 0, paddingLeft: 8, paddingRight: 0, width: 0, height: 0)
        
        separatorView.anchor(top: nil, bottom: bottomAnchor, left: usernameLabel.leftAnchor, right: rightAnchor, paddingTop: 0, paddingBottom: 0, paddingLeft: 0, paddingRight: 0, width: 0, height: 0.5)
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
