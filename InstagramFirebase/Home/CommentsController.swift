//
//  CommentsController.swift
//  InstagramFirebase
//
//  Created by Will Wang on 12/29/18.
//  Copyright © 2018 Will Wang. All rights reserved.
//

import UIKit
import Firebase

class CommentsController: UICollectionViewController, UICollectionViewDelegateFlowLayout, CommentInputAccessoryDelegate {
    
    
    
    
    
    
    let cellId = "cellId"
    var post: Post?
    var comments = [Comment]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        collectionView.backgroundColor = .white
        navigationItem.title = "Comments"
        
        collectionView.alwaysBounceVertical = true
        collectionView.keyboardDismissMode = .interactive
        
//        collectionView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: -80, right: 0)
        
        collectionView.register(CommentsCell.self, forCellWithReuseIdentifier: cellId)
        
        fetchComments()
        
    }
    
    fileprivate func fetchComments() {
        
        guard let post = self.post else { return }
        guard let postId = post.id else { return }
        
        let ref = Database.database().reference().child("comments").child(postId)
        
        ref.observe(.childAdded, with: { (snapshot) in
            guard let dictionary = snapshot.value as? [String: Any] else { return }
            
            guard let uid = dictionary["uid"] as? String else { return }
            
            Database.fetchUserWithUID(uid: uid, completion: { (user) in
                
                let comment = Comment(dictionary: dictionary, user: user)
                self.comments.append(comment)
                
                self.comments.sort(by: { (c1, c2) -> Bool in
                    c1.creationDate.compare(c2.creationDate) == .orderedAscending
                })
                
                self.collectionView.reloadData()
            })
            
            
            
        }) { (error) in
            print("Failed to fetch comments", error)
        }
        
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let frame = CGRect(x: 0, y: 0, width: view.frame.width, height: 50)
        let dummyCell = CommentsCell(frame: frame)
        dummyCell.comment = comments[indexPath.item]
        dummyCell.layoutIfNeeded()
        
        let targetSize = CGSize(width: view.frame.width, height: 1000)
        let estimatedSize = dummyCell.systemLayoutSizeFitting(targetSize)
        
        let height = max(40 + 8 + 8, estimatedSize.height)

        return CGSize(width: view.frame.width, height: height)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 5
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return comments.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as! CommentsCell
        
        cell.comment = comments[indexPath.item]
        
        return cell
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tabBarController?.tabBar.isHidden = true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        tabBarController?.tabBar.isHidden = false
    }
    
    override var canBecomeFirstResponder: Bool {
        return true
    }
    
    
    lazy var containerView: CommentInputAccessoryView = {
        let frame = CGRect(x: 0, y: 0, width: view.frame.width, height: 80)
        let commentInputAccessoryView = CommentInputAccessoryView(frame: frame)
        commentInputAccessoryView.delegate = self
        return commentInputAccessoryView
    }()
    
    override var inputAccessoryView: UIView? {
        get {
            return containerView
        }
    }
    
    func didSubmit(for comment: String) {
        print("Trying to test delegate...")
        
        guard let post = self.post else { return }
        guard let postId = post.id else { return }
        
        guard let currentUserUID = Auth.auth().currentUser?.uid else { return }
        let value = ["text": comment, "creationDate": Date().timeIntervalSince1970, "uid": currentUserUID] as [String : Any]
        
        let ref = Database.database().reference().child("comments").child(postId).childByAutoId()
        ref.updateChildValues(value) { (error, ref) in
            if let error = error {
                print("Failed to post Comments...", error)
                return
            }
            
            print("Successfully to post Comments...")
            self.containerView.clearCommentTextView()
        }
    }
    
    
}
