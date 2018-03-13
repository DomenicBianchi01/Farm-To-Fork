//
//  LoginViewModel.swift
//  Farm To Fork
//
//  Created by Domenic Bianchi on 2018-03-06.
//  Copyright © 2018 Domenic Bianchi & Marshall Asch. All rights reserved.
//

import Foundation
import SwiftKeychainWrapper

final class LoginViewModel {
    // MARK: - Properties
    private var user = User()
    
    // MARK: - Helper Functions
    func attemptLogin(with completion: @escaping (Result<Void>) -> Void) {
        LoginService().login(user: user) { result in
            completion(result)
        }
    }
    
    func updateEmail(email: String) {
        user.email = email
    }
    
    func updatePassword(password: String) {
        user.password = password
    }
    
    func savePasswordToKeychain() {
        if newManualSignIn {
            if KeychainWrapper.standard.set(user.password, forKey: Constants.password) && KeychainWrapper.standard.set(user.email, forKey: Constants.username) {
                UserDefaults.standard.set(true, forKey: Constants.passwordSaved)
            }
        }
    }
    
    // MARK: - Functions
    func removePasswordFromKeychain() {
        if KeychainWrapper.standard.removeAllKeys() {
            UserDefaults.standard.removeObject(forKey: Constants.passwordSaved)
        }
    }
    
    func enableLoginPreference(_ preference: LoginPreference) {
        UserDefaults.standard.set(preference.rawValue, forKey: Constants.loginPreference)
    }
    
    var firstLogin: Bool {
        return !UserDefaults.standard.bool(forKey: Constants.loginPreference)
    }
    
    private var newManualSignIn: Bool {
        return !UserDefaults.standard.bool(forKey: Constants.passwordSaved)
    }
}
