//
//  ErrorExtensions.swift
//  Farm To Fork
//
//  Created by Domenic Bianchi on 2018-03-07.
//  Copyright © 2018 Domenic Bianchi & Marshall Asch. All rights reserved.
//

import Foundation

extension Error {
    /// Displays the `domain` and `code` of the error
    var customDescription: String {
        let error = self as NSError
        return "\(error.domain)\nError Code: \(error.code)"
    }
    
    /// Displays only the `domain` of the error
    var description: String {
        return (self as NSError).domain
    }
}
