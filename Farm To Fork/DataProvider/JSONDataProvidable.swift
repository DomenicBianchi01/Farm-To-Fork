//
//  JSONDataProvidable.swift
//  Farm To Fork
//
//  Created by Domenic Bianchi on 2018-03-05.
//  Copyright © 2018 Domenic Bianchi & Marshall Asch. All rights reserved.
//

import Foundation

protocol JSONDataProvidable {
    /**
     Fetch JSON data and parse it according to the `type` parameter in the function. In other words, the `url` must return JSON that maps to `type`.
     
     - parameter url: The URL that will return JSON data.
     - parameter type: The structure that the fetched JSON data should be parsed according to. NOTE: The structure must conform to `Decodable`.
     - parameter completion: If the function successfully fetched and parsed the JSON data, the completion block includes the parsed data as a structure that matches the type passed in the `type` parameter of this function. If the function could not parse the data, the completion block includes a nil object instead.
     */
    func fetchData<T: Decodable>(from url: URL, using type: T.Type, completion: @escaping (Result<Any>) -> Void)
}
