//
//  BooleanExtensions.swift
//  Farm To Fork
//
//  Created by Domenic Bianchi on 2018-10-07.
//  Copyright © 2018 Domenic Bianchi. All rights reserved.
//

import Foundation

extension Bool {
    /// Returns "1" if true, "0" if false
    var asString: String {
        if self {
            return "1"
        }
        return "0"
    }
}
