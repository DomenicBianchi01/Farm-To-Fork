//
//  Result.swift
//  Farm To Fork
//
//  Created by Domenic Bianchi on 2018-03-05.
//  Copyright © 2018 Domenic Bianchi & Marshall Asch. All rights reserved.
//

import Foundation

//https://www.sitepoint.com/improve-swift-closures-result/
/// A generic enum to use in order to return values or errors from completion blocks.
enum Result<T> {
    case success(T)
    case error(Error)
}
