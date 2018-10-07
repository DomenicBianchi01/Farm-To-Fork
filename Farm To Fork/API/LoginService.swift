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
    func login(user: BasicUserDetails, with completion: @escaping (Result<User>) -> Void) {
        let body = ["Email" : user.email,
                    "pass" : user.password]
        
        let encodedBody = encode(body)
        
        request(from: "https://farmtofork.marshallasch.ca/api.php/2.0/user/login", requestType: .post, body: encodedBody, expecting: [String : JSONAny].self) { result in
            switch result {
            case .success(let result):
                guard let userDictionary = result["user"]?.value as? [String : Any],
                    let user = User(dictionary: userDictionary),
                    let token = result["accessToken"]?.value as? String else {
                        completion(.error(NSError(domain: "Invalid response", code: 0, userInfo: nil)))
                        return
                }
                if self.saveToken(token) {
                    completion(.success(user))
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
