//
//  Result.swift
//  Farm To Fork
//
//  Created by Domenic Bianchi on 2018-03-05.
//  Copyright © 2018 Domenic Bianchi & Marshall Asch. All rights reserved.
//

import Foundation

/// A generic enum to include when using completion blocks in order to return values or errors.
//https://www.sitepoint.com/improve-swift-closures-result/
enum Result<T> {
    case success(T)
    case error(Error)
}
