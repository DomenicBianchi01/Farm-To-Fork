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
    // MARK: - Functions
    func removeSavedCredentials() {
        if KeychainWrapper.standard.removeAllKeys() {
            UserDefaults.standard.removeObject(forKey: Constants.passwordSaved)
        }
    }
}
