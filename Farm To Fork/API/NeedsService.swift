//
//  NeedsService.swift
//  Farm To Fork
//
//  Created by Domenic Bianchi on 2018-03-10.
//  Copyright © 2018 Domenic Bianchi & Marshall Asch. All rights reserved.
//

import Foundation

final class NeedsService: JSONService {
    func fetchNeeds(forLocation locationId: String, with completion: @escaping ((Result<[String]>) -> Void)) {
        
        request(from: "https://farmtofork.marshallasch.ca/api.php/2.0/needs/\(locationId)", expecting: [String : String].self) { result in
            switch result {
            case .success(let needs):
                //completion(.success(needs))
                break //TODO
            case .error(let error):
                completion(.error(error))
            }
        }
    }
}
