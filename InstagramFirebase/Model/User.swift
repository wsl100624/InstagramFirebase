//
//  User.swift
//  InstagramFirebase
//
//  Created by Will Wang on 12/5/18.
//  Copyright © 2018 Will Wang. All rights reserved.
//

import Foundation

struct User {
    let username: String
    let profileImageURL: String
    let uid: String
    
    init(uid: String, dictionary: [String: Any]) {
        self.username = dictionary["username"] as? String ?? ""
        self.profileImageURL = dictionary["profile_image"] as? String ?? ""
        self.uid = uid
    }
}
