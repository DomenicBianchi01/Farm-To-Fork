//
//  RegisterUserDetails.swift
//  Farm To Fork
//
//  Created by Domenic Bianchi on 2018-09-22.
//  Copyright © 2018 Domenic Bianchi. All rights reserved.
//

import Foundation

struct RegisterUserDetails {
    // MARK: - Properties
    var email: String
    var password: String
    var firstName: String
    var lastName: String
    var cityId: String
    
    
    // MARK: - Lifecycle Functions
    init(email: String = "",
         password: String = "",
         firstName: String = "",
         lastName: String = "",
         cityId: String = "") {

        self.email = email
        self.password = password
        self.firstName = firstName
        self.lastName = lastName
        self.cityId = cityId
    }
}
