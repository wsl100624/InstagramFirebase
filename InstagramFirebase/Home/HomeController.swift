//
//  HomeController.swift
//  InstagramFirebase
//
//  Created by Will Wang on 12/4/18.
//  Copyright © 2018 Will Wang. All rights reserved.
//

import UIKit
import Firebase

class HomeController: UICollectionViewController, UICollectionViewDelegateFlowLayout{
    
    let cellId = "cellId"
    var posts = [Post]()
    var user: User?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        collectionView.backgroundColor = .white
        
        collectionView.register(HomePostsCell.self, forCellWithReuseIdentifier: cellId)
        
        setupNavigationItems()
        
        fetchPhotos()
        
    }
    
    
    fileprivate func setupNavigationItems() {
        
        navigationItem.titleView = UIImageView(image: #imageLiteral(resourceName: "logo2"))
        
    }
    
    fileprivate func fetchPhotos() {
        
        guard let uid = Auth.auth().currentUser?.uid else { return }
        
        let postsRef = Database.database().reference().child("posts").child(uid)
        
        postsRef.observeSingleEvent(of: .value, with: { (snapshot) in
            guard let dictionaries = snapshot.value as? [String : Any] else { return }
            
            dictionaries.forEach({ (key, value) in
                guard let dictionary = value as? [String : Any] else { return }
                let post = Post(dictionary: dictionary)
                self.posts.append(post)
            })
            
            self.collectionView?.reloadData()
            
        }) { (error) in
            print("Failed to fetch posts", error)
        }
        
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        var height: CGFloat = view.frame.width
        height += 48
        height += 50
        height += 60
        
        return CGSize(width: view.frame.width, height: height)
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as! HomePostsCell
        cell.post = posts[indexPath.item]
        
        return cell
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return posts.count
    }
    
    
    
    
}
