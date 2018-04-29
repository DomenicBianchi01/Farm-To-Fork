//
//  StartupViewModel.swift
//  Farm To Fork
//
//  Created by Domenic Bianchi on 2018-03-09.
//  Copyright © 2018 Domenic Bianchi & Marshall Asch. All rights reserved.
//

import Foundation

final class StartupViewModel {
    // MARK: - Computed Properties
    /// Returns the login preference that the user prefers.
    var authenticationMethod: LoginPreference? {
        return LoginPreference(rawValue: UserDefaults.appGroup?.integer(forKey: Constants.loginPreference) ?? 0)
    }
}
