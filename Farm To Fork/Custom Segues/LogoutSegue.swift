//
//  LogoutSegue.swift
//  Farm To Fork
//
//  Created by Domenic Bianchi on 2018-03-18.
//  Copyright © 2018 Domenic Bianchi & Marshall Asch. All rights reserved.
//

import UIKit

final class LogoutSegue: UIStoryboardSegue {
    // MARK: - Segue Functions
    override func perform() {
        let transition: CATransition = CATransition()
        let timeFunc : CAMediaTimingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseInEaseOut)
        transition.duration = 0.5
        transition.timingFunction = timeFunc
        transition.type = kCATransitionReveal
        transition.subtype = kCATransitionFromBottom
        source.navigationController?.view.layer.add(transition, forKey: kCATransition)
        source.navigationController?.pushViewController(destination, animated: false)
    }
}
