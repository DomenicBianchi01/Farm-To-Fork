//
//  Category.swift
//  Farm To Fork
//
//  Created by Domenic Bianchi on 2018-10-01.
//  Copyright © 2018 Domenic Bianchi. All rights reserved.
//

import Foundation

/** A `Unit` shares the same data structure as a `Category`
 
 Named this alias `Units` instead of `Unit` since `Unit` is an existing class in iOS
 */
typealias Units = Category

class Category: Decodable {
    // MARK: - Properties
    let id: Int
    let name: String
    
    // MARK: - Enums
    private enum Keys: String, CodingKey {
        case id = "ID"
        case name = "Name"
    }
    
    // MARK: - Lifecycle Functions
    init(id: Int,
         name: String) {
        
        self.id = id
        self.name = name
    }
    
    // MARK: - Decodable
    required convenience init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: Keys.self)
        let id = try container.decode(String.self, forKey: .id)
        let name = try container.decode(String.self, forKey: .name)
        
        guard let idInt = Int(id) else {
            throw DecodingError.typeMismatch(Int.self, DecodingError.Context(codingPath: container.codingPath, debugDescription: "Could not decode id"))
        }
        
        self.init(id: idInt,
                  name: name)
    }
}
