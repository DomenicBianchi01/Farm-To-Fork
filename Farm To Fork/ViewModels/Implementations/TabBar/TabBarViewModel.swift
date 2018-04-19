//
//  TabBarViewModel.swift
//  Farm To Fork
//
//  Created by Domenic Bianchi on 2018-04-18.
//  Copyright © 2018 Domenic Bianchi. All rights reserved.
//

import Foundation

final class TabBarViewModel {
    // MARK: - Properties
    var locations: [Location] = []
    
    var isPreferredLocationSet: Bool {
        return UserDefaults.appGroup?.string(forKey: Constants.preferredLocationId) != nil ? true : false
    }
    
    // MARK: - Helper Functions
    func setPreferredLocation(_ location: Location) {
        UserDefaults.appGroup?.set(location.id, forKey: Constants.preferredLocationId)
        UserDefaults.appGroup?.set(location.name, forKey: Constants.preferredLocationName)
    }
}

// MARK: - PickerViewModelable
extension TabBarViewModel: PickerViewModelable {
    func numberOfRows(in component: Int) -> Int {
        return locations.count
    }
    
    var numberOfComponents: Int {
        return 1
    }
}
