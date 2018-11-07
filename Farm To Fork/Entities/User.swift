//
//  User.swift
//  Farm To Fork
//
//  Created by Domenic Bianchi on 2018-03-06.
//  Copyright © 2018 Domenic Bianchi & Marshall Asch. All rights reserved.
//

import Foundation

class User: Codable {
    // MARK: - Properties
    let id: Int
    let cityId: Int
    let streetName: String
    let streetNumber: String //Might be possible to have a number like 26A
    let unitNumber: String?
    let postalCode: String
    let email: String
    let firstName: String
    let lastName: String
    let newsletterDay: Int?
    /// If not nil, this property indicates that the user is a worker the specified EFP location id. If nil, the user is not a worker at any locations in the Farm To Fork system
    let workerLocationId: Int?
    
    // MARK: - Enums
    enum Keys: String, CodingKey {
        case id = "UserID"
        case cityId = "CityID"
        case streetName = "StreetName"
        case streetNumber = "StreetNumber"
        case unitNumber = "UnitNumber"
        case postalCode = "PostalCode"
        case email = "Email"
        case firstName = "FirstName"
        case lastName = "LastName"
        case newsletterDay = "NewsletterDay"
        case workerLocationId = "EFPWorkerID"
    }
    
    // MARK: - Lifecycle Function
    init(id: Int,
         cityId: Int,
         streetName: String,
         streetNumber: String,
         unitNumber: String? = nil,
         postalCode: String,
         email: String,
         firstName: String,
         lastName: String,
         newsletterDay: Int? = nil,
         workerLocationId: Int? = nil) {
        
        self.id = id
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
    }
    
    /**
     Create a `User` object using a dictionary.
     */
    convenience init?(dictionary: [String : Any]) {
        guard let id = Int(dictionary["UserID"] as? String ?? ""),
            let cityId = Int(dictionary["CityID"] as? String ?? ""),
            let streetName = dictionary["StreetName"] as? String,
            let streetNumber = dictionary["StreetNumber"] as? String,
            let postalCode = dictionary["PostalCode"] as? String,
            let email = dictionary["Email"] as? String,
            let firstName = dictionary["FirstName"] as? String,
            let lastName = dictionary["LastName"] as? String else {
                return nil
        }
        
        self.init(id: id,
                  cityId: cityId,
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
    
    /// NOTE: ONLY use this initializer when modifying a user (editing email, first name, last name, and/or newsletter day)
    convenience init?(encodingDictionary dictionary: [String : Any]) {
        guard let email = dictionary[User.Keys.email.rawValue] as? String,
            let firstName = dictionary[User.Keys.firstName.rawValue] as? String,
            let lastName = dictionary[User.Keys.lastName.rawValue] as? String else {
                return nil
        }
        
        // The backend currently only supports updating email, first name, last name, and newsletter day. Therefore, all the other properties do not matter for encoding
        self.init(id: 0,
                  cityId: 0,
                  streetName: "",
                  streetNumber: "",
                  postalCode: "",
                  email: email,
                  firstName: firstName,
                  lastName: lastName,
                  newsletterDay: dictionary[User.Keys.newsletterDay.rawValue] as? Int)
    }
    
    // MARK: - Decodable
    required convenience init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: Keys.self)
        let id = try container.decode(String.self, forKey: .id)
        let cityId = try container.decode(String.self, forKey: .cityId)
        let streetName = try container.decode(String.self, forKey: .streetName)
        let streetNumber = try container.decode(String.self, forKey: .streetNumber)
        let unitNumber = try container.decodeIfPresent(String.self, forKey: .unitNumber)
        let postalCode = try container.decode(String.self, forKey: .postalCode)
        let email = try container.decode(String.self, forKey: .email)
        let firstName = try container.decode(String.self, forKey: .firstName)
        let lastName = try container.decode(String.self, forKey: .lastName)
        let newsletterDay = try container.decodeIfPresent(String.self, forKey: .newsletterDay)
        let workerLocationId = try container.decodeIfPresent(String.self, forKey: .workerLocationId)
        
        guard let idInt = Int(id),
            let cityIdInt = Int(cityId) else {
            throw DecodingError.typeMismatch(Double.self, DecodingError.Context(codingPath: container.codingPath, debugDescription: "Cannot decode user object"))
        }
        
        self.init(id: idInt,
                  cityId: cityIdInt,
                  streetName: streetName,
                  streetNumber: streetNumber,
                  unitNumber: unitNumber,
                  postalCode: postalCode,
                  email: email,
                  firstName: firstName,
                  lastName: lastName,
                  newsletterDay: Int(newsletterDay ?? ""),
                  workerLocationId: Int(workerLocationId ?? ""))
    }
    
    // MARK: - Encodable
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: Keys.self)

        try container.encode(email, forKey: .email)
        try container.encode(firstName, forKey: .firstName)
        try container.encode(lastName, forKey: .lastName)
        try container.encode(newsletterDay, forKey: .newsletterDay)
    
//        try container.encode(streetName, forKey: .streetName)
//        try container.encode(streetNumber, forKey: .streetNumber)
//        try container.encodeIfPresent(unitNumber, forKey: .unitNumber)
//        try container.encode(postalCode, forKey: .postalCode)
    }
}
