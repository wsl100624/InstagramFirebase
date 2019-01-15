//
//  CommentInputAccessoryView.swift
//  InstagramFirebase
//
//  Created by Will Wang on 1/13/19.
//  Copyright © 2019 Will Wang. All rights reserved.
//

import UIKit

protocol CommentInputAccessoryDelegate {
    func didSubmit(for comment: String)
}

class CommentInputAccessoryView: UIView {
    
    var delegate: CommentInputAccessoryDelegate?

    fileprivate let submitButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Submit", for: .normal)
        button.setTitleColor(.black, for: .normal)
        button.titleLabel?.font = .boldSystemFont(ofSize: 14)
        button.addTarget(self, action: #selector(handleSubmit), for: .touchUpInside)
        
        return button
    }()
    
    fileprivate let commentTextView: CommentInputTextView = {
        let tv = CommentInputTextView()
        tv.isScrollEnabled = false
        tv.font = .systemFont(ofSize: 18)
        return tv
    }()
    
    override var intrinsicContentSize: CGSize {
        return .zero
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        autoresizingMask = .flexibleHeight
        
        backgroundColor = .white
    
        addSubview(submitButton)
        addSubview(commentTextView)
        
        submitButton.anchor(top: topAnchor, bottom: nil, left: nil, right: rightAnchor, paddingTop: 0, paddingBottom: 0, paddingLeft: 0, paddingRight: 12, width: 50, height: 50)
        
        if #available(iOS 11.0, *) {
            commentTextView.anchor(top: topAnchor, bottom: safeAreaLayoutGuide.bottomAnchor, left: leftAnchor, right: submitButton.leftAnchor, paddingTop: 8, paddingBottom: 8, paddingLeft: 12, paddingRight: 0, width: 0, height: 0)
        } else {
            //Fallback on earlier versions
        }
        
        
        setupLineSeparatorView()

    }
    
    func clearCommentTextView() {
        commentTextView.text = nil
        commentTextView.showPlaceholderLabel()
    }
    
    fileprivate func setupLineSeparatorView() {
        let lineSeparatorView = UIView()
        lineSeparatorView.backgroundColor = UIColor.rgb(red: 230, green: 230, blue: 230)
        addSubview(lineSeparatorView)
        lineSeparatorView.anchor(top: topAnchor, bottom: nil, left: leftAnchor, right: rightAnchor, paddingTop: 0, paddingBottom: 0, paddingLeft: 0, paddingRight: 0, width: 0, height: 1)
    }
    
    @objc fileprivate func handleSubmit() {
        guard let commentText = commentTextView.text else { return }
        delegate?.didSubmit(for: commentText)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
