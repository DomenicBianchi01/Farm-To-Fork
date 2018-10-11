//
//  Need.swift
//  Farm To Fork
//
//  Created by Domenic Bianchi on 2018-03-18.
//  Copyright © 2018 Domenic Bianchi & Marshall Asch. All rights reserved.
//

import Foundation

class Need: Codable {
    // MARK: - Properties
    let id: Int
    let name: String
    let description: String
    let units: Units
    let category: Category
    let targetQuantity: Int
    let currentQuantity: Int
    let disabled: Bool
    
    // MARK: - Enums
    enum Keys: String, CodingKey {
        case id = "NeedID"
        case name = "Name"
        case description = "Description"
        case units = "Type"
        case category = "Category"
        case targetQuantity = "TargetQty"
        case currentQuantity = "CurrentQty"
        case disabled = "Disabled"
    }
    
    private enum EncodableKeys: String, CodingKey {
        case id = "NeedID"
        case name = "Name"
        case description = "Description"
        case units = "UnitID"
        case category = "CategoryID"
        case targetQuantity = "Quantity"
        case disabled = "Disabled"
    }

    // MARK: - Lifecycle Functions
    init(id: Int,
         name: String,
         description: String,
         units: Units,
         category: Category,
         targetQuantity: Int,
         currentQuantity: Int,
         disabled: Bool) {

        self.id = id
        self.name = name
        self.description = description
        self.units = units
        self.category = category
        self.targetQuantity = targetQuantity
        self.currentQuantity = currentQuantity
        self.disabled = disabled

    }

    /**
     Create a `Need` object using a dictionary.
     
     - parameter dictionary: Mandatory fields are: `NeedID`, `ItemName`, `Description`, `Type`, `CategoryName`, `TargetQty` and `CurrentQty`
     */
    convenience init?(dictionary: [String : Any]) {
        guard let id = dictionary[Keys.id.rawValue] as? Int,
            let name = dictionary[Keys.name.rawValue] as? String,
            let description = dictionary[Keys.description.rawValue] as? String,
            let units = dictionary[Keys.units.rawValue] as? Units,
            let category = dictionary[Keys.category.rawValue] as? Category,
            let targetQuantity = dictionary[Keys.targetQuantity.rawValue] as? Int,
            let currentQuantity = dictionary[Keys.currentQuantity.rawValue] as? Int,
            let disabled = dictionary[Keys.disabled.rawValue] as? Bool else {
                return nil
        }
        
        self.init(id: id,
                  name: name,
                  description: description,
                  units: units,
                  category: category,
                  targetQuantity: targetQuantity,
                  currentQuantity: currentQuantity,
                  disabled: disabled)
    }

    // MARK: - Decodable
    required convenience init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: Keys.self)
        let id = try container.decode(String.self, forKey: .id)
        let name = try container.decode(String.self, forKey: .name)
        let description = try container.decode(String.self, forKey: .description)
        let units = try container.decode(Units.self, forKey: .units)
        let category = try container.decode(Category.self, forKey: .category)
        let targetQuantity = try container.decode(String.self, forKey: .targetQuantity)
        let currentQuantity = try container.decode(String.self, forKey: .currentQuantity)
        let disabled = try container.decode(String.self, forKey: .disabled)
        
        guard let idInt = Int(id),
            let targetQuantityInt = Int(targetQuantity),
            let currentQuantityInt = Int(currentQuantity) else {
            throw DecodingError.typeMismatch(Int.self, DecodingError.Context(codingPath: container.codingPath, debugDescription: "Cannot decode id and/or quantities"))
        }
        
        self.init(id: idInt,
                  name: name,
                  description: description,
                  units: units,
                  category: category,
                  targetQuantity: targetQuantityInt,
                  currentQuantity: currentQuantityInt,
                  disabled: disabled.asBool)
    }
    
    // MARK: - Encodable
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: EncodableKeys.self)
        
        // Negative id means we are creating a new need and therefore, the need doesn't actually have an id yet
        if id > 0 {
            try container.encode(id, forKey: .id)
        }
        
        try container.encode(name, forKey: .name)
        try container.encode(description, forKey: .description)
        try container.encode(units.id, forKey: .units)
        try container.encode(category.id, forKey: .category)
        try container.encode(targetQuantity, forKey: .targetQuantity)
        try container.encode(disabled.asString, forKey: .disabled)
    }
}
