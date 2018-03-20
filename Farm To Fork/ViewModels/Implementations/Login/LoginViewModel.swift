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
                UserDefaults.appGroup?.set(true, forKey: Constants.passwordSaved)
            }
        }
    }
    
    // MARK: - Functions
    func removePasswordFromKeychain() {
        if KeychainWrapper.standard.removeAllKeys() {
            UserDefaults.appGroup?.removeObject(forKey: Constants.passwordSaved)
        }
    }
    
    func enableLoginPreference(_ preference: LoginPreference) {
        UserDefaults.appGroup?.set(preference.rawValue, forKey: Constants.loginPreference)
    }
    
    func disableLoginPreference() {
        UserDefaults.appGroup?.removeObject(forKey: Constants.loginPreference)
    }
    
    var firstLogin: Bool {
        return !(UserDefaults.appGroup?.bool(forKey: Constants.loginPreference) ?? false)
    }
    
    private var newManualSignIn: Bool {
        return !(UserDefaults.appGroup?.bool(forKey: Constants.passwordSaved) ?? false)
    }
}
