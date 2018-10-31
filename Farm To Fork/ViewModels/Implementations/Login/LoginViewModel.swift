//
//  LoginViewModel.swift
//  Farm To Fork
//
//  Created by Domenic Bianchi on 2018-03-06.
//  Copyright © 2018 Domenic Bianchi & Marshall Asch. All rights reserved.
//

import Foundation
import Valet

final class LoginViewModel {
    // MARK: - Properties
    private var user = BasicUserDetails()
    
    // MARK: - Helper Functions
    func attemptLogin(with completion: @escaping (Result<User>) -> Void) {
        AuthenticationService().login(user: user) { result in
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
            if Valet.F2FValet.set(string: user.password, forKey: Constants.password) && Valet.F2FValet.set(string: user.email, forKey: Constants.username) {
                UserDefaults.appGroup?.set(true, forKey: Constants.passwordSaved)
            }
        }
    }
    
    // MARK: - Functions
    func removePasswordFromKeychain() {
        //TODO: Shouldn't I just be removing username/password?
        if Valet.F2FValet.removeAllObjects() {
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
