//
//  DoubleExtensions.swift
//  Farm To Fork
//
//  Created by Domenic Bianchi on 2018-03-26.
//  Copyright © 2018 Domenic Bianchi & Marshall Asch. All rights reserved.
//

import Foundation

extension Double {
    /// Rounds the given `Double` to two decimal places
    func round() -> Double {
        return (self * 100).rounded() / 100
    }
}
