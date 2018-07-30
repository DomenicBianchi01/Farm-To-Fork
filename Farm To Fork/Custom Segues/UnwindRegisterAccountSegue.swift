//
//  UnwindRegisterAccountSegue.swift
//  Farm To Fork
//
//  Created by Domenic Bianchi on 2018-03-07.
//  Copyright © 2018 Domenic Bianchi & Marshall Asch. All rights reserved.
//

import UIKit

final class UnwindRegisterAccountSegue: UIStoryboardSegue {
    // MARK: - Segue Functions
    override func perform() {
        let transition: CATransition = CATransition()
        let timeFunc : CAMediaTimingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeInEaseOut)
        transition.duration = 0.25
        transition.timingFunction = timeFunc
        transition.type = CATransitionType.push
        transition.subtype = CATransitionSubtype.fromLeft
        source.navigationController?.view.layer.add(transition, forKey: kCATransition)
        source.navigationController?.popViewController(animated: false)
	}
}
