//
//  JSONService.swift
//  Farm To Fork
//
//  Created by Domenic Bianchi on 2018-03-05.
//  Copyright © 2018 Domenic Bianchi & Marshall Asch. All rights reserved.
//

import UIKit
import Valet

/**
 A class meant to be inherited by `Service` classes. This class helps encode JSON requests and decodes JSON responses.
 
 Use the `request` functions in this class to make HTTP requests.
 */
class JSONService {
    // MARK: - Properties
    ///IMPORTANT NOTE: For the scope of this project, the `JSONService` can only handle one network call at a time
    private var urlDataTask: URLSessionDataTask? = nil

    /// Get token stored in the keychain
    private var accessToken: String? {
        return Valet.F2FValet.string(forKey: Constants.token)
    }

    // MARK: - Enums
    /// Used to specify the type of request that should be made
    enum RequestType: String {
        case post = "POST"
        case get = "GET"
        case put = "PUT"
        case delete = "DELETE"
        case patch = "PATCH"
    }
    
    // MARK: - Functions
    
    // A QUICK NOTE: I tried to get the "request" function to work such that there would be two generics, D and E (which would restricted to Encodable). The "body" parameter would be passed in as a dictionary and then encoded within the function. However, the compiler seemed to be getting confused as was complaining that the return value couldn't be determined (even though the addtion of E shouldn't have any impact on what the return type is). As a result, the "encode" function must be called prior to calling the "request" function since the F2F registration logic requires a [String : Any] to be encoded (which therefore needs to use JSONSerialization since Encodable cannot handle Any). Rather than including the logic of determining whether we could use Encodable or would have to fall back to JSONSerialization, the "request" function expects a "Data" typed to be passed in for the body. I hope I'm just doing something silly that is causing the compile to fail but if its a Swift limitation, then we are stuck with the current implemented way...
    
    /**
     A helper function that takes an `object` that conforms to `Encodable` and transforms it into a `Data` object so long as the object can be represented as JSON.
     
     - parameter object: An object that conforms to `Encodable` that will be transformed into a `Data` object
     
     - returns: A `Data` representation of the `object`. If the encoding failed, `nil` is returned
    */
    func encode<E: Encodable>(object: E) -> Data? {
        return try? JSONEncoder().encode(object)
    }

    /**
     Send JSON data and/or parse a JSON response according to the `type` parameter in the function.
     
     `urlString` must return JSON that maps to `type`.
     
     All requests made through this function have 15 seconds to receive a response, otherwise the request will timeout.
     
     - parameter urlString: A string representation of the URL that will return JSON data. This function will check if the string does indeed represent a valid URL. If not, an error is returned.
     - parameter useToken: Boolean value to specify whether or not to include the user's access token (JWT) with the request. Defaults to `false`
     - parameter requestType: Specifies the type of request using the `RequestType` enum. Defaults to `GET`
     - parameter body: If this parameter is included, the data is sent in the http body. Use the `encode` function (part of this class) to help encode a dictionary into `Data`. Defaults to `nil`
     - parameter type: The structure that the fetched JSON data should be parsed according to. If you are not expecting anything in the response, use `JSONEmpty`. NOTE: The structure must conform to `Decodable`.
     - parameter completion: If the function successfully fetched and parsed the JSON data, the completion block includes the parsed data as a structure that matches the type passed in the `type` parameter of this function. If the function could not parse the data, the completion block includes an error object instead.
     */
    func request<D: Decodable>(from urlString: String,
                               useToken: Bool = false,
                               requestType: RequestType = .get,
                               body: Data? = nil,
                               expecting type: D.Type,
                               completion: @escaping (Result<D>) -> Void) {
        
        guard let request = createURLRequest(from: urlString, useToken: useToken, requestType: requestType, body: body) else {
            completion(.error(NSError(domain: "Invalid URL", code: 0, userInfo: nil)))
            return
        }

        #if os(iOS)
        updateNetworkActivityIndicator(isHidden: false)
        #endif

        //This class only supports running one network request at a time so if there is a request currently in progress, cancel it.
        urlDataTask?.cancel()

        let newSession = URLSession.self

        urlDataTask = newSession.shared.dataTask(with: request) { (data, response, error) in
            #if os(iOS)
            self.updateNetworkActivityIndicator(isHidden: true)
            #endif

            guard let data = data else {
                completion(.error(NSError(domain: "No data returned", code: 0, userInfo: nil)))
                return
            }
            do {
                if let response = response as? HTTPURLResponse, response.statusCodeIsError {
                    let json = try JSONDecoder().decode(JSONError.self, from: data)
                    completion(.error(NSError(domain: json.error, code: response.statusCode, userInfo: nil)))
                    return
                }
                
                let json = try JSONDecoder().decode(type, from: data)
                completion(.success(json))
            } catch {
                completion(.error(NSError(domain: "Could not decode JSON", code: 0, userInfo: nil)))
            }
        }
        urlDataTask?.resume()
    }
    
