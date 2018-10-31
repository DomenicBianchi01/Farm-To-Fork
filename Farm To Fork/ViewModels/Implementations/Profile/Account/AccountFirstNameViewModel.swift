//
//  AccountFirstNameViewModel.swift
//  Farm To Fork
//
//  Created by Domenic Bianchi on 2018-10-30.
//  Copyright © 2018 Domenic Bianchi. All rights reserved.
//

import Foundation

final class AccountFirstNameViewModel {
    // MARK: - Properties
    private var firstName: String? = nil
    
    // MARK: - Lifecycle Functions
    init(firstName: String? = nil) {
        self.firstName = firstName
    }
}

// MARK: - CellViewModelable
extension AccountFirstNameViewModel: CellViewModelable {
    var title: String? {
        return firstName
    }
    
    var description: String? {
        return "First Name"
    }
    
    var identifier: String {
        return User.Keys.firstName.rawValue
    }
    
    func updateViewModel(with data: Any) {
        firstName = data as? String
    }
}
