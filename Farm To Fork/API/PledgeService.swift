//
//  PledgeService.swift
//  Farm To Fork
//
//  Created by Domenic Bianchi on 2018-03-18.
//  Copyright © 2018 Domenic Bianchi & Marshall Asch. All rights reserved.
//

import Foundation

final class PledgeService: JSONService {
    func pledge(needID: Int, quantity: Int, with completion: @escaping ((Result<Void>) -> Void)) {
        let body = ["needID" : needID, "quantity" : quantity]

        request(from: "https://farmtofork.marshallasch.ca/api.php/2.0/pledge", requestType: .post, body: body, expecting: [String : String].self) { result in
            switch result {
            case .success(let result):
                completion(.success(()))
            case .error(let error):
                completion(.error(error))
            }
        }
    }
}
