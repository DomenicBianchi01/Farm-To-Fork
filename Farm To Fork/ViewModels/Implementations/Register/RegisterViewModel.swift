//
//  RegisterViewModel.swift
//  Farm To Fork
//
//  Created by Domenic Bianchi on 2018-03-08.
//  Copyright © 2018 Domenic Bianchi & Marshall Asch. All rights reserved.
//

import Foundation
import UIKit

final class RegisterViewModel {
    // MARK: - Properties
    private(set) var user = User()
    private var passwordElements: PasswordComponents = []
    
    // MARK: - Structs
    /// The requirements of a valid password for Farm To Fork. All components of the `OptionSet` must be valid in order for the password to be valid.
    private struct PasswordComponents: OptionSet {
        let rawValue: Int
        
        /// Length requirement
        static let characters = PasswordComponents(rawValue: 1 << 0)
        /// Numbers requirement
        static let numbers = PasswordComponents(rawValue: 1 << 1)
        /// Uppercase letter requirement
        static let uppercase = PasswordComponents(rawValue: 1 << 2)
        /// Lowercase letter requirement
        static let lowercase = PasswordComponents(rawValue: 1 << 3)
        
        /// Given which requirements the password meets and doesn't meet, this function generates a string that describes what is still missing from the password
        func asString() -> String {
            var string = ""
            
            if !self.contains(.characters) {
                string += "8 characters, "
            }
            if !self.contains(.numbers) {
                string += "1 number, "
            }
            if !self.contains(.uppercase) {
                string += "1 uppercase, "
            }
            if !self.contains(.lowercase) {
                string += "1 lowercase, "
            }
            
            if string.count > 2 {
                return String(string.dropLast(2))
            }
            return "Valid Password!"
        }
    }
    
    // MARK: - Helper Functions
    func update(firstName: String) {
        user.firstName = firstName
    }
    
    func update(lastName: String) {
        user.lastName = lastName
    }
    
    func update(email: String) {
        user.email = email
    }
    
    func update(password1: String, password2: String) -> Bool {
        if verify(password1: password1, password2: password2) {
            user.password = password1
            return true
        }
        return false
    }
    
    func verify(password1: String, password2: String) -> Bool {
        if password1 == password2 {
            return true
        }
        return false
    }
    
    func updatePasswordElements(_ password: String) {
        if password.count >= 8 {
            passwordElements.insert(.characters)
        } else {
            passwordElements.remove(.characters)
        }
        
        if password.containsDigit {
            passwordElements.insert(.numbers)
        } else {
            passwordElements.remove(.numbers)
        }
        
        if password.containsUppercase {
            passwordElements.insert(.uppercase)
        } else {
            passwordElements.remove(.uppercase)
        }
        
        if password.containsLowercase {
            passwordElements.insert(.lowercase)
        } else {
            passwordElements.remove(.lowercase)
        }
    }
    
    var passwordIsValid: Bool {
        return passwordElements.rawValue == PasswordComponents.characters.rawValue + PasswordComponents.numbers.rawValue + PasswordComponents.lowercase.rawValue + PasswordComponents.uppercase.rawValue
    }
    
    var passwordRequirementsError: NSError {
        return NSError(domain: "MFDemoErrorDomain", code: 100, userInfo: [NSLocalizedDescriptionKey: passwordElements.asString()])
    }
}
