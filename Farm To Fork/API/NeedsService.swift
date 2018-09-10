//
//  NeedsService.swift
//  Farm To Fork
//
//  Created by Domenic Bianchi on 2018-03-10.
//  Copyright © 2018 Domenic Bianchi & Marshall Asch. All rights reserved.
//

import Foundation

// Used by both the iOS and watchOS apps

final class NeedsService: JSONService {

    func fetchNeeds(forLocation locationId: String, with completion: @escaping ((Result<[Need]>) -> Void)) {
        request(from: "https://farmtofork.marshallasch.ca/api.php/2.0/needs/\(locationId)/all", expecting: [Need].self) { result in
            completion(result)
        }
    }
}
