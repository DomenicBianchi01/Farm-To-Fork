//
//  HTTPURLResponseExtensions.swift
//  Farm To Fork
//
//  Created by Domenic Bianchi on 2018-08-03.
//  Copyright © 2018 Domenic Bianchi. All rights reserved.
//

import Foundation

extension HTTPURLResponse {
    /// Returns true if the status code is between 400 and 599 (inclusive)
    var statusCodeIsError: Bool {
        switch self.statusCode {
        case 400..<599:
            return true
        default:
            return false
        }
    }
}
