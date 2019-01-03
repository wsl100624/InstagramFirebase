//
//  Post.swift
//  InstagramFirebase
//
//  Created by Will Wang on 12/3/18.
//  Copyright © 2018 Will Wang. All rights reserved.
//

import Foundation

struct Post {

    var id: String?
    
    let imageURL: String
    let user: User
    let caption: String
    let creationDate: Date
    
    var hasLiked = false
    
    init(user: User, dictionary: [String: Any]) {
        self.imageURL = dictionary["imageURL"] as? String ?? ""
        self.user = user
        self.caption = dictionary["caption"] as? String ?? ""
        
        let secondsSince1970 = dictionary["creationDate"] as? Double ?? 0
        
        self.creationDate = Date(timeIntervalSince1970: secondsSince1970)
        
        
    }
}
