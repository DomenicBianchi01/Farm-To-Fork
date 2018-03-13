//
//  UIViewControllerExtensions.swift
//  Farm To Fork
//
//  Created by Domenic Bianchi on 2018-03-08.
//  Copyright © 2018 Domenic Bianchi & Marshall Asch. All rights reserved.
//

import UIKit

extension UIViewController {
    /// Dismiss the first responder from the screen.
    @objc func dismissFirstResponder() {
        view.endEditing(true)
    }
}
