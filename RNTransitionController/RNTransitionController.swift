//
//  RNTransitionController.swift
//  RNTransitionController
//
//  Created by Rayhan Janam on 6/27/18.
//  Copyright © 2018 Rayhan Janam. All rights reserved.
//

import UIKit

/// Default transition duration of 0.25 seconds
public let RNTransitionAnimationDuration: TimeInterval = 0.25

/// UIViewController transition controller
///
/// Provides custom transtions when presenting or dismissing view controllers
public class RNTransitionController: NSObject {

    private(set) public var duration: TimeInterval
    private(set) public var subviewTag: Int

    private(set) public var currentState: RNTransitionState!
    private(set) public var animation: RNTransitionAnimation!
    
    public override init() {
        
        self.duration = RNTransitionAnimationDuration
        self.subviewTag = 0
        
    }
    
    
    /// Presents a view controller with specified transition animation
    ///
    /// - Parameters:
    ///   - presentedViewController: View controller which is to be presented
    ///   - presentingViewController: View controller which is presenting the modal view controller
    ///   - animation: Transition animation option
    ///   - completion: Performs when presentation is complete
    public func present(viewController presentedViewController: UIViewController, from presentingViewController: UIViewController, animation: RNTransitionAnimation, completion: (() -> Void)? = nil) {
        
        self.animation = animation
        
        presentedViewController.view.isOpaque = true
        presentedViewController.modalPresentationStyle = .custom
        
        presentedViewController.modalPresentationCapturesStatusBarAppearance = true
        presentedViewController.setNeedsStatusBarAppearanceUpdate()
        
        presentedViewController.transitioningDelegate = self
        presentingViewController.present(presentedViewController, animated: true, completion: completion)
        
    }
    
    
    /// Presents a view controller with specified transition animation
    ///
    /// - Parameters:
    ///   - presentedViewController: View controller which is to be presented
    ///   - presentingViewController: View controller which is presenting the modal view controller
    ///   - animation: Transition animation option
    ///   - duration: Duration of the transition animation
    ///   - completion: Performs when presentation is complete
    public func present(viewController presentedViewController: UIViewController, from presentingViewController: UIViewController, animation: RNTransitionAnimation, duration: TimeInterval, completion: (() -> Void)? = nil) {
        
        self.duration = duration
        
        self.present(viewController: presentedViewController, from: presentingViewController, animation: animation, completion: completion)
        
    }
    
    
    /// Presents a view controller with specified transition animation
    ///
    /// - Parameters:
    ///   - presentedViewController: View controller which is to be presented
    ///   - presentingViewController: View controller which is presenting the modal view controller
    ///   - animation: Transition animation option
    ///   - duration: Duration of the transition animation
    ///   - subviewTag: The tag value associated with the view which to be animated with fadeInWithSubviewZoomIn animation option
    ///   - completion: Performs when presentation is complete
    public func present(viewController presentedViewController: UIViewController, from presentingViewController: UIViewController, animation: RNTransitionAnimation, duration: TimeInterval, subviewTag: Int, completion: (() -> Void)? = nil) {
        
        self.duration = duration
        self.subviewTag = subviewTag
        
        self.present(viewController: presentedViewController, from: presentingViewController, animation: animation, completion: completion)
        
    }
    
}

// MARK: - UIViewControllerTransitionDelegate Methods

extension RNTransitionController: UIViewControllerTransitioningDelegate {
    
    public func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        
        self.currentState = .presenting
        return self
        
    }
    
    public func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        
        self.currentState = .dismissing
        return self
        
    }
    
}

// MARK: - UIViewControllerAnimatedTransitioning delegate methods

extension RNTransitionController: UIViewControllerAnimatedTransitioning {
    
    public func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        
        return self.duration
        
    }
    
    public func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        
        let firstViewController = transitionContext.viewController(forKey: .from)
        let secondViewController = transitionContext.viewController(forKey: .to)
        
        if let firstView = firstViewController?.view,
            let secondView = secondViewController?.view {
            
            let containerView = transitionContext.containerView
            
            switch (self.animation!) {
                
            case .coverVertical:
                self.coverVerticalAnimation(with: transitionContext, containerView: containerView, firstView: firstView, secondView: secondView)
            
            case .coverHorizontal:
                self.coverHorizontalAnimation(with: transitionContext, containerView: containerView, firstView: firstView, secondView: secondView)
                
            case .fadeIn:
                self.fadeInAnimation(with: transitionContext, containerView: containerView, firstView: firstView, secondView: secondView)
                
            case .fadeInWithSubviewZoomIn:
                self.fadeInWithSubviewZoomInAnimation(with: transitionContext, containerView: containerView, firstView: firstView, secondView: secondView, subviewTag: self.subviewTag)
                
            case .slideIn:
                self.slideInAnimation(with: transitionContext, containerView: containerView, firstView: firstView, secondView: secondView)
                
            }
        }
        
    }
    
}

// MARK: - Private Animation Methods

private extension RNTransitionController {
    
