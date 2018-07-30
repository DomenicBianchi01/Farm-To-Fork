//
//  JSONService.swift
//  Farm To Fork
//
//  Created by Domenic Bianchi on 2018-03-05.
//  Copyright © 2018 Domenic Bianchi & Marshall Asch. All rights reserved.
//

import UIKit

/**
 A class meant to be inherited by `Service` classes. This class helps encode JSON requests and decodes JSON responses. This class should never be used directly from a view model.
 
 Use the `request` function in this class to make HTTP requests.
 */
class JSONService {
    // MARK: - Properties
    ///IMPORTANT NOTE: For the scope of this project, the `JSONService` can only handle one network call at a time
    private var urlDataTask: URLSessionDataTask? = nil
    
    private var accessToken: String {
        return "TODO: Fetch for keychain"
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
    /**
     Fetch JSON data and parse it according to the `type` parameter in the function. In other words, the `url` must return JSON that maps to `type`.
     
     All requests made through this function have 15 seconds to receive a response, otherwise the request will timeout.
     
     - parameter urlString: A string representation of the URL that will return JSON data. This function will check if the string does indeed represent a valid URL. If not, an error is returned.
     - parameter requestType: Specifies the type of request using the `RequestType` enum. Defaults to `GET`
     - parameter body: If this parameter is included, the dictionary is sent in the http body. Defaults to `nil`
     - parameter type: The structure that the fetched JSON data should be parsed according to. NOTE: The structure must conform to `Decodable`.
     - parameter completion: If the function successfully fetched and parsed the JSON data, the completion block includes the parsed data as a structure that matches the type passed in the `type` parameter of this function. If the function could not parse the data, the completion block includes an error object instead.
     */
    func request<T: Decodable>(from urlString: String,
                               requestType: RequestType = .get,
                               body: [String : Any]? = nil,
                               //cookies: [HTTPCookie]? = nil,
        expecting type: T.Type,
        completion: @escaping (Result<T>) -> Void) {
        
        guard let url = URL(string: urlString) else {
            completion(.error(NSError(domain: "Invalid URL", code: 0, userInfo: nil)))
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = requestType.rawValue
        request.setValue("application/json; charset=utf-8", forHTTPHeaderField: "Content-Type")
        request.setValue(accessToken, forHTTPHeaderField: "Authorization")
        request.timeoutInterval = 15
        
        if let body = body {
            do {
                request.httpBody = try JSONSerialization.data(withJSONObject: body, options: .prettyPrinted)
            } catch {
                completion(.error(NSError(domain: "Could not serialize http body", code: 0, userInfo: nil)))
                return
            }
        }
        
        #if os(iOS)
        DispatchQueue.main.async {
            UIApplication.shared.isNetworkActivityIndicatorVisible = true
        }
        #endif
        
        urlDataTask?.cancel()
        let newSession = URLSession.self
        //        if let cookies = cookies {
        //            newSession.shared.configuration.httpCookieStorage?.setCookies(cookies, for: url, mainDocumentURL: nil)
        //        }
        urlDataTask = newSession.shared.dataTask(with: request) { (data, response, error) in
            #if os(iOS)
            DispatchQueue.main.async {
                UIApplication.shared.isNetworkActivityIndicatorVisible = false
            }
            #endif
            
            guard let data = data else {
                completion(.error(NSError(domain: "No data returned", code: 0, userInfo: nil)))
                return
            }
            do {
                let json = try JSONDecoder().decode(type, from: data)
                guard var jsonDict = json as? [String : Any] else {
                    completion(.success(json))
                    return
                }
                if let error = jsonDict["error"] {
                    var responseStatusCode = 0
                    if let response = response as? HTTPURLResponse {
                        responseStatusCode = response.statusCode
                    }
                    
                    if let errorString = error as? String {
                        completion(.error(NSError(domain: errorString, code: responseStatusCode, userInfo: nil)))
                    } else {
                        completion(.error(NSError(domain: "Could not retrieve data", code: responseStatusCode, userInfo: nil)))
                    }
                } else if let success = (jsonDict["success"] as? String)?.asBool, success {
                    jsonDict.removeValue(forKey: "success")
                    //self.saveCookies(response: response)
                    completion(.success(jsonDict as? T ?? json))
                } else {
                    //self.saveCookies(response: response)
                    completion(.success(json))
                }
            } catch {
                completion(.error(NSError(domain: "Invalid JSON", code: 0, userInfo: nil)))
            }
        }
        urlDataTask?.resume()
    }
    
    private func saveCookies(response: URLResponse?) {
        guard let response = response as? HTTPURLResponse, let fields = response.allHeaderFields as? [String : String], let url = response.url else {
            return
        }
        let cookies = HTTPCookie.cookies(withResponseHeaderFields: fields, for: url)
        HTTPCookieStorage.shared.setCookies(cookies, for: url, mainDocumentURL: nil)
        /*for cookie in cookies {
         var cookieProperties = [HTTPCookiePropertyKey: Any]()
         cookieProperties[HTTPCookiePropertyKey.name] = cookie.name
         cookieProperties[HTTPCookiePropertyKey.value] = cookie.value
         cookieProperties[HTTPCookiePropertyKey.domain] = cookie.domain
         cookieProperties[HTTPCookiePropertyKey.path] = cookie.path
         cookieProperties[HTTPCookiePropertyKey.version] = NSNumber(value: cookie.version)
         cookieProperties[HTTPCookiePropertyKey.expires] = NSDate().addingTimeInterval(31536000)
         
         let newCookie = HTTPCookie(properties: cookieProperties)
         HTTPCookieStorage.shared.setCookie(newCookie!)
         
         print("name: \(cookie.name) value: \(cookie.value)")
         }*/
    }
}
