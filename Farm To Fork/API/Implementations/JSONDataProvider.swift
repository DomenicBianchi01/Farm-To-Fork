//
//  JSONDataProvider.swift
//  Farm To Fork
//
//  Created by Domenic Bianchi on 2018-03-05.
//  Copyright © 2018 Domenic Bianchi & Marshall Asch. All rights reserved.
//

import Foundation

struct JSONDataProvider {
    /**
     Fetch JSON data and parse it according to the `type` parameter in the function. In other words, the `url` must return JSON that maps to `type`.
     
     - parameter urlString: A string representation of the URL that will return JSON data. This function will check if the string does indeed represent a valid URL. If not, an error is returned.
     - parameter type: The structure that the fetched JSON data should be parsed according to. NOTE: The structure must conform to `Decodable`.
     - parameter completion: If the function successfully fetched and parsed the JSON data, the completion block includes the parsed data as a structure that matches the type passed in the `type` parameter of this function. If the function could not parse the data, the completion block includes a nil object instead.
     */
    static func fetchData<T: Decodable>(from urlString: String, using type: T.Type, completion: @escaping (Result<T>) -> Void) {
        guard let url = URL(string: urlString) else {
            completion(.error(DataError.invalidURL))
            return
        }
        
        do {
            let jsonString = try String(contentsOf: url, encoding: .ascii)
            if let jsonData = jsonString.data(using: .utf8) {
                let json = try JSONDecoder().decode(type, from: jsonData)
                completion(.success(json))
                return
            }
        } catch {}
        
        completion(.error(DataError.invalidJSON))
    }
}

enum DataError: Error {
    case invalidURL
    case invalidJSON
}

extension DataError: LocalizedError {
    var errorDescription: String? {
        switch self {
        case .invalidURL:
            return "Invalid URL"
        case .invalidJSON:
            return "The data returned is not in JSON format."
        }
    }
}
