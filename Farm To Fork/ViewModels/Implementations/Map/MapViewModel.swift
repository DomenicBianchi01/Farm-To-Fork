//
//  MapViewModel.swift
//  Farm To Fork
//
//  Created by Domenic Bianchi on 2018-03-10.
//  Copyright © 2018 Domenic Bianchi & Marshall Asch. All rights reserved.
//

import Foundation

final class MapViewModel {
    // MARK: - Properties
    var locations: [Location] = []
    
    var isPreferredLocationSet: Bool {
        return UserDefaults.appGroup?.string(forKey: Constants.preferredLocationId) != nil ? true : false
    }
    
    // MARK: - Helper Functions
    func fetchEFPLocations(with completion: @escaping ((Result<Void>) -> Void)) {
        //TODO: DON'T HARDCODE CITY NUMBER
        LocationsService().fetchLocations(forCity: "150") { result in
            switch result {
            case .success(let locations):
                self.locations = locations
                completion(.success(()))
            case .error(let error):
                completion(.error(error))
            }
        }
    }
    
    func setPreferredLocation(_ location: Location) {
        UserDefaults.appGroup?.set(location.id, forKey: Constants.preferredLocationId)
        UserDefaults.appGroup?.set(location.name, forKey: Constants.preferredLocationName)
    }
}

// MARK: - PickerViewModelable
extension MapViewModel: PickerViewModelable {
    func numberOfRows(in component: Int) -> Int {
        return locations.count
    }
    
    var numberOfComponents: Int {
        return 1
    }
}
