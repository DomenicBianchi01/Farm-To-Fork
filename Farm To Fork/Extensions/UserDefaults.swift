//
//  AppGroupUserDefaults.swift
//  Farm To Fork
//
//  Created by Domenic Bianchi on 2018-03-18.
//  Copyright © 2018 Domenic Bianchi & Marshall Asch. All rights reserved.
//

import Foundation

extension UserDefaults {
    /// A key-value database that is directly accessible by iOS and Siri. watchOS must send a message to the iOS app to fetch any data required from this database
    static let appGroup = UserDefaults(suiteName: "group.domenic.bianchi.FarmToFork.AppGroup")
    
    static func resetAppGroup() {
        if let dictionary = UserDefaults.appGroup?.dictionaryRepresentation() {
            dictionary.keys.forEach { key in
                UserDefaults.appGroup?.removeObject(forKey: key)
            }
        }
    }
}
