//
//  WatchNeedsViewModel.swift
//  Farm To Fork For Apple Watch Extension
//
//  Created by Domenic Bianchi on 2018-03-21.
//  Copyright © 2018 Domenic Bianchi & Marshall Asch. All rights reserved.
//

import Foundation

final class WatchNeedsViewModel {
    // MARK: - Properties
    private(set) var needs: [Need] = []
    private(set) var locations: [Location] = []
    
    // MARK: - Helper Functions
    func fetchData(with completion: @escaping ((Result<Void>) -> Void)) {
        WatchSessionManager.shared.sendMessage(with: [Constants.preferredLocationId : "getValue"]) { result in
            switch result {
            case .success(let response):
                if let error = response[Constants.error] as? String {
                    completion(.error(NSError(domain: error, code: 0, userInfo: nil)))
                    return
                }
                guard let preferredLocationId = response[Constants.preferredLocationId] as? String else {
                    //TODO: Don't hardcode city id!
                    self.executeLocationsAPICall(forCity: "150", with: completion)
                    return
                }
                self.executeNeedsAPICall(forLocation: preferredLocationId, with: completion)
            case .error(let error):
                completion(.error(error))
            }
        }
    }

    func setPreferredLocation(id: String, with completion: @escaping ((Result<Void>) -> Void)) {
        WatchSessionManager.shared.sendMessage(with: [Constants.setPreferredLocationId : id]) { result in
            completion(.success(()))
        }
    }
    
    private func executeNeedsAPICall(forLocation locationId: String, with completion: @escaping ((Result<Void>) -> Void)) {
        NeedsService().fetchNeeds(forLocation: locationId) { result in
            switch result {
            case .success(let needs):
                self.needs = needs
                completion(.success(()))
            case .error(let error):
                completion(.error(error))
            }
        }
    }
    
    private func executeLocationsAPICall(forCity cityId: String, with completion: @escaping ((Result<Void>) -> Void)) {
        LocationsService().fetchLocations(forCity: cityId) { result in
            switch result {
            case .success(let locations):
                self.locations = locations
                completion(.success(()))
            case .error(let error):
                completion(.error(error))
            }
        }
    }
}

// MARK: - WatchTableViewModelable
extension WatchNeedsViewModel: WatchTableViewModelable {
    var numberOfRows: Int {
        return needs.count
    }
    
    func rowType(for row: Int) -> String { /* Not used */ return "" }
}
