//
//  UserPhotoCell.swift
//  InstagramFirebase
//
//  Created by Will Wang on 12/3/18.
//  Copyright © 2018 Will Wang. All rights reserved.
//

import UIKit

class UserPhotoCell: UICollectionViewCell {
    
    var post: Post? {
        didSet {
            guard let imageURL = post?.imageURL else { return }
            photoImageView.loadImage(urlString: imageURL)
        }
    }
    
    let photoImageView: CustomImageView = {
        let iv = CustomImageView()
        iv.contentMode = .scaleAspectFill
        iv.clipsToBounds = true
        return iv
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        addSubview(photoImageView)
        photoImageView.anchor(top: topAnchor, bottom: bottomAnchor, left: leftAnchor, right: rightAnchor, paddingTop: 0, paddingBottom: 0, paddingLeft: 0, paddingRight: 0, width: 0, height: 0)
        
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
