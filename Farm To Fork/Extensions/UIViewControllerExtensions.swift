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
    
    /**
     Display a basic alert on the screen. Only an "OK" alert action will be included.
     
     - parameter title: The title of the alert
     - parameter message: The message to be displayed on the alert
     */
    func displayAlert(title: String, message: String) {
        DispatchQueue.main.async {
            let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
            let alertAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
            
            alert.addAction(alertAction)
            
            alert.popoverPresentationController?.sourceView = self.view
            alert.popoverPresentationController?.sourceRect = self.view.bounds
            
            self.present(alert, animated: true, completion: nil)
        }
    }
}
