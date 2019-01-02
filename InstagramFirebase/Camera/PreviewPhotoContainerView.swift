//
//  PreviewPhotoContainerView.swift
//  InstagramFirebase
//
//  Created by Will Wang on 12/27/18.
//  Copyright © 2018 Will Wang. All rights reserved.
//

import UIKit
import Photos


class PreviewPhotoContainerView: UIView {
    
    let photoImageView: UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFill
        return iv
    }()
    
    let saveButton: UIButton = {
       let button = UIButton(type: .system)
        button.setImage(#imageLiteral(resourceName: "save_shadow").withRenderingMode(.alwaysOriginal), for: .normal)
        button.addTarget(self, action: #selector(handleSave), for: .touchUpInside)
        return button
    }()
    
    let cancelButton: UIButton = {
       let button = UIButton(type: .system)
        button.setImage(#imageLiteral(resourceName: "cancel_shadow").withRenderingMode(.alwaysOriginal), for: .normal)
        button.addTarget(self, action: #selector(handleCancel), for: .touchUpInside)
        return button
    }()
    
    let saveSuccessLabel: UILabel = {
        let label = UILabel()
        label.text = "Save Successfully"
        label.font = .systemFont(ofSize: 18, weight: .bold)
        label.textAlignment = .center
        label.textColor = .white
        label.backgroundColor = UIColor(white: 0, alpha: 0.3)
        label.numberOfLines = 0
        
        label.frame = CGRect(x: 0, y: 0, width: 150, height: 80)
        
        return label
    }()
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        addSubview(photoImageView)
        addSubview(cancelButton)
        addSubview(saveButton)

        photoImageView.anchor(top: topAnchor, bottom: bottomAnchor, left: leftAnchor, right: rightAnchor, paddingTop: 0, paddingBottom: 0, paddingLeft: 0, paddingRight: 0, width: 0, height: 0)
        
        cancelButton.anchor(top: safeAreaLayoutGuide.topAnchor, bottom: nil, left: nil, right: rightAnchor, paddingTop: 0, paddingBottom: 0, paddingLeft: 0, paddingRight: 12, width: 50, height: 50)
        
        saveButton.anchor(top: nil, bottom: bottomAnchor, left: nil, right: rightAnchor, paddingTop: 0, paddingBottom: 25, paddingLeft: 0, paddingRight: 12, width: 50, height: 50)
    }
    
    @objc func handleSave() {
        
        let library = PHPhotoLibrary.shared()
        guard let image = self.photoImageView.image else { return }
        
        library.performChanges({
            PHAssetChangeRequest.creationRequestForAsset(from: image)
        }) { (success, error) in
            if let error = error {
                print(error)
            }
            print("Successfully saved image in Photos")
            
            DispatchQueue.main.async {
                
                self.addSubview(self.saveSuccessLabel)
                
                self.saveSuccessLabel.center = self.center
                self.saveSuccessLabel.layer.transform = CATransform3DMakeScale(0, 0, 0)
                
                UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 0.5, initialSpringVelocity: 0.5, options: .curveEaseOut, animations: {
                    
                    self.saveSuccessLabel.layer.transform = CATransform3DMakeScale(1, 1, 1)
                    
                }, completion: { (completed) in
                    
                    UIView.animate(withDuration: 0.5, delay: 0.75, usingSpringWithDamping: 0.5, initialSpringVelocity: 0.5, options: .curveEaseOut, animations: {
                        
                        self.saveSuccessLabel.layer.transform = CATransform3DMakeScale(0.1, 0.1, 0.1)
                        self.saveSuccessLabel.alpha = 0
                        
                    }, completion: { (completed) in
                        
                        self.saveSuccessLabel.removeFromSuperview()
                        self.removeFromSuperview()
                    })
                })
            }
            
            
            
            
        }
    }
    
    @objc func handleCancel() {
        removeFromSuperview()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
