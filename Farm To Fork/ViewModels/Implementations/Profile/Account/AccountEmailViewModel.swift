//
//  AccountEmailViewModel.swift
//  Farm To Fork
//
//  Created by Domenic Bianchi on 2018-10-30.
//  Copyright © 2018 Domenic Bianchi. All rights reserved.
//

import Foundation

final class AccountEmailViewModel {
    // MARK: - Properties
    private var email: String? = nil
    
    // MARK: - Lifecycle Functions
    init(email: String? = nil) {
        self.email = email
    }
}

// MARK: - CellViewModelable
extension AccountEmailViewModel: CellViewModelable {
    var title: String? {
        return email
    }
    
    var description: String? {
        return "Email"
    }
    
    var identifier: String {
        return User.Keys.email.rawValue
    }
    
    func updateViewModel(with data: Any) {
        email = data as? String
    }
}
