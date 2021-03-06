//
//  Constants.swift
//  Farm To Fork
//
//  Created by Domenic Bianchi on 2018-03-09.
//  Copyright © 2018 Domenic Bianchi & Marshall Asch. All rights reserved.
//

import Foundation

struct Constants {
    static let passwordSaved = "PasswordSaved"
    static let password = "password"
    static let username = "username"
    static let loginPreference = "LoginPreference"
    static let preferredLocationId = "PreferredLocationID" //MAYBE TODO: Remove preferredLocationId and preferredLocationName and store the entire Location object in UserDefaults
    static let preferredLocationName = "PreferredLocationName" //MAYBE TODO: Remove preferredLocationId and preferredLocationName and store the entire Location object in UserDefaults
    static let setPreferredLocationId = "setPreferredLocationID"
    static let setPreferredLocationName = "setPreferredLocationName"
    static let error = "Error"
    static let siriShortcutsIdentifier = "com.domenic.bianchi.FarmToFork.siriShortcut"
    
    struct Segues {
        static let loginStart = "LoginStart"
        static let autoLoginStart = "AutoLoginStart"
        static let needsView = "NeedsView"
        static let viewLocations = "viewLocationsSegue"
        static let emailAddress = "emailAddressSegue"
        static let accountInfo = "accountInfoSegue"
        static let registerNextStep = "registerNextStep"
        static let modifyNeed = "modifyNeedSegue"
        static let pledgeHistory = "pledgeHistorySegue"
        static let loginToMap = "goToMapFromLogin"
    }
}
