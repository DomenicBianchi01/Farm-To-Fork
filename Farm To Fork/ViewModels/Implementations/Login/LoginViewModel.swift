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
    var email: String = ""
    var password: String = ""
    
    // MARK: - Helper Functions
    func attemptLogin(with completion: @escaping (Result<User>) -> Void) {
        AuthenticationService().login(email: email, password: password) { result in
            completion(result)
        }
    }
    
    func savePasswordToKeychain() {
        if newManualSignIn {
            if Valet.F2FValet.set(string: password, forKey: Constants.password) && Valet.F2FValet.set(string: email, forKey: Constants.username) {
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
