//
//  JSONService.swift
//  Farm To Fork
//
//  Created by Domenic Bianchi on 2018-03-05.
//  Copyright © 2018 Domenic Bianchi & Marshall Asch. All rights reserved.
//

import UIKit

/// A class meant to be inherited by `Service` classes. This class helps format JSON request and decodes JSON responses. This class should never be used directly from a view model.
class JSONService {
    // MARK: - Properties
    ///IMPORTANT NOTE: For the scope of this project, the `JSONDataService` can only handle one network call at a time
    private var urlDataTask: URLSessionDataTask? = nil
    
    // MARK: - Functions
    /**
     Fetch JSON data and parse it according to the `type` parameter in the function. In other words, the `url` must return JSON that maps to `type`.
     
     - parameter urlString: A string representation of the URL that will return JSON data. This function will check if the string does indeed represent a valid URL. If not, an error is returned.
     - parameter requestType: Specifies if the request is a `GET` or `POST`. Defaults to `GET`
     - parameter body: If this parameter is included, the dictionary is sent in the http body
     - parameter type: The structure that the fetched JSON data should be parsed according to. NOTE: The structure must conform to `Decodable`.
     - parameter completion: If the function successfully fetched and parsed the JSON data, the completion block includes the parsed data as a structure that matches the type passed in the `type` parameter of this function. If the function could not parse the data, the completion block includes an error object instead.
     */
    func request<T: Decodable>(from urlString: String, requestType: RequestType = .get, body: [String : Any]? = nil, expecting type: T.Type, completion: @escaping (Result<T>) -> Void) {
        guard let url = URL(string: urlString) else {
            completion(.error(NSError(domain: "Invalid URL", code: 0, userInfo: nil)))
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = requestType.rawValue
        request.setValue("application/json; charset=utf-8", forHTTPHeaderField: "Content-Type")
        request.timeoutInterval = 15
        
        if let body = body {
            request.httpBody = try? JSONSerialization.data(withJSONObject: body, options: .prettyPrinted)
        }
    
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
        urlDataTask?.cancel()
        urlDataTask = URLSession.shared.dataTask(with: request) { (data, response, error) in
            DispatchQueue.main.async {
                UIApplication.shared.isNetworkActivityIndicatorVisible = false
            }
            guard let data = data else {
                completion(.error(NSError(domain: "No data returned", code: 0, userInfo: nil)))
                return
            }
            do {
                let json = try JSONDecoder().decode(type, from: data)
                guard var jsonDict = json as? [String : String] else {
                    completion(.success(json))
                    return
                }
                if let error = jsonDict["error"] {
                    var responseStatusCode = 0
                    if let response = response as? HTTPURLResponse {
                        responseStatusCode = response.statusCode
                    }
                    completion(.error(NSError(domain: error, code: responseStatusCode, userInfo: nil)))
                } else if let success = jsonDict["success"]?.asBool, success {
                    jsonDict.removeValue(forKey: "success")
                    completion(.success(json))
                }
            } catch {
                completion(.error(NSError(domain: "Invalid JSON", code: 0, userInfo: nil)))
            }
        }
        urlDataTask?.resume()
    }
}
