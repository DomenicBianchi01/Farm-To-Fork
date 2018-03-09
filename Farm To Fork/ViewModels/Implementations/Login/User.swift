//
//  User.swift
//  Farm To Fork
//
//  Created by Domenic Bianchi on 2018-03-06.
//  Copyright © 2018 Domenic Bianchi & Marshall Asch. All rights reserved.
//

import Foundation

struct User {
    var firstName: String = ""
    var lastName: String = ""
    var email: String = ""
    var password: String = ""
    var country: (key: String, value: String) = (key: "", value: "")
    var province: (key: String, value: String) = (key: "", value: "")
    var city: (key: String, value: String) = (key: "", value: "")
}
