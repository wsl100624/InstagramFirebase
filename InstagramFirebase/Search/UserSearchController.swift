//
//  UserSearchController.swift
//  InstagramFirebase
//
//  Created by Will Wang on 12/9/18.
//  Copyright © 2018 Will Wang. All rights reserved.
//

import UIKit
import Firebase

class UserSearchController: UICollectionViewController, UICollectionViewDelegateFlowLayout, UISearchBarDelegate {
    
    let cellId = "cellId"
    
    var filteredUser = [User]()
    var users = [User]()
    
    lazy var searchBar: UISearchBar = {
        let sb = UISearchBar()
        sb.placeholder = "Enter user name"
        sb.autocapitalizationType = .none
        sb.delegate = self
        UITextField.appearance(whenContainedInInstancesOf: [UISearchBar.self]).backgroundColor = UIColor.rgb(red: 230, green: 230, blue: 230)
        return sb
    }()
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchText.isEmpty {
            filteredUser = users
        } else {
            filteredUser = users.filter({ (user) -> Bool in
                return user.username.lowercased().contains(searchText.lowercased())
            })
        }
        
        self.collectionView?.reloadData()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        collectionView.backgroundColor = .white
        let navBar = navigationController?.navigationBar
        navBar?.addSubview(searchBar)
        searchBar.anchor(top: navBar?.topAnchor, bottom: navBar?.bottomAnchor, left: navBar?.leftAnchor, right: navBar?.rightAnchor, paddingTop: 0, paddingBottom: 0, paddingLeft: 8, paddingRight: 8, width: 0, height: 0)
        
        collectionView.register(UserSearchCell.self, forCellWithReuseIdentifier: cellId)
        collectionView.alwaysBounceVertical = true
        collectionView.keyboardDismissMode = .onDrag
        
        fetchUsers()
    }
    

    fileprivate func fetchUsers() {
        
        print("fetch users")
        let ref = Database.database().reference().child("users")
        
        ref.observeSingleEvent(of: .value, with: { (snapshot) in
            
            guard let dictionaries = snapshot.value as? [String : Any] else { return }
            
            dictionaries.forEach({ (key, value) in
                
                if key == Auth.auth().currentUser?.uid {
                    //found myself
                    return
                }
                
                guard let userDictionary = value as? [String:Any] else { return }
                let user = User(uid: key, dictionary: userDictionary)
                
                self.users.append(user)

            })
            
            self.users.sort(by: { (user1, user2) -> Bool in
                return user1.username.compare(user2.username) == .orderedAscending
            })
            self.filteredUser = self.users
            self.collectionView?.reloadData()

        }) { (error) in
            print("fetch user failed", error)
        }
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        searchBar.isHidden = false
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        searchBar.isHidden = true
        
        let user = filteredUser[indexPath.item]
        
        let userProfileController = UserProfileController(collectionViewLayout: UICollectionViewFlowLayout())
        userProfileController.userId = user.uid
        navigationController?.pushViewController(userProfileController, animated: true)
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return filteredUser.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as! UserSearchCell
        cell.user = filteredUser[indexPath.item]
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: view.frame.width, height: 66)
    }
    
}
