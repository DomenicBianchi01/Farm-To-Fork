//
//  UIApplicationExtensions.swift
//  Farm To Fork
//
//  Created by Domenic Bianchi on 2018-11-07.
//  Copyright © 2018 Domenic Bianchi. All rights reserved.
//

import UIKit

extension UIApplication {
    //https://stackoverflow.com/a/30858591/4268022
    class func topViewController(controller: UIViewController? = UIApplication.shared.keyWindow?.rootViewController) -> UIViewController? {
        if let navigationController = controller as? UINavigationController {
            return topViewController(controller: navigationController.visibleViewController)
        }
        if let tabController = controller as? UITabBarController {
            if let selected = tabController.selectedViewController {
                return topViewController(controller: selected)
            }
        }
        if let presented = controller?.presentedViewController {
            return topViewController(controller: presented)
        }
        return controller
    }
}
