//
//  RegisterService.swift
//  Farm To Fork
//
//  Created by Domenic Bianchi on 2018-03-08.
//  Copyright © 2018 Domenic Bianchi & Marshall Asch. All rights reserved.
//

import Foundation

struct RegisterService {
    func register(user: User, with completion: @escaping (Result<Void>) -> Void) {
        
    }
    
    func fetchCountries(with completion: @escaping ((Result<[String]>) -> Void)) {
        JSONDataService.fetchData(from: "https://farmtofork.marshallasch.ca/api.php/2.0/location/countries", using: [String : String].self) { result in
            switch result {
            case .success(let dictionary):
                completion(.success(dictionary.values.map({ String($0) }).sorted()))
            case .error(let error):
                completion(.error(error))
                break
            }
        }
    }
}
