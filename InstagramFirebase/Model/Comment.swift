//
//  Comment.swift
//  InstagramFirebase
//
//  Created by Will Wang on 12/31/18.
//  Copyright © 2018 Will Wang. All rights reserved.
//

import Foundation

struct Comment {
    
    let text: String
    let creationDate: Date
    let uid: String
    
    let user: User
    
    init(dictionary: [String: Any], user: User) {
        self.text = dictionary["text"] as? String ?? ""
        self.uid = dictionary["uid"] as? String ?? ""
        self.user = user
        
        let secondsSince1970 = dictionary["creationDate"] as? Double ?? 0
        
        self.creationDate = Date(timeIntervalSince1970: secondsSince1970)
        
        
    }
}
