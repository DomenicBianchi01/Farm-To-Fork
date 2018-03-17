//
//  LoginService.swift
//  Farm To Fork
//
//  Created by Domenic Bianchi on 2018-03-07.
//  Copyright © 2018 Domenic Bianchi & Marshall Asch. All rights reserved.
//

import UIKit

final class LoginService: JSONService {
    func login(user: User, with completion: @escaping (Result<Void>) -> Void) {
        let body = ["Email" : user.email,
                    "pass" : user.password]
        
        request(from: "https://farmtofork.marshallasch.ca/api.php/2.0/user/login", requestType: .post, body: body, expecting: [String : String].self) { result in
            switch result {
            case .success:
                completion(.success(()))
            case .error(let error):
                completion(.error(error))
            }
        }
    }
}