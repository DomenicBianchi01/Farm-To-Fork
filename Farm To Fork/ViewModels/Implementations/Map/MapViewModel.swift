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
    var locations: [String] = ["Loading..."] //TODO: Maybe make an actual Location object??
    
    var isPreferredLocationSet: Bool {
        return UserDefaults.standard.string(forKey: Constants.preferredLocationId) != nil ? true : false
    }
    
    // MARK: - Helper Functions
    func fetchEFPLocations() {
        
    }
}
