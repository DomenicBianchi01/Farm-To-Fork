//
//  NotificationExtensions.swift
//  Farm To Fork
//
//  Created by Domenic Bianchi on 2018-04-18.
//  Copyright © 2018 Domenic Bianchi. All rights reserved.
//

import Foundation

extension Notification.Name {
    static let locationsFetched = Notification.Name(rawValue: "com.domenic.bianchi.FarmToFork.locations.fetched")
    static let preferredLocationSet = Notification.Name(rawValue: "com.domenic.bianchi.FarmToFork.preferredLocation.set")
}

struct NotificationKeys {
    static let locations = "Locations"
}