    private func coverVerticalAnimation(with transitionContext: UIViewControllerContextTransitioning, containerView: UIView, firstView: UIView, secondView: UIView) {
        
        let originX = containerView.frame.origin.x
        let originY = containerView.frame.origin.y + containerView.frame.size.height
        let width = containerView.frame.size.width
        let height = containerView.frame.size.height
        
        let offsetFrame = CGRect(x: originX, y: originY, width: width, height: height)
        
        switch (currentState!) {
            
        case .presenting:
            containerView.addSubview(secondView)
            secondView.frame = offsetFrame
            
            UIView.animate(withDuration: self.duration, delay: 0.0, options: .curveEaseOut, animations: {
                
                secondView.frame = containerView.frame
                
            }) { (finished) in
                transitionContext.completeTransition(finished)
            }
            
        case .dismissing:
            UIView.animate(withDuration: self.duration, animations: {
                
                firstView.frame = offsetFrame
                
            }) { (finished) in
                transitionContext.completeTransition(finished)
            }
            
        }
        
    }
    
    private func coverHorizontalAnimation(with transitionContext: UIViewControllerContextTransitioning, containerView: UIView, firstView: UIView, secondView: UIView) {
        
        let originX = containerView.frame.origin.x + containerView.frame.size.width
        let originY = containerView.frame.origin.y
        let width = containerView.frame.size.width
        let height = containerView.frame.size.height
        
        let offsetFrame = CGRect(x: originX, y: originY, width: width, height: height)
        
        switch (currentState!) {
            
        case .presenting:
            containerView.addSubview(secondView)
            secondView.frame = offsetFrame
            
            UIView.animate(withDuration: self.duration, delay: 0.0, options: .curveEaseOut, animations: {
                
                secondView.frame = containerView.frame
                
            }) { (finished) in
                transitionContext.completeTransition(finished)
            }
            
        case .dismissing:
            UIView.animate(withDuration: self.duration, animations: {
                
                firstView.frame = offsetFrame
                
            }) { (finished) in
                transitionContext.completeTransition(finished)
            }
            
        }
        
    }
    
    private func fadeInAnimation(with transitionContext: UIViewControllerContextTransitioning, containerView: UIView, firstView: UIView, secondView: UIView) {
        
        switch currentState! {
            
        case .presenting:
            containerView.addSubview(secondView)
            secondView.alpha = 0.0
            
            UIView.animate(withDuration: self.duration, delay: 0.0, options: .curveEaseOut, animations: {
                
                secondView.alpha = 1.0
                
            }) { (finished) in
                transitionContext.completeTransition(finished)
            }
            
        case .dismissing:
            UIView.animate(withDuration: self.duration, animations: {
                
                firstView.alpha = 0.0
                
            }) { (finished) in
                transitionContext.completeTransition(finished)
            }

        }
        
    }
    
    private func fadeInWithSubviewZoomInAnimation(with transitionContext: UIViewControllerContextTransitioning, containerView: UIView, firstView: UIView, secondView: UIView, subviewTag: Int) {
        
        switch currentState! {
            
        case .presenting:
            containerView.addSubview(secondView)
            secondView.alpha = 0.0
            
            let thirdView = secondView.viewWithTag(subviewTag)
            
            if thirdView != nil {
                thirdView!.transform = CGAffineTransform(scaleX: 0, y: 0)
            }
            
            UIView.animate(withDuration: self.duration, delay: 0.0, options: .curveEaseOut, animations: {
                
                secondView.alpha = 1.0
                
                if thirdView != nil {
                    thirdView!.transform = CGAffineTransform.identity
                }
                
            }) { (finished) in
                transitionContext.completeTransition(finished)
            }
            
        case .dismissing:
            UIView.animate(withDuration: self.duration, animations: {
                
                firstView.alpha = 0.0
                
            }) { (finished) in
                transitionContext.completeTransition(finished)
            }
        }
        
    }
    
    private func slideInAnimation(with transitionContext: UIViewControllerContextTransitioning, containerView: UIView, firstView: UIView, secondView: UIView) {
        
        let originX = containerView.frame.origin.x + containerView.frame.size.width
        let originY = containerView.frame.origin.y
        let width = containerView.frame.size.width
        let height = containerView.frame.size.height
        
        switch currentState! {
            
        case .presenting:
            containerView.addSubview(secondView)
            
            firstView.frame = containerView.frame
            secondView.frame = CGRect(x: originX, y: originY, width: width, height: height)
            
            let newOriginX = containerView.frame.origin.x - containerView.frame.size.width
            
            UIView.animate(withDuration: self.duration, delay: 0.0, options: .curveEaseOut, animations: {
                
                firstView.frame = CGRect(x: newOriginX, y: originY, width: width, height: height)
                secondView.frame = containerView.frame
                
            }) { (finished) in
                transitionContext.completeTransition(finished)
            }
            
        case .dismissing:
            UIView.animate(withDuration: self.duration, animations: {
                
                firstView.frame = CGRect(x: originX, y: originY, width: width, height: height)
                secondView.frame = containerView.frame
                
            }) { (finished) in
                transitionContext.completeTransition(finished)
            }
            
        }
        
    }
    
}















