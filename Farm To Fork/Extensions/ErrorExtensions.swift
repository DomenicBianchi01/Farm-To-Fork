//
//  ErrorExtensions.swift
//  Farm To Fork
//
//  Created by Domenic Bianchi on 2018-03-07.
//  Copyright © 2018 Domenic Bianchi & Marshall Asch. All rights reserved.
//

import Foundation

extension Error {
    var customDescription: String {
        let error = self as NSError
        return "\(error.domain)\nError Code: \(error.code)"
    }
    
    var description: String {
        return (self as NSError).domain
    }
}
