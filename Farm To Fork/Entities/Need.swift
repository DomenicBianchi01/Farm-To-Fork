//
//  Need.swift
//  Farm To Fork
//
//  Created by Domenic Bianchi on 2018-03-18.
//  Copyright © 2018 Domenic Bianchi & Marshall Asch. All rights reserved.
//

import Foundation

class Need: Decodable {
    // MARK: - Properties
    let id: Int
    let name: String
    let description: String
    let type: String
    let category: String
    let targetQuantity: Int
    let currentQuantity: Int

    // MARK: - Lifecycle Functions
    init(id: Int,
         name: String,
         description: String,
         type: String,
         category: String,
         targetQuantity: Int,
         currentQuantity: Int) {

        self.id = id
        self.name = name
        self.description = description
        self.type = type
        self.category = category
        self.targetQuantity = targetQuantity
        self.currentQuantity = currentQuantity

    }

    /**
     Create a `Need` object using a dictionary.
     
     - parameter dictionary: Mandatory fields are: `NeedID`, `ItemName`, `Description`, `Type`, `CategoryName`, `TargetQty` and `CurrentQty`
     */
    convenience init?(dictionary: [String : Any]) {
        guard let id = dictionary["NeedID"] as? Int,
            let name = dictionary["ItemName"] as? String,
            let description = dictionary["Description"] as? String,
            let type = dictionary["Type"] as? String,
            let category = dictionary["CategoryName"] as? String,
            let targetQuantity = dictionary["TargetQty"] as? Int,
            let currentQuantity = dictionary["CurrentQty"] as? Int else {
                return nil
        }
        
        self.init(id: id,
                  name: name,
                  description: description,
                  type: type,
                  category: category,
                  targetQuantity: targetQuantity,
                  currentQuantity: currentQuantity)
    }

    // MARK: - Decodable
    private enum NeedKeys: String, CodingKey {
        case id = "NeedID"
        case name = "ItemName"
        case description = "Description"
        case type = "Type"
        case category = "CategoryName"
        case targetQuantity = "TargetQty"
        case currentQuantity = "CurrentQty"
    }

    required convenience init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: NeedKeys.self)
        let id = try container.decode(String.self, forKey: .id)
        let name = try container.decode(String.self, forKey: .name)
        let description = try container.decode(String.self, forKey: .description)
        let type = try container.decode(String.self, forKey: .type)
        let category = try container.decode(String.self, forKey: .category)
        let targetQuantity = try container.decode(String.self, forKey: .targetQuantity)
        let currentQuantity = try container.decode(String.self, forKey: .currentQuantity)
        
        guard let idInt = Int(id), let targetQuantityInt = Int(targetQuantity), let currentQuantityInt = Int(currentQuantity) else {
            throw DecodingError.typeMismatch(Int.self, DecodingError.Context(codingPath: container.codingPath, debugDescription: "Cannot decode id and/or quantities"))
        }
        
        self.init(id: idInt,
                  name: name,
                  description: description,
                  type: type,
                  category: category,
                  targetQuantity: targetQuantityInt,
                  currentQuantity: currentQuantityInt)
    }
}
