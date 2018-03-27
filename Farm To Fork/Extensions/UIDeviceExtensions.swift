//
//  UIDeviceExtensions.swift
//  Farm To Fork
//
//  Created by Domenic Bianchi on 2018-03-27.
//  Copyright © 2018 Domenic Bianchi & Marshall Asch. All rights reserved.
//

import UIKit

extension UIDevice {
    /// For alert controllers that display as an Action Sheet on iPhone, this property will make sure the alert controller displays as an Alert on iPad.
    static var alertStyle: UIAlertControllerStyle {
        return UIDevice.current.userInterfaceIdiom == UIUserInterfaceIdiom.phone ? .actionSheet : .alert
    }
}
