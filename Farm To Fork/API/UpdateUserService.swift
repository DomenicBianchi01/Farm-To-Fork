//
//  RegisterService.swift
//  Farm To Fork
//
//  Created by Domenic Bianchi on 2018-03-08.
//  Copyright © 2018 Domenic Bianchi & Marshall Asch. All rights reserved.
//

import Foundation

final class UpdateUserService: JSONService {
	// MARK: - Properties
	private let locationUrlString = "https://farmtofork.marshallasch.ca/api.php/2.0/location/"
	private let userUrlString = "https://farmtofork.marshallasch.ca/api.php/2.0/user"
	private let userUpdateUrlString = "https://farmtofork.marshallasch.ca/api.php/2.0/user/update"
	private let loginUrlString = "https://farmtofork.marshallasch.ca/api.php/2.0/user/login"
	
	// MARK: - Functions
	
	/**
	 * Need to update the password field in the caller.
	 * Will not set the country or provice or the city name
	 */
	func fetchUserData(email: String, pass: String, with completion: @escaping ((Result<User>) -> Void)) {
	
		let loginUser = User(email: email, password: pass)


		LoginService().login(user: loginUser) { result in
			switch result {
			case .success:
				NSLog("logged in success")
				self.request(from: self.userUrlString, expecting: [String : String].self) { result in
					switch result {
					case .success(let userDictionary):
						NSLog("get info in success")
						let userObject = User(dictionary: userDictionary)!
						
						completion(.success(userObject))
					case .error(let error):
						NSLog("get info in error")

						completion(.error(error))
					}
				}
			case .error(let error):
				NSLog("logged in Failed")
				completion(.error(error))
				
			}
		}
		
		
	}
	
	
	func updateUser(user: User, with completion: @escaping (Result<Void>) -> Void) {
		

		LoginService().login(user: user) { result in
			switch result {
				case .success:
					self.updateAddress(user: user, with: completion)
				case .error(let error):
					completion(.error(error))
				
			}
		}
	}
	
	private func updateAddress(user: User, with completion: @escaping (Result<Void>) -> Void) {

		let addressBody: [String : Any] = ["CityID" : user.city.key]
		
		request(from: "\(userUpdateUrlString)\\address", requestType: .post, body: addressBody, expecting: [String : String].self) { result in
			switch result {
			case .success:
				self.updateInfo(user: user, with: completion)
			case .error(let error):
				completion(.error(error))
			}
		}
	}
	
	private func updateInfo(user: User, with completion: @escaping (Result<Void>) -> Void) {
		
		let userBody: [String : Any] = ["Email" : user.email,
										"FirstName" : user.firstName,
										"LastName" : user.lastName]
		
		
		request(from: "\(userUpdateUrlString)", requestType: .post, body: userBody, expecting: [String : String].self) { result in
			switch result {
			case .success:
				completion(.success(()))
			case .error(let error):
				completion(.error(error))
			}
		}
	}
	
	
	func changePassword(user: User, newPass: String,  with completion: @escaping (Result<Void>) -> Void) {
		
		LoginService().login(user: user) { result in
			switch result {
			case .success:
				self.updatePassword(user: user, newPass: newPass, with: completion)
			case .error(let error):
				completion(.error(error))
				
			}
		}
	}
	
	private func updatePassword(user: User, newPass: String,  with completion: @escaping (Result<Void>) -> Void) {
		
		let body: [String : Any] = ["oldpass" : user.password,
										"newpass" : newPass]
		
		request(from: "\(userUpdateUrlString)\\pass", requestType: .post, body: body, expecting: [String : String].self) { result in
			switch result {
			case .success:
				completion(.success(()))
			case .error(let error):
				completion(.error(error))
			}
		}
	}
	
	
	func fetchCountries(with completion: @escaping ((Result<[(key: String, value: String)]>) -> Void)) {
		fetchData(from: "\(locationUrlString)countries") { result in
			completion(result)
		}
	}
	
	func fetchProvinces(for countryCode: Int, with completion: @escaping ((Result<[(key: String, value: String)]>) -> Void)) {
		fetchData(from: "\(locationUrlString)\(countryCode)/provinces") { result in
			completion(result)
		}
	}
	
	func fetchCities(for provinceCode: Int, with completion: @escaping ((Result<[(key: String, value: String)]>) -> Void)) {
		fetchData(from: "\(locationUrlString)\(provinceCode)/cities") { result in
			completion(result)
		}
	}
	
	// MARK: - Private Helper Functions
	private func fetchData(from urlString: String, with completion: @escaping ((Result<[(key: String, value: String)]>) -> Void)) {
		request(from: urlString, expecting: [String : String].self) { result in
			switch result {
			case .success(let dictionary):
				let sortedCountries: [(key: String, value: String)] = dictionary.map({ ($0, $1) }).sorted(by: { $0.value < $1.value })
				completion(.success(sortedCountries))
			case .error(let error):
				completion(.error(error))
				break
			}
		}
	}
}

