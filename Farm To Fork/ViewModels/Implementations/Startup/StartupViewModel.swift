//
//  StartupViewModel.swift
//  Farm To Fork
//
//  Created by Domenic Bianchi on 2018-03-09.
//  Copyright © 2018 Domenic Bianchi & Marshall Asch. All rights reserved.
//

import Foundation
import SwiftKeychainWrapper

final class StartupViewModel {
    // MARK: - Computed Properties
    var authenticationMethod: LoginPreference? {
        return LoginPreference(rawValue: UserDefaults.standard.integer(forKey: Constants.loginPreference))
    }
}
