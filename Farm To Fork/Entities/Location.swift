//
//  Location.swift
//  Farm To Fork
//
//  Created by Domenic Bianchi on 2018-03-13.
//  Copyright © 2018 Domenic Bianchi & Marshall Asch. All rights reserved.
//

import Foundation
import CoreLocation

class Location: Decodable {
    // MARK: - Properties
    let id: String
    let name: String
    let hours: Hours
    let streetName: String
    let streetNumber: String
    let postalCode: String
    let cityName: String
    let coordinates: CLLocationCoordinate2D
    let email: String?
    let fax: String?
    let website: String?
    let phoneNumber: String?
    let contactName: String?
    let unitNumber: String?
    /// Provides the `streetNumber`, `streetName`, `unitNumber` (if applicable), `cityName`, and `postalCode` all within one string
    let fullAddress: String
    /// Provides the `streetNumber`, `streetName`, and `unitNumber` (if applicable) on one line; then `cityName`, and `postalCode` on a second line
    let fullAddressWithNewlines: String
    
    /// The distance (in meters) between this location at the current position of the user. Not initialized at time of class instantiation.
    var distance: Double? = nil
    
    // MARK: - Structs
    struct Hours {
        let monday: String
        let tuesday: String
        let wednesday: String
        let thursday: String
        let friday: String
        let saturday: String
        let sunday: String
        
        let daysOfTheWeek = ["Monday", "Tuesday", "Wednesday", "Thursday", "Friday", "Saturday", "Sunday"]
        
        var hours: [String] {
            return [monday, tuesday, wednesday, thursday, friday, saturday, sunday]
        }
    }
    
    // MARK: - Enums
    private enum LocationKeys: String, CodingKey {
        case id = "EFPID"
        case name = "EFPName"
        case monday = "Monday"
        case tuesday = "Tuesday"
        case wednesday = "Wednesday"
        case thursday = "Thursday"
        case friday = "Friday"
        case saturday = "Saturday"
        case sunday = "Sunday"
        case streetName = "StreetName"
        case streetNumber = "StreetNumber"
        case postalCode = "PostalCode"
        case cityName = "CityName"
        case email = "Email"
        case fax = "Fax"
        case website = "Website"
        case phoneNumber = "PhoneNumber"
        case contactName = "ContactName"
        case unitNumber = "UnitNumber"
        case longitude = "Longitude"
        case latitude = "Latitude"
    }
    
    // MARK: - Lifecycle Functions
    init(id: String,
         name: String,
         hours: Hours,
         streetName: String,
         streetNumber: String,
         postalCode: String,
         cityName: String,
         email: String?,
         fax: String?,
         website: String?,
         phoneNumber: String?,
         contactName: String?,
         unitNumber: String?,
         coordinates: CLLocationCoordinate2D,
         fullAddress: String,
         fullAddressWithNewlines: String) {
        self.id = id
        self.name = name
        self.hours = hours
        self.streetName = streetName
        self.streetNumber = streetNumber
        self.postalCode = postalCode
        self.cityName = cityName
        self.email = email
        self.fax = fax
        self.website = website
        self.phoneNumber = phoneNumber
        self.contactName = contactName
        self.unitNumber = unitNumber
        self.coordinates = coordinates
        self.fullAddress = fullAddress
        self.fullAddressWithNewlines = fullAddressWithNewlines
    }

