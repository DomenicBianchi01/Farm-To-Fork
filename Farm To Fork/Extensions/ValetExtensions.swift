//
//  ValetExtensions.swift
//  Farm To Fork
//
//  Created by Domenic Bianchi on 2018-07-29.
//  Copyright © 2018 Domenic Bianchi. All rights reserved.
//

import Foundation
import Valet

extension Valet {
    static var F2FValet: Valet {
        // Based on the contents of the `Identifier`, it is 100% safe to force unwrap
        return Valet.valet(with: Identifier(nonEmpty: "FarmToFork")!, accessibility: .whenUnlocked)
    }
}
