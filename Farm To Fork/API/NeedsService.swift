//
//  NeedsService.swift
//  Farm To Fork
//
//  Created by Domenic Bianchi on 2018-03-10.
//  Copyright © 2018 Domenic Bianchi & Marshall Asch. All rights reserved.
//

import Foundation

final class NeedsService: JSONService {
    func fetchNeeds(forLocation locationId: String, with completion: @escaping ((Result<[Need]>) -> Void)) {
        
        request(from: "https://farmtofork.marshallasch.ca/api.php/2.0/needs/\(locationId)/all", expecting: [String : JSONAny].self) { result in
            switch result {
            case .success(let needDictionary):
                var needs: [Need] = []
                for need in needDictionary {
                    guard let dictionary = need.value.value as? [String : String],
                        let needObject = Need(dictionary: dictionary) else {
                        continue
                    }
                    needs.append(needObject)
                }
                completion(.success(needs))
            case .error(let error):
                completion(.error(error))
            }
        }
    }
}
