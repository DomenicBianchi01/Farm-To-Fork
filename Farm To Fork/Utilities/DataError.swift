//
//  DataError.swift
//  Farm To Fork
//
//  Created by Domenic Bianchi on 2018-03-09.
//  Copyright © 2018 Domenic Bianchi & Marshall Asch. All rights reserved.
//

import Foundation

extension Error {
    var description: String {
        return (self as NSError).domain
    }
}
