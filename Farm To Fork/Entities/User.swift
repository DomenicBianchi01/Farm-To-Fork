//
//  User.swift
//  Farm To Fork
//
//  Created by Domenic Bianchi on 2018-03-06.
//  Copyright © 2018 Domenic Bianchi & Marshall Asch. All rights reserved.
//

import Foundation

class User {
    // MARK: - Properties
    let cityId: Int
    let streetName: String
    let streetNumber: String //Might be possible to have a number like 26A
    let unitNumber: String?
    let postalCode: String
    let email: String
    let firstName: String
    let lastName: String
    let newsletterDay: Int? //TODO: Should this be int or string
    /// If not nil, this property indicates that the user is a worker the specified EFP location id. If nil, the user is not a worker at any locations in the Farm To Fork system
    let workerLocationId: Int?
    /// Rather than checking if `workerLocationId` is nil, this boolean property can be used.
    let isAdmin: Bool
    
    // MARK: - Lifecycle Function
    init(cityId: Int,
         streetName: String,
         streetNumber: String,
         unitNumber: String? = nil,
         postalCode: String,
         email: String,
         firstName: String,
         lastName: String,
         newsletterDay: Int? = nil,
         workerLocationId: Int? = nil) {
        
        self.cityId = cityId
        self.streetName = streetName
        self.streetNumber = streetNumber
        self.unitNumber = unitNumber
        self.postalCode = postalCode
        self.email = email
        self.firstName = firstName
        self.lastName = lastName
        self.newsletterDay = newsletterDay
        self.workerLocationId = workerLocationId
        self.isAdmin = workerLocationId != nil
    }
    
    /**
     Create a `User` object using a dictionary.
     */
    convenience init?(dictionary: [String : Any]) {
        guard let cityId = Int(dictionary["CityID"] as? String ?? ""),
            let streetName = dictionary["StreetName"] as? String,
            let streetNumber = dictionary["StreetNumber"] as? String,
            let postalCode = dictionary["PostalCode"] as? String,
            let email = dictionary["Email"] as? String,
            let firstName = dictionary["FirstName"] as? String,
            let lastName = dictionary["LastName"] as? String else {
                return nil
        }
        
        self.init(cityId: cityId,
                  streetName: streetName,
                  streetNumber: streetNumber,
                  unitNumber: dictionary["UnitNumber"] as? String,
                  postalCode: postalCode,
                  email: email,
                  firstName: firstName,
                  lastName: lastName,
                  newsletterDay: dictionary["NewsletterDay"] as? Int,
                  workerLocationId: Int(dictionary["EFPWorkerID"] as? String ?? ""))
    }
}
