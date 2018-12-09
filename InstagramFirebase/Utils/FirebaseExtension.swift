//
//  FirebaseExtension.swift
//  InstagramFirebase
//
//  Created by Will Wang on 12/9/18.
//  Copyright © 2018 Will Wang. All rights reserved.
//

import Foundation
import Firebase

extension Database {
    
    static func fetchUserWithUID(uid: String, completion: @escaping (User) -> ()) {
        let userRef = Database.database().reference().child("users").child(uid)
        
        userRef.observeSingleEvent(of: .value, with: { (snapshot) in
            let userDictionary = snapshot.value as! [String : Any]
            let user = User(uid: uid, dictionary: userDictionary)
            
            completion(user)
        }) { (error) in
            print(error)
        }
    }
    
}
