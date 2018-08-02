//
//  Location.swift
//  Farm To Fork
//
//  Created by Domenic Bianchi on 2018-03-13.
//  Copyright © 2018 Domenic Bianchi & Marshall Asch. All rights reserved.
//

import Foundation
import CoreLocation

class Location {
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
    let fullAddress: String
    /// Provides the `streetNumber`, `streetName`, and `unitNumber` (if applicable) on one line; then `cityName`, and `postalCode` on a second line
    let fullAddressWithNewlines: String
    
    /**
     Coordinates for the location. On iOS applications, if coordinates are not included within the `dictionary` in the intializer, an attempt to generate coordinates will be made (based on `fullAddress`).
     
     WatchOS Note: If the `dictionary` provided in the initializer does not contain coordinates, coordinates will not be generated.
     */
    private(set) var coordinates: CLLocationCoordinate2D? = nil
    
    /// The distance (in meters) between this location at the current position of the user
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
        
        if let unitNumber = unitNumber {
            self.fullAddress = "\(streetNumber) \(streetName) Unit \(unitNumber) \(cityName) \(postalCode)"
            self.fullAddressWithNewlines = "\(streetNumber) \(streetName) Unit \(unitNumber)\n\(cityName) \(postalCode)"
        } else {
            self.fullAddress = "\(streetNumber) \(streetName) \(cityName) \(postalCode)"
            self.fullAddressWithNewlines = "\(streetNumber) \(streetName)\n\(cityName) \(postalCode)"
        }
        
        if let latitude = dictionary["latitude"] as? Double, let longitude = dictionary["longitude"] as? Double {
            self.coordinates = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
        } else {
            #if os(iOS)
            let dispatchGroup = DispatchGroup()
            dispatchGroup.enter()
            convertAddressToCoordinates(self.fullAddress) { result in
                switch result {
                case .success(let coordinates):
                    self.coordinates = coordinates
                    dispatchGroup.leave()
                case .error:
                    dispatchGroup.leave()
                }
            }
            dispatchGroup.wait()
            #endif
        }
        
        if coordinates == nil {
            return nil
        }
    }
    
    /**
     Given a address (street number, name, postal code, etc), attempt to generate coordinates.
     
     This function is only available on iOS applications. Calling this function from a watchOS application would cause the `CLGeocoder` to either hang (resulting in the completion block never being called) or return an error.
     
     - parameter address: The address of the location trying to convert into coordinates. The more details included, the higher chance of generating accurate coordinates.
     */
    @available(watchOS, unavailable)
    private func convertAddressToCoordinates(_ address: String, with completion: @escaping ((Result<CLLocationCoordinate2D>) -> Void)) {
        let geoCoder = CLGeocoder()
        geoCoder.geocodeAddressString(address) { (placemarks, error) in
            guard let placemarks = placemarks, let location = placemarks.first?.location?.coordinate else {
                completion(.error(error ?? NSError(domain: "Could not generate coordinates", code: 0, userInfo: nil)))
                return
            }
            completion(.success(location))
        }
    }
}
