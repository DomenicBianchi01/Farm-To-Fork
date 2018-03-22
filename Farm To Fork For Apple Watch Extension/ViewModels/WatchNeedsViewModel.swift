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
    
    // MARK: - Helper Functions
    func fetchNeeds(with completion: @escaping ((Result<Void>) -> Void)) {
        WatchSessionManager.shared.sendMessage { result in
            switch result {
            case .success(let response):
                guard let preferredLocationId = response[Constants.preferredLocationId] as? String else {
                    completion(.error(NSError(domain: "No preferred location found.", code: 0, userInfo: nil)))
                    return
                }
                self.executeNeedsAPICall(forLocation: preferredLocationId, with: completion)
            case .error:
                break
            }
        }
    }
    
    func need(at index: Int) -> Need {
        return needs[index]
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
}

// MARK: - WatchTableViewModelable
extension WatchNeedsViewModel: WatchTableViewModelable {
    var numberOfRows: Int {
        return needs.count
    }
    
    func rowType(for row: Int) -> String { /* Not used */ return "" }
}
