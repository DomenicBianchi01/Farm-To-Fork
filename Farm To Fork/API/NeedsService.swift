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

    // MARK: - Fetching Functions
    func fetchNeeds(forLocation locationId: Int, disabledNeeds: Bool = false, with completion: @escaping ((Result<[Need]>) -> Void)) {
        request(from: "https://farmtofork.marshallasch.ca/api.php/2.0/needs/\(locationId)/all?disabled=\(disabledNeeds)", expecting: [Need].self) { result in
            completion(result)
        }
    }
    
    func fetchUnits(with completion: @escaping ((Result<[Units]>) -> Void)) {
        request(from: "https://farmtofork.marshallasch.ca/api.php/2.0/units", expecting: [Units].self) { result in
            completion(result)
        }
    }

    func fetchCategories(with completion: @escaping ((Result<[Category]>) -> Void)) {
        request(from: "https://farmtofork.marshallasch.ca/api.php/2.0/categories", expecting: [Category].self) { result in
            completion(result)
        }
    }
    
    
    // MARK: - Updating Functions
    /// Function not available on watchOS since it is not possible to actually create or modify needs through the watch (a user can't type out the name and description of the need) and from a UX point of view it doesn't make much sense that it even should
    @available(watchOS, unavailable)
    func modify(need: Need, forLocation locationId: String, requestType: RequestType, with completion: @escaping ((Result<Void>) -> Void)) {
        
        let body = encode(need)
        
        request(from: "https://farmtofork.marshallasch.ca/api.php/2.0/needs/\(locationId)", requestType: requestType, body: body) { result in
            completion(result)
        }
    }
    
    @available(watchOS, unavailable)
    func delete(needId: Int, forLocation locationId: String, with completion: @escaping ((Result<Void>) -> Void)) {
        
        let body = encode(["NeedID" : needId])
        
        request(from: "https://farmtofork.marshallasch.ca/api.php/2.0/needs/\(locationId)", requestType: .delete, body: body) { result in
            completion(result)
        }
    }
}
