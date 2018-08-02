//
//  Need.swift
//  Farm To Fork
//
//  Created by Domenic Bianchi on 2018-03-18.
//  Copyright © 2018 Domenic Bianchi & Marshall Asch. All rights reserved.
//

import Foundation

struct Need {
    // MARK: - Properties
    let id: Int
    let name: String
    let description: String
    let type: String
    let category: String
    let targetQuantity: Int
    let currentQuantity: Int
    
    // MARK: - Lifecycle Functions
    init?(dictionary: [String : String]) {
        guard let name = dictionary["ItemName"],
            let description = dictionary["Description"],
            let type = dictionary["Type"],
            let category = dictionary["CategoryName"],
            let targetQuantity = dictionary["TargetQty"],
            let currentQuantity = dictionary["CurrentQty"],
            let targetQuantityInt = Int(targetQuantity),
            let currentQuantityInt = Int(currentQuantity) else {
                return nil
        }
        
        self.name = name
        self.description = description
        self.type = type
        self.category = category
        self.targetQuantity = targetQuantityInt
        self.currentQuantity = currentQuantityInt
        
        //TODO: GET ID BACK FROM API RESPONSE
        self.id = 0
    }
}
