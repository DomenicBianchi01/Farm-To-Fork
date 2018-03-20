//
//  User.swift
//  Farm To Fork
//
//  Created by Domenic Bianchi on 2018-03-06.
//  Copyright © 2018 Domenic Bianchi & Marshall Asch. All rights reserved.
//

import Foundation

struct User {
    // MARK: - Properties
    var firstName: String
    var lastName: String
    var email: String
    var password: String
    var country: (key: String, value: String)
    var province: (key: String, value: String)
    var city: (key: String, value: String)
    
    // MARK: - Lifecycle Functions
    init(firstName: String = "",
         lastName: String = "",
         email: String = "",
         password: String = "",
         country: (key: String, value: String) = (key: "", value: ""),
         province: (key: String, value: String) = (key: "", value: ""),
         city: (key: String, value: String) = (key: "", value: "")) {
        self.firstName = firstName
        self.lastName = lastName
        self.email = email
        self.password = password
        self.country = country
        self.province = province
        self.city = city
    }
	
	
	// MARK: - Lifecycle Functions
	init?(dictionary: [String : String]) {
		guard let firstName = dictionary["FirstName"],
			let lastName = dictionary["LastName"],
			let email = dictionary["Email"],
			let city = dictionary["CityID"]
		else {
				return nil
		}
		self.firstName = firstName
		self.lastName = lastName
		self.email = email
		self.password = "*********"
		self.country = (key: "", value: "")
		self.province = (key: "", value: "")
		self.city = (key: city, value: "")
	}
}
