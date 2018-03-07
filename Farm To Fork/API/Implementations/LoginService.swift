//
//  LoginService.swift
//  Farm To Fork
//
//  Created by Domenic Bianchi on 2018-03-07.
//  Copyright © 2018 Domenic Bianchi & Marshall Asch. All rights reserved.
//

import Foundation

struct LoginService {
    func login(user: User, with completion: @escaping (Result<Bool>) -> Void) {
        guard let url = URL(string: "https://farmtofork.marshallasch.ca/api.php/2.0/user/login") else {
            return
        }
        
        let body = ["Email" : user.username,
                    "pass" : user.password]
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        
        let httpBody = try? JSONSerialization.data(withJSONObject: body, options: .prettyPrinted)
        request.httpBody = httpBody
        
        URLSession.shared.dataTask(with: request) { (data, response, error) in
            guard let data = data else {
                completion(.error(NSError(domain: "Error getting response", code: 0, userInfo: nil)))
                return
            }
            do {
                let json = try JSONSerialization.jsonObject(with: data, options: []) as? [String: String]
                if let error = json?["error"] {
                    var responseStatusCode = 0
                    if let response = response as? HTTPURLResponse {
                        responseStatusCode = response.statusCode
                    }
                    completion(.error(NSError(domain: error, code: responseStatusCode, userInfo: nil)))
                }
            } catch {
                completion(.error(error))
            }
        }.resume()
    }
}