    /**
     Send JSON data through a network request.
     
     NOTE: Use this function if the response will be empty. This function WILL NOT parse any type of response.
     
     All requests made through this function have 15 seconds to receive a response, otherwise the request will timeout.
     
     - parameter urlString: A string representation of the URL that will return JSON data. This function will check if the string does indeed represent a valid URL. If not, an error is returned.
     - parameter useToken: Boolean value to specify whether or not to include the user's access token (JWT) with the request. Defaults to `false`
     - parameter requestType: Specifies the type of request using the `RequestType` enum. Defaults to `GET`
     - parameter body: If this parameter is included, the data is sent in the http body. Use the `encode` function (part of this class) to help encode a dictionary into `Data`. Defaults to `nil`
     */
    func request(from urlString: String,
                 useToken: Bool = false,
                 requestType: RequestType = .get,
                 body: Data? = nil,
                 completion: @escaping (Result<Void>) -> Void) {
        
        guard let request = createURLRequest(from: urlString, useToken: useToken, requestType: requestType, body: body) else {
            completion(.error(NSError(domain: "Invalid URL", code: 0, userInfo: nil)))
            return
        }
        
        #if os(iOS)
        updateNetworkActivityIndicator(isHidden: false)
        #endif
        
        //This class only supports running one network request at a time so if there is a request currently in progress, cancel it.
        urlDataTask?.cancel()
        
        let newSession = URLSession.self
        
        urlDataTask = newSession.shared.dataTask(with: request) { (data, response, error) in
            #if os(iOS)
            self.updateNetworkActivityIndicator(isHidden: true)
            #endif
            
            guard let data = data else {
                completion(.error(NSError(domain: "No data returned", code: 0, userInfo: nil)))
                return
            }
            do {
                if let response = response as? HTTPURLResponse, response.statusCodeIsError {
                    let json = try JSONDecoder().decode(JSONError.self, from: data)
                    completion(.error(NSError(domain: json.error, code: response.statusCode, userInfo: nil)))
                    return
                }
                completion(.success(()))
            } catch {
                completion(.error(NSError(domain: "An error has occured", code: 0, userInfo: nil)))
            }
        }
        urlDataTask?.resume()
    }
    
    // MARK: - Private Helper Functions
    private func createURLRequest(from urlString: String,
                                  useToken: Bool = false,
                                  requestType: RequestType = .get,
                                  body: Data? = nil) -> URLRequest? {
        guard let url = URL(string: urlString) else {
            return nil
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = requestType.rawValue
        request.setValue("application/json; charset=utf-8", forHTTPHeaderField: "Content-Type")
        
        if useToken {
            request.setValue(accessToken, forHTTPHeaderField: "Authorization")
        }
        
        request.timeoutInterval = 15
        
        if let body = body {
            request.httpBody = body
        }
        
        return request
    }
    
    @available(watchOS, unavailable)
    private func updateNetworkActivityIndicator(isHidden: Bool) {
        #if os(iOS)
        DispatchQueue.main.async {
            UIApplication.shared.isNetworkActivityIndicatorVisible = !isHidden
        }
        #endif
    }
}
