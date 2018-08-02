//
//  UIViewControllerExtensions.swift
//  Farm To Fork
//
//  Created by Domenic Bianchi on 2018-03-08.
//  Copyright © 2018 Domenic Bianchi & Marshall Asch. All rights reserved.
//

import UIKit
import SCLAlertView

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
    
    /**
     Display a basic `SCLAlert` (third-party alert view)
     
     - parameter title: The title of the alert
     - parameter message: The message to be displayed on the alert
     - parameter closeButtonTitle: The text to be displayed on the close button. Defaults to "OK"
     - parameter style: The style of the alert. This value comes from the `SCLAlertViewStyle` enum. For example, `.success` will display an alert with a green tint and a checkmark image.
    */
    func displaySCLAlert(_ title: String, message: String, closeButtonTitle: String = "OK", style: SCLAlertViewStyle) {
        // Dispatching to main queue just to be safe per: https://github.com/vikmeup/SCLAlertView-Swift/issues/377
        DispatchQueue.main.async {
            switch style {
            case .success:
                SCLAlertView().showSuccess(title, subTitle: message, closeButtonTitle: closeButtonTitle)
            case .warning:
                SCLAlertView().showWarning(title, subTitle: message, closeButtonTitle: closeButtonTitle)
            case .error:
                SCLAlertView().showError(title, subTitle: message, closeButtonTitle: closeButtonTitle)
            case .notice:
                SCLAlertView().showNotice(title, subTitle: message, closeButtonTitle: closeButtonTitle)
            default:
                // Default to info type
                SCLAlertView().showInfo(title, subTitle: message, closeButtonTitle: closeButtonTitle)
            }
        }
    }
}
