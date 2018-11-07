//
//  UserService.swift
//  Farm To Fork
//
//  Created by Domenic Bianchi on 2018-03-08.
//  Copyright © 2018 Domenic Bianchi & Marshall Asch. All rights reserved.
//

import Foundation

final class UserService: JSONService {
	// MARK: - Properties
	private let locationUrlString = "https://farmtofork.marshallasch.ca/api.php/2.0/location/"
	private let loginUrlString = "https://farmtofork.marshallasch.ca/api.php/2.0/user/login"
	
    // MARK: - Functions
    func updateUserDetails(_ user: User, with completion: @escaping ((Result<User>) -> Void)) {
        
        let encodedBody = encode(user)
        
        request(from: "https://farmtofork.marshallasch.ca/api.php/2.0/user/update", requestType: .put, body: encodedBody, expecting: User.self) { result in
            completion(result)
        }
	}
    
    func updateUserPassword(for userId: Int, newPassword: String, with completion: @escaping ((Result<Void>) -> Void)) {
        request(from: "https://farmtofork.marshallasch.ca/api.php/2.0/user/update/password", requestType: .post) { result in
            completion(result)
        }
    }
}
