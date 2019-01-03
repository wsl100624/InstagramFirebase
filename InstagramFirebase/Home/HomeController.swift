//
//  HomeController.swift
//  InstagramFirebase
//
//  Created by Will Wang on 12/4/18.
//  Copyright © 2018 Will Wang. All rights reserved.
//

import UIKit
import Firebase

class HomeController: UICollectionViewController, UICollectionViewDelegateFlowLayout, HomePostCellDelegate{

    let cellId = "cellId"
    var posts = [Post]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupNavigationItems()
        
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(handleRefresh), for: .valueChanged)
        collectionView.refreshControl = refreshControl
        
        collectionView.backgroundColor = .white
        collectionView.register(HomePostsCell.self, forCellWithReuseIdentifier: cellId)
        
        NotificationCenter.default.addObserver(self, selector: #selector(handleUpdateFeed), name: SharePhotoController.updateFeedNotificationName, object: nil)

        fetchAllPosts()
    }
    
    @objc func handleUpdateFeed() {
        handleRefresh()
    }
    
    @objc func handleRefresh() {
        posts.removeAll()
        fetchAllPosts()
    }
    
    fileprivate func fetchAllPosts() {
        fetchPosts()
        fetchFollowingUsersPost()
    }
    
    fileprivate func setupNavigationItems() {
        navigationItem.titleView = UIImageView(image: #imageLiteral(resourceName: "logo2"))
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: #imageLiteral(resourceName: "camera3").withRenderingMode(.alwaysOriginal), style: .plain, target: self, action: #selector(handleOpenCamera))
    }
    
    @objc fileprivate func handleOpenCamera() {
        let cameraController = CameraController()
        present(cameraController, animated: true, completion: nil)
        
    }
    
    fileprivate func fetchPostWithUser(_ user: User) {
        
        let postsRef = Database.database().reference().child("posts").child(user.uid)
        
        postsRef.observeSingleEvent(of: .value, with: { (snapshot) in
            self.collectionView.refreshControl?.endRefreshing()
            
            guard let dictionaries = snapshot.value as? [String : Any] else { return }
            
            dictionaries.forEach({ (key, value) in
                guard let dictionary = value as? [String : Any] else { return }
                var post = Post(user: user, dictionary: dictionary)
                post.id = key
                
                
                guard let uid = Auth.auth().currentUser?.uid else { return }
                
                Database.database().reference().child("likes").child(key).child(uid).observeSingleEvent(of: .value, with: { (snapshot) in
                    
                    if let value = snapshot.value as? Int, value == 1 {
                        post.hasLiked = true
                    } else {
                        post.hasLiked = false
                    }
                    
                    self.posts.append(post)
                    self.posts.sort(by: { (p1, p2) -> Bool in
                        p1.creationDate.compare(p2.creationDate) == .orderedDescending
                    })
                    self.collectionView?.reloadData()
                    
                }, withCancel: { (error) in
                    print("failed to fetch liked post status")
                })
            })
        }) { (error) in
            print("Failed to fetch posts", error)
        }
    }
    
    fileprivate func fetchPosts() {
        
        guard let uid = Auth.auth().currentUser?.uid else { return }
        
        Database.fetchUserWithUID(uid: uid) { (user) in
            self.fetchPostWithUser(user)
        }
        
    }
    
    fileprivate func fetchFollowingUsersPost() {
        
        guard let currentUserUid = Auth.auth().currentUser?.uid else { return }
        
        let ref = Database.database().reference().child("following").child(currentUserUid)
        
        ref.observeSingleEvent(of: .value, with: { (snapshot) in
            
            print("successfully fetched users posts from current following user")
            
            let dictionary = snapshot.value as! [String:Any]
            dictionary.forEach({ (key, value) in
                Database.fetchUserWithUID(uid: key) { (user) in
                    self.fetchPostWithUser(user)
                }
            })
        }) { (error) in
            print("failed to get following users")
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
        if indexPath.item < posts.count {
            cell.post = posts[indexPath.item]
        }
        
        cell.delegate = self
        
        return cell
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return posts.count
    }
    

    func didTapCommentButton(post: Post) {
        
        let commentsController = CommentsController(collectionViewLayout: UICollectionViewFlowLayout())
        navigationController?.pushViewController(commentsController, animated: true)
        
        commentsController.post = post
    }
    
    func didLike(for cell: HomePostsCell) {
        
        guard let indexPath = collectionView.indexPath(for: cell) else { return }
        var post = posts[indexPath.item]
        print(post.caption)
        
        guard let postId = post.id else { return }
        guard let uid = Auth.auth().currentUser?.uid else { return }
        
        let ref = Database.database().reference().child("likes").child(postId)
        
        let values = [uid: post.hasLiked == true ? 0 : 1]
        ref.updateChildValues(values) { (error, _) in
            if let error = error {
                print("falied to upload like status", error)
                return
            }
            
            print("Successfully upload like status")
            
            post.hasLiked = !post.hasLiked
            self.posts[indexPath.item] = post
            
            self.collectionView.reloadItems(at: [indexPath])
            
        }
        
    }
    
    
  
    
    
    
}
