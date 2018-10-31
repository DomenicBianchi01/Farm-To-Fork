//
//  AuthenticationService.swift
//  Farm To Fork
//
//  Created by Domenic Bianchi on 2018-03-07.
//  Copyright © 2018 Domenic Bianchi & Marshall Asch. All rights reserved.
//

import Foundation

final class AuthenticationService: JSONService {
    /// Start a user session
    func login(user: BasicUserDetails, with completion: @escaping (Result<User>) -> Void) {
        let body = ["Email" : user.email,
                    "pass" : user.password]
        
        let encodedBody = encode(body)
        
        request(from: "https://farmtofork.marshallasch.ca/api.php/2.0/user/login", requestType: .post, body: encodedBody, expecting: User.self) { result in
            completion(result)
        }
    }
    
    /// End the user session
    func logout(with completion: @escaping (Result<Void>) -> Void) {
        request(from: "https://farmtofork.marshallasch.ca/api.php/2.0/user/logout", requestType: .post) { result in
            switch result {
            case .success:
                completion(.success(()))
            case .error(let error):
                completion(.error(error))
            }
        }
    }
}
