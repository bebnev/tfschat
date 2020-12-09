//
//  BottomCardSegue.swift
//  Chat
//
//  Created by Anton Bebnev on 26.11.2020.
//  Copyright © 2020 Anton Bebnev. All rights reserved.
//

import UIKit

class BottomCardSegue: UIStoryboardSegue {
    // workaround for dismiss
    private var selfLink: BottomCardSegue?
    
    override func perform() {
        selfLink = self
        destination.modalPresentationStyle = .custom
        destination.transitioningDelegate = self
        source.present(destination, animated: true, completion: nil)
    }
}

extension BottomCardSegue: UIViewControllerTransitioningDelegate {
    public func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return Presenter()
    }

    public func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        selfLink = nil
        return Dismisser()
    }

    private class Presenter: NSObject, UIViewControllerAnimatedTransitioning {

        func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
            return 0.5
        }

        func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
            let container = transitionContext.containerView
            guard let toView = transitionContext.view(forKey: .to),
                  let fromViewController = transitionContext.viewController(forKey: .from) else {return}
            // Configure the layout
            do {
                toView.translatesAutoresizingMaskIntoConstraints = false
                container.addSubview(toView)
                
                let bottom = max(20 - toView.safeAreaInsets.bottom, 0)
                let constraints = [
                    container.safeAreaLayoutGuide.bottomAnchor.constraint(equalTo: toView.bottomAnchor, constant: bottom),
                    container.safeAreaLayoutGuide.leadingAnchor.constraint(equalTo: toView.leadingAnchor, constant: -20),
                    container.safeAreaLayoutGuide.trailingAnchor.constraint(equalTo: toView.trailingAnchor, constant: 20),
                    toView.heightAnchor.constraint(equalToConstant: toView.frame.height * 3 / 4)
                ]
                
                NSLayoutConstraint.activate(constraints)
            }
            // Apply some styling
            do {
                toView.layer.masksToBounds = true
                toView.layer.cornerRadius = 20
            }
            // Perform the animation
            do {
                container.layoutIfNeeded()
                let originalOriginY = toView.frame.origin.y
                toView.frame.origin.y += container.frame.height - toView.frame.minY
                UIView.animate(
                    withDuration: 0.5,
                    delay: 0,
                    usingSpringWithDamping: 0.8,
                    initialSpringVelocity: 0,
                    options: [],
                    animations: {
                        toView.frame.origin.y = originalOriginY
                        fromViewController.view.alpha = 0.4
                    },
                    completion: { (completed) in
                        transitionContext.completeTransition(completed)
                    }
                )
            }
        }
    }

    private class Dismisser: NSObject, UIViewControllerAnimatedTransitioning {

        func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
            return 0.2
        }

        func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
            let container = transitionContext.containerView
            guard let fromView = transitionContext.view(forKey: .from),
                  let toController = transitionContext.viewController(forKey: .to) else {return}
            
            UIView.animate(
                withDuration: 0.2,
                animations: {
                    fromView.frame.origin.y += container.frame.height - fromView.frame.minY
                    toController.view.alpha = 1
                },
                completion: {(completed) in
                    transitionContext.completeTransition(completed)
                }
            )
        }
    }
}
