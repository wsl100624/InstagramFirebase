//
//  CommentInputTextView.swift
//  InstagramFirebase
//
//  Created by Will Wang on 1/14/19.
//  Copyright © 2019 Will Wang. All rights reserved.
//

import UIKit

class CommentInputTextView: UITextView {

    
    fileprivate let placeholderLabel: UILabel = {
        let label = UILabel()
        label.text = "Enter Comment"
        label.textColor = .lightGray
        
        return label
    }()
    
    func showPlaceholderLabel() {
        placeholderLabel.isHidden = false
    }
    
    override init(frame: CGRect, textContainer: NSTextContainer?) {
        super.init(frame: frame, textContainer: textContainer)
        
        addSubview(placeholderLabel)
        placeholderLabel.anchor(top: topAnchor, bottom: bottomAnchor, left: leftAnchor, right: rightAnchor, paddingTop: 8, paddingBottom: 8, paddingLeft: 2, paddingRight: 0, width: 0, height: 0)
        
        NotificationCenter.default.addObserver(self, selector: #selector(handleTextChanged), name: UITextView.textDidChangeNotification, object: nil)
        
    }
    
    @objc func handleTextChanged() {
        placeholderLabel.isHidden = !self.text.isEmpty
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
