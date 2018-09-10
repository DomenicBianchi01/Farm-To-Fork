//
//  LocationsService.swift
//  Farm To Fork
//
//  Created by Domenic Bianchi on 2018-03-13.
//  Copyright © 2018 Domenic Bianchi & Marshall Asch. All rights reserved.
//

import Foundation

// Used by both the iOS and watchOS apps

final class LocationsService: JSONService {
    func fetchLocations(forCity cityId: String, with completion: @escaping ((Result<[Location]>) -> Void)) {
        request(from: "https://farmtofork.marshallasch.ca/api.php/2.0/EFP/city/\(cityId)", expecting: [Location].self) { result in
            completion(result)
        }
    }
}
