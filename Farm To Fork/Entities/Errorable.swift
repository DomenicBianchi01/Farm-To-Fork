//
//  Errorable.swift
//  Farm To Fork
//
//  Created by Domenic Bianchi on 2018-08-03.
//  Copyright © 2018 Domenic Bianchi. All rights reserved.
//

import Foundation

//Can't use Error so Errorable it is!
/// A class that can be used to decode a JSON response containing only an error
class Errorable: Decodable {
    var error: String? = nil
}
