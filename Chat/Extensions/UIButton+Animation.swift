//
//  UIButton+ShakeAnimation.swift
//  Chat
//
//  Created by Anton Bebnev on 26.11.2020.
//  Copyright © 2020 Anton Bebnev. All rights reserved.
//

import UIKit

extension UIButton {
    private enum AnimationType: String {
        case shake
    }
    
    func addShakeAnimation() {
        let animationMove = CAKeyframeAnimation(keyPath: #keyPath(CALayer.position))
        animationMove.values = [
            layer.position,
            CGPoint(x: layer.position.x - 5, y: layer.position.y),
            CGPoint(x: layer.position.x, y: layer.position.y - 5),
            CGPoint(x: layer.position.x + 5, y: layer.position.y),
            CGPoint(x: layer.position.x, y: layer.position.y + 5)
        ]
        animationMove.keyTimes = [0, 0.25, 0.5, 0.75, 1.0]
        
        let animationRotation = CABasicAnimation(keyPath: "transform.rotation.z")
        animationRotation.fromValue = -CGFloat.pi / 10
        animationRotation.toValue = CGFloat.pi / 10
        
        let group = CAAnimationGroup()
        group.duration = 0.3
        group.autoreverses = true
        group.repeatCount = .infinity
        group.animations = [animationMove, animationRotation]
        
        layer.add(group, forKey: AnimationType.shake.rawValue)
        
        CATransaction.begin()
        CATransaction.commit()
    }
    
    func removeShakeAnimation() {
        let animationMove = CABasicAnimation(keyPath: #keyPath(CALayer.position))
        animationMove.fromValue = layer.presentation()?.position
        animationMove.toValue = layer.position
        
        let animationRotation = CABasicAnimation(keyPath: "transform.rotation.z")
        guard let rotationZ = layer.presentation()?.value(forKeyPath: "transform.rotation.z") as? CGFloat else { return }
        animationRotation.fromValue = rotationZ
        animationRotation.toValue = 0
        
        let group = CAAnimationGroup()
        group.animations = [animationMove, animationRotation]
        group.duration = 0.3
        group.fillMode = .backwards
        
        layer.add(group, forKey: AnimationType.shake.rawValue)
        
        CATransaction.begin()
        CATransaction.commit()
    }
}
