//
//  UIViewExtensions.swift
//  Farm To Fork
//
//  Created by Domenic Bianchi on 2018-03-07.
//  Copyright © 2018 Domenic Bianchi & Marshall Asch. All rights reserved.
//

import Foundation
import UIKit

extension UIView {
    /// Applies a blue effect using the specified style to the view. This function has no effect on the view if the user has turned on the "Reduce Transparency" option in the iOS settings.
    func applyBlurEffect(using style: UIBlurEffectStyle) {
        if !UIAccessibilityIsReduceTransparencyEnabled() {
            backgroundColor = .clear
            let blurEffect = UIBlurEffect(style: style)
            let blurEffectView = UIVisualEffectView(effect: blurEffect)
            blurEffectView.frame = frame
            blurEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
            insertSubview(blurEffectView, at: 0)
        }
    }
    
    func shake() {
        let animation = CABasicAnimation(keyPath: "position")
        animation.duration = 0.07
        animation.repeatCount = 3
        animation.autoreverses = true
        animation.fromValue = NSValue(cgPoint: CGPoint(x: center.x - 5, y: center.y))
        animation.toValue = NSValue(cgPoint: CGPoint(x: center.x + 5, y: center.y))
        
        layer.add(animation, forKey: "position")
    }
}
