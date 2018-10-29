//
//  PledgeService.swift
//  Farm To Fork
//
//  Created by Domenic Bianchi on 2018-03-18.
//  Copyright © 2018 Domenic Bianchi & Marshall Asch. All rights reserved.
//

import Foundation

final class PledgeService: JSONService {

    func pledge(_ pledge: Pledge, with completion: @escaping ((Result<Void>) -> Void)) {
        
        let encodedBody = encode(pledge)
        
        //TODO: Use JWT or other auth so other uses cant pledge for other users

        request(from: "https://farmtofork.marshallasch.ca/api.php/2.0/pledges", requestType: .post, body: encodedBody) { result in
            completion(result)
        }
    }
    
    func pledges(by userId: Int, at locationId: Int, with completion: @escaping ((Result<[Pledge]>) -> Void)) {
        //TODO: Use JWT?
        request(from: "https://farmtofork.marshallasch.ca/api.php/2.0/pledges/\(locationId)?userId=\(userId)", expecting: [Pledge].self) { result in
            completion(result)
        }
    }
    
    func pledges(by userId: Int, dayRange range: Int?, with completion: @escaping ((Result<[PledgeHistory]>) -> Void)) {
        //TODO: Use JWT?
        var url = "https://farmtofork.marshallasch.ca/api.php/2.0/pledges?userId=\(userId)"
        
        if let range = range {
            url += "&dayRange=\(range)"
        }

        request(from: url, expecting: [PledgeHistory].self) { result in
            completion(result)
        }
    }
}
