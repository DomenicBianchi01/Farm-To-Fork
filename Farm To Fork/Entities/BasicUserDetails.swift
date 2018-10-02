//
//  BasicUserDetails.swift
//  Farm To Fork
//
//  Created by Domenic Bianchi on 2018-09-22.
//  Copyright © 2018 Domenic Bianchi. All rights reserved.
//

import Foundation

/// A simple class meant to represent just an email and password for a user (all properties in this class are mutable). The actual `User` object should be used to store actual user details fetched from the database. Note that this class permits the storage of a password while the `User` class does not. Passwords should only be stored in the keychain or in a property used for registering a user.
final class BasicUserDetails {
    // MARK: - Properties
    var email: String
    var password: String
    
    // MARK: - Lifecycle Functions
    init(email: String = "",
         password: String = "") {
        self.email = email
        self.password = password
    }
}
