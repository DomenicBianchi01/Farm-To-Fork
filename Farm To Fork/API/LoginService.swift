//
//  LoginService.swift
//  Farm To Fork
//
//  Created by Domenic Bianchi on 2018-03-07.
//  Copyright © 2018 Domenic Bianchi & Marshall Asch. All rights reserved.
//

import Foundation
import Valet

final class LoginService: JSONService {
    func login(user: User, with completion: @escaping (Result<Void>) -> Void) {
        let body = ["Email" : user.email,
                    "pass" : user.password]
        
        request(from: "https://farmtofork.marshallasch.ca/api.php/2.0/user/login", requestType: .post, body: body, expecting: [String : String].self) { result in
            switch result {
            case .success(let result):
                completion(.success(()))
                return //Token auth not yet implemented on backend
                guard let token = result["token"] else {
                    completion(.error(NSError(domain: "No access token returned in response", code: 0, userInfo: nil)))
                    return
                }
                if self.saveToken(token) {
                    completion(.success(()))
                } else {
                    completion(.error(NSError(domain: "Could not save token", code: 0, userInfo: nil)))
                }
            case .error(let error):
                completion(.error(error))
            }
        }
    }
    
    // MARK: - Private Helper Functions
    private func saveToken(_ token: String) -> Bool {
        return Valet.F2FValet.set(string: token, forKey: Constants.token)
    }
}
