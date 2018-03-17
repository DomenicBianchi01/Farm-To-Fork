//
//  RegisterAccountSegue.swift
//  Farm To Fork
//
//  Created by Domenic Bianchi on 2018-03-07.
//  Copyright © 2018 Domenic Bianchi & Marshall Asch. All rights reserved.
//

import UIKit

final class RegisterAccountSegue: UIStoryboardSegue {
    // MARK: - Segue Functions
    override func perform() {
        let transition: CATransition = CATransition()
        let timeFunc : CAMediaTimingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseInEaseOut)
        transition.duration = 0.25
        transition.timingFunction = timeFunc
        transition.type = kCATransitionPush
        transition.subtype = kCATransitionFromRight
        source.navigationController?.view.layer.add(transition, forKey: kCATransition)
        source.navigationController?.pushViewController(destination, animated: false)
		
    }
}
