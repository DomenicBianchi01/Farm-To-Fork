//
//  AccountLastNameViewModel.swift
//  Farm To Fork
//
//  Created by Domenic Bianchi on 2018-10-30.
//  Copyright © 2018 Domenic Bianchi. All rights reserved.
//

import Foundation

final class AccountLastNameViewModel {
    // MARK: - Properties
    private var lastName: String? = nil
    
    // MARK: - Lifecycle Functions
    init(lastName: String? = nil) {
        self.lastName = lastName
    }
}

// MARK: - CellViewModelable
extension AccountLastNameViewModel: CellViewModelable {
    var title: String? {
        return lastName
    }
    
    var description: String? {
        return "Last Name"
    }
    
    var identifier: String {
        return User.Keys.lastName.rawValue
    }
    
    func updateViewModel(with data: Any) {
        lastName = data as? String
    }
}
