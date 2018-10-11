//
//  Pledge.swift
//  Farm To Fork
//
//  Created by Domenic Bianchi on 2018-10-10.
//  Copyright © 2018 Domenic Bianchi. All rights reserved.
//

import Foundation

class Pledge: Codable {
    // MARK: - Properties
    let id: Int
    let needId: Int
    let userId: Int
    let locationId: Int
    let pledged: Int
    
    // MARK: - Lifecycle Functions
    init(id: Int,
         needId: Int,
         userId: Int,
         locationId: Int,
         pledged: Int) {
        
        self.id = id
        self.needId = needId
        self.userId = userId
        self.locationId = locationId
        self.pledged = pledged
    }
    
    // MARK: - Enums
    private enum Keys: String, CodingKey {
        case id
        case needId = "NeedID"
        case userId
        case pledged = "QuantityPledged"
    }
    
    private enum EncodableKeys: String, CodingKey {
        case needId = "NeedID"
        case userId = "UserID"
        case pledged = "Quantity"
    }
    
    // MARK: - Decodable
    // This function is currently only used to parse pledges by a specific user at a specific location. The `id`, `userId`, and `locationId` are therefore not needed at this time.
    required convenience init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: Keys.self)
        let needId = try container.decode(String.self, forKey: .needId)
        let pledged = try container.decode(String.self, forKey: .pledged)
        
        guard let needIdInt = Int(needId),
                let pledgedInt = Int(pledged) else {
                throw DecodingError.typeMismatch(Int.self, DecodingError.Context(codingPath: container.codingPath, debugDescription: "Cannot decode need ID or pledge quantity"))
        }
        
        self.init(id: 0,
                  needId: needIdInt,
                  userId: 0,
                  locationId: 0,
                  pledged: pledgedInt)
    }
    
    // MARK: - Encodable
    // This function is used to create an new pledge `Data` type that can be sent through an API request
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: EncodableKeys.self)
        
        try container.encode(needId, forKey: .needId)
        try container.encode(userId, forKey: .userId)
        try container.encode(pledged, forKey: .pledged)
    }
}
