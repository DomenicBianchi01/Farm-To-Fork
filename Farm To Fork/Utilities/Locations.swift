//
//  Location.swift
//  Farm To Fork
//
//  Created by Domenic Bianchi on 2018-03-13.
//  Copyright © 2018 Domenic Bianchi & Marshall Asch. All rights reserved.
//

import Foundation

final class Location {
    // MARK: - Properties
    let id: String
    let name: String
    let hours: Hours
    let streetName: String
    let streetNumber: String
    let postalCode: String
    let cityName: String
    let email: String?
    let fax: String?
    let website: String?
    let phoneNumber: String?
    let contactName: String?
    let unitNumber: String?
    
    /// Provides the `streetNumber`, `streetName`, `unitNumber` (if applicable), `cityName`, and `postalCode` all within one string
    var fullAddress: String {
        if let unitNumber = unitNumber {
            return "\(streetNumber) \(streetName) Unit \(unitNumber) \(cityName) \(postalCode)"
        }
        return "\(streetNumber) \(streetName) \(cityName) \(postalCode)"
    }
    
    // MARK: - Structs
    struct Hours {
        let monday: String
        let tuesday: String
        let wednesday: String
        let thursday: String
        let friday: String
        let saturday: String
        let sunday: String
    }
    
    // MARK: - Lifecycle Functions
    init?(id: String,
          dictionary: [String : Any]) {
        guard let name = dictionary["EFPName"] as? String,
            let monday = dictionary["Monday"] as? String,
            let tuesday = dictionary["Tuesday"] as? String,
            let wednesday = dictionary["Wednesday"] as? String,
            let thursday = dictionary["Thursday"] as? String,
            let friday = dictionary["Friday"] as? String,
            let saturday = dictionary["Saturday"] as? String,
            let sunday = dictionary["Sunday"] as? String,
            let streetName = dictionary["StreetName"] as? String,
            let streetNumber = dictionary["StreetNumber"] as? String,
            let postalCode = dictionary["PostalCode"] as? String,
            let cityName = dictionary["CityName"] as? String else {
                return nil
        }
        
        self.id = id
        self.name = name
        self.hours = Hours(monday: monday, tuesday: tuesday, wednesday: wednesday, thursday: thursday, friday: friday, saturday: saturday, sunday: sunday)
        self.streetName = streetName
        self.streetNumber = streetNumber
        self.postalCode = postalCode
        self.cityName = cityName
        
        self.email = dictionary["Email"] as? String
        self.website = dictionary["Website"] as? String
        self.fax = dictionary["Fax"] as? String
        self.phoneNumber = dictionary["PhoneNumber"] as? String
        self.contactName = dictionary["ContactName"] as? String
        self.unitNumber = dictionary["UnitNumber"] as? String
    }
}
