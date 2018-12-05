//
//  Post.swift
//  InstagramFirebase
//
//  Created by Will Wang on 12/3/18.
//  Copyright © 2018 Will Wang. All rights reserved.
//

import Foundation

struct Post {
    let imageURL: String
    
    init(dictionary: [String: Any]) {
        imageURL = dictionary["imageURL"] as? String ?? ""
    }
}
