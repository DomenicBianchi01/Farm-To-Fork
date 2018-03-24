//
//  RegisterService.swift
//  Farm To Fork
//
//  Created by Domenic Bianchi on 2018-03-08.
//  Copyright © 2018 Domenic Bianchi & Marshall Asch. All rights reserved.
//

import Foundation

final class RegisterService: JSONService {
    // MARK: - Properties
    private let locationUrlString = "https://farmtofork.marshallasch.ca/api.php/2.0/location/"
    private let registerUrlString = "https://farmtofork.marshallasch.ca/api.php/2.0/user/register"
    
    // MARK: - Functions
    
    /// Register the `User` with the Farm To Fork program.
    func register(user: User, with completion: @escaping (Result<Void>) -> Void) {
        let body: [String : Any] = ["Email" : user.email,
                                    "pass" : user.password,
                                    "FirstName" : user.firstName,
                                    "LastName" : user.lastName,
                                    "Address" : ["CityID" : user.city.key]]
        
        request(from: registerUrlString, requestType: .post, body: body, expecting: [String : String].self) { result in
            switch result {
            case .success:
                completion(.success(()))
            case .error(let error):
                completion(.error(error))
            }
        }
    }
    
    /// Fetch a list of countries
    func fetchCountries(with completion: @escaping ((Result<[(key: String, value: String)]>) -> Void)) {
        fetchData(from: "\(locationUrlString)countries") { result in
            completion(result)
        }
    }
    
    /// Fetch a list of provinces within the given country
    func fetchProvinces(for countryCode: Int, with completion: @escaping ((Result<[(key: String, value: String)]>) -> Void)) {
        fetchData(from: "\(locationUrlString)\(countryCode)/provinces") { result in
            completion(result)
        }
    }
    
    /// Fetch a list of cities within the given province
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
