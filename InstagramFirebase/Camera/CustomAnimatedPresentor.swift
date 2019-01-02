//
//  CustomAnimatedPresentor.swift
//  InstagramFirebase
//
//  Created by Will Wang on 12/29/18.
//  Copyright © 2018 Will Wang. All rights reserved.
//

import UIKit

class CustomAnimatedPresentor: NSObject, UIViewControllerAnimatedTransitioning {
    
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return 0.5
    }
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        
        let containerView = transitionContext.containerView
        
        guard let fromView = transitionContext.view(forKey: .from) else { return }
        
        guard let toView = transitionContext.view(forKey: .to) else { return }
        
        let staringFrameForToView = CGRect(x: -toView.frame.width, y: 0, width: toView.frame.width, height: toView.frame.height)
        toView.frame = staringFrameForToView
        
        containerView.addSubview(toView)
        
        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 1.0, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
            
            fromView.frame = CGRect(x: fromView.frame.width, y: 0, width: fromView.frame.width, height: fromView.frame.height)
            
            toView.frame = CGRect(x: 0, y: 0, width: toView.frame.width, height: toView.frame.height)
            
        }) { (_) in
            transitionContext.completeTransition(true)
        }
    }
    
}
