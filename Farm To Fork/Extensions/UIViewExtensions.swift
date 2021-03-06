//
//  UIViewExtensions.swift
//  Farm To Fork
//
//  Created by Domenic Bianchi on 2018-03-07.
//  Copyright © 2018 Domenic Bianchi & Marshall Asch. All rights reserved.
//

import UIKit

extension UIView {
    /// Applies a blue effect using the specified style to the view. This function has no effect on the view if the user has turned on the "Reduce Transparency" option in the iOS settings.
    func applyBlurEffect(using style: UIBlurEffect.Style, cornerRadius: CGFloat = 0, corners: UIRectCorner = []) {
        if !UIAccessibility.isReduceTransparencyEnabled {
            backgroundColor = .clear
            let blurEffect = UIBlurEffect(style: style)
            let blurEffectView = UIVisualEffectView(effect: blurEffect)
            blurEffectView.frame = bounds
            
            let maskPath = UIBezierPath(roundedRect: bounds,
                                        byRoundingCorners: corners,
                                        cornerRadii: CGSize(width: cornerRadius, height: 0.0))
            
            let maskLayer = CAShapeLayer()
            maskLayer.path = maskPath.cgPath
            blurEffectView.layer.mask = maskLayer
            
            blurEffectView.clipsToBounds = true
            blurEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
            insertSubview(blurEffectView, at: 0)
        }
    }
    
    /// Adds a very thin gray shadow along the border of all four edges of the view
    func addShadow() {
        layer.shadowOpacity = 0.5
        layer.shadowColor = UIColor.gray.cgColor
        layer.shadowOffset = CGSize(width: 0, height: 0)
        layer.shadowRadius = 2
    }
    
    /// Rapidly but shortly shakes the given view horizontally. In the context of this app, an example would be providing an invalid password when logging in and shaking the password and username text fields to indicate the credentials provided were invalid.
    func shake() {
        let animation = CABasicAnimation(keyPath: "position")
        animation.duration = 0.07
        animation.repeatCount = 3
        animation.autoreverses = true
        animation.fromValue = CGPoint(x: center.x - 5, y: center.y)
        animation.toValue = CGPoint(x: center.x + 5, y: center.y)
        
        layer.add(animation, forKey: "position")
    }
}
