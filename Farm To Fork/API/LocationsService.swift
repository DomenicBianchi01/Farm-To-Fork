//
//  LocationsService.swift
//  Farm To Fork
//
//  Created by Domenic Bianchi on 2018-03-13.
//  Copyright © 2018 Domenic Bianchi & Marshall Asch. All rights reserved.
//

import UIKit

// Used by both the iOS and watchOS apps

final class LocationsService: JSONService {
    func fetchLocations(forCity cityId: String, generateCoordinates: Bool, with completion: @escaping ((Result<[Location]>) -> Void)) {
        request(from: "https://farmtofork.marshallasch.ca/api.php/2.0/EFP/city/\(cityId)", expecting: [String : JSONAny].self) { result in
            switch result {
            case .success(let efps):
                var locations: [Location] = []
                for location in efps {
                    guard let dictionary = location.value.value as? [String : Any],
                        let location = Location(id: location.key, dictionary: dictionary, generateCoordinates: generateCoordinates) else {
                        continue
                    }
                    locations.append(location)
                }
                completion(.success(locations))
            case .error(let error):
                completion(.error(error))
            }
        }
    }
}
