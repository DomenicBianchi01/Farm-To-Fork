//
//  PledgeService.swift
//  Farm To Fork
//
//  Created by Domenic Bianchi on 2018-03-18.
//  Copyright © 2018 Domenic Bianchi & Marshall Asch. All rights reserved.
//

import Foundation

final class PledgeService: JSONService {
    func pledge(locationId: Int, needID: Int, quantity: Int, with completion: @escaping ((Result<Void>) -> Void)) {
        let body = ["needID" : needID, "quantity" : quantity]
        
        let encodedBody = encode(body)

        request(from: "https://farmtofork.marshallasch.ca/api.php/2.0/pledge/\(locationId)", requestType: .post, body: encodedBody) { result in
            completion(result)
        }
    }
}
