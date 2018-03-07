//
//  LoginViewModel.swift
//  Farm To Fork
//
//  Created by Domenic Bianchi on 2018-03-06.
//  Copyright © 2018 Domenic Bianchi & Marshall Asch. All rights reserved.
//

import Foundation

final class LoginViewModel {
    // MARK: - Properties
    private var user = User()
    
    // MARK: - Helper Functions
    func attemptLogin(with completion: @escaping (Result<Bool>) -> Void) {
        LoginService().login(user: user) { result in
            completion(result)
        }
    }
    
    func updateUsername(username: String) {
        user.username = username
    }
    
    func updatePassword(password: String) {
        user.password = password
    }
}