    /**
     Create a `Location` object using a dictionary.
     
     - parameter dictionary: Mandatory fields are: `EFPID`, `EFPName`, `Monday`, `Tuesday`, `Wednesday`, `Thursday`, `Friday`, `Saturday`, `Sunday`, `StreetName`, `StreetNumber`, `PostalCode`, `CityName`, `Latitude` and `Longitude`
    */
    convenience init?(dictionary: [String : Any]) {
        // Mandatory fields
        guard let id = dictionary[LocationKeys.id.rawValue] as? String,
            let name = dictionary[LocationKeys.name.rawValue] as? String,
            let monday = dictionary[LocationKeys.monday.rawValue] as? String,
            let tuesday = dictionary[LocationKeys.tuesday.rawValue] as? String,
            let wednesday = dictionary[LocationKeys.wednesday.rawValue] as? String,
            let thursday = dictionary[LocationKeys.thursday.rawValue] as? String,
            let friday = dictionary[LocationKeys.friday.rawValue] as? String,
            let saturday = dictionary[LocationKeys.saturday.rawValue] as? String,
            let sunday = dictionary[LocationKeys.sunday.rawValue] as? String,
            let streetName = dictionary[LocationKeys.streetName.rawValue] as? String,
            let streetNumber = dictionary[LocationKeys.streetNumber.rawValue] as? String,
            let postalCode = dictionary[LocationKeys.postalCode.rawValue] as? String,
            let cityName = dictionary[LocationKeys.cityName.rawValue] as? String,
            let latitude = dictionary[LocationKeys.latitude.rawValue] as? Double,
            let longitude = dictionary[LocationKeys.longitude.rawValue] as? Double else {
                return nil
        }
        
        let unitNumber = dictionary[LocationKeys.unitNumber.rawValue] as? String
        let fullAddress: String
        let fullAddressWithNewlines: String
        
        if let unitNumber = unitNumber {
            fullAddress = "\(streetNumber) \(streetName) Unit \(unitNumber) \(cityName) \(postalCode)"
            fullAddressWithNewlines = "\(streetNumber) \(streetName) Unit \(unitNumber)\n\(cityName) \(postalCode)"
        } else {
            fullAddress = "\(streetNumber) \(streetName) \(cityName) \(postalCode)"
            fullAddressWithNewlines = "\(streetNumber) \(streetName)\n\(cityName) \(postalCode)"
        }
        
        self.init(id: id,
                  name: name,
                  hours: Hours(monday: monday, tuesday: tuesday, wednesday: wednesday, thursday: thursday, friday: friday, saturday: saturday, sunday: sunday),
                  streetName: streetName,
                  streetNumber: streetNumber,
                  postalCode: postalCode,
                  cityName: cityName,
                  email: dictionary[LocationKeys.email.rawValue] as? String,
                  fax: dictionary[LocationKeys.fax.rawValue] as? String,
                  website: dictionary[LocationKeys.website.rawValue] as? String,
                  phoneNumber: dictionary[LocationKeys.phoneNumber.rawValue] as? String,
                  contactName: dictionary[LocationKeys.contactName.rawValue] as? String,
                  unitNumber: unitNumber,
                  coordinates: CLLocationCoordinate2D(latitude: latitude, longitude: longitude),
                  fullAddress: fullAddress,
                  fullAddressWithNewlines: fullAddressWithNewlines)
    }
    
    // MARK: - Decodable
    required convenience init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: LocationKeys.self)
        let id = try container.decode(String.self, forKey: .id)
        let name = try container.decode(String.self, forKey: .name)
        let monday = try container.decode(String.self, forKey: .monday)
        let tuesday = try container.decode(String.self, forKey: .tuesday)
        let wednesday = try container.decode(String.self, forKey: .wednesday)
        let thursday = try container.decode(String.self, forKey: .thursday)
        let friday = try container.decode(String.self, forKey: .friday)
        let saturday = try container.decode(String.self, forKey: .saturday)
        let sunday = try container.decode(String.self, forKey: .sunday)
        let streetName = try container.decode(String.self, forKey: .streetName)
        let streetNumber = try container.decode(String.self, forKey: .streetNumber)
        let postalCode = try container.decode(String.self, forKey: .postalCode)
        let cityName = try container.decode(String.self, forKey: .cityName)
        let longitude = try container.decode(String.self, forKey: .longitude)
        let latitude = try container.decode(String.self, forKey: .latitude)
        let email = try container.decodeIfPresent(String.self, forKey: .email)
        let fax = try container.decodeIfPresent(String.self, forKey: .fax)
        let website = try container.decodeIfPresent(String.self, forKey: .website)
        let phoneNumber = try container.decodeIfPresent(String.self, forKey: .phoneNumber)
        let contactName = try container.decodeIfPresent(String.self, forKey: .contactName)
        let unitNumber = try container.decodeIfPresent(String.self, forKey: .unitNumber)
        
        guard let latitudeDouble = Double(latitude), let longitudeDouble = Double(longitude) else {
            throw DecodingError.typeMismatch(Double.self, DecodingError.Context(codingPath: container.codingPath, debugDescription: "Cannot decode latitude and/or longitude"))
        }

        let fullAddress: String
        let fullAddressWithNewlines: String
        
        if let unitNumber = unitNumber {
            fullAddress = "\(streetNumber) \(streetName) Unit \(unitNumber) \(cityName) \(postalCode)"
            fullAddressWithNewlines = "\(streetNumber) \(streetName) Unit \(unitNumber)\n\(cityName) \(postalCode)"
        } else {
            fullAddress = "\(streetNumber) \(streetName) \(cityName) \(postalCode)"
            fullAddressWithNewlines = "\(streetNumber) \(streetName)\n\(cityName) \(postalCode)"
        }

        self.init(id: id,
                  name: name,
                  hours: Hours(monday: monday, tuesday: tuesday, wednesday: wednesday, thursday: thursday, friday: friday, saturday: saturday, sunday: sunday),
                  streetName: streetName,
                  streetNumber: streetNumber,
                  postalCode: postalCode,
                  cityName: cityName,
                  email: email,
                  fax: fax,
                  website: website,
                  phoneNumber: phoneNumber,
                  contactName: contactName,
                  unitNumber: unitNumber,
                  coordinates: CLLocationCoordinate2D(latitude: latitudeDouble, longitude: longitudeDouble),
                  fullAddress: fullAddress,
                  fullAddressWithNewlines: fullAddressWithNewlines)
    }
}
