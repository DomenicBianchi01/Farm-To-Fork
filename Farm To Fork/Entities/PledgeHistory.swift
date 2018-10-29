//
//  PledgeHistory.swift
//  Farm To Fork
//
//  Created by Domenic Bianchi on 2018-10-29.
//  Copyright © 2018 Domenic Bianchi. All rights reserved.
//

import Foundation

class PledgeHistory: Decodable {
    // MARK: - Properties
    let needName: String
    let needDescription: String
    let locationName: String
    let pledged: Int
    let pledgeDateString: String
    let pledgeDate: Date
    
    // MARK: - Lifecycle Functions
    init(needName: String,
         needDescription: String,
         locationName: String,
         pledged: Int,
         pledgeDateString: String,
         pledgeDate: Date) {
        
        self.needName = needName
        self.needDescription = needDescription
        self.locationName = locationName
        self.pledged = pledged
        self.pledgeDateString = pledgeDateString
        self.pledgeDate = pledgeDate
    }
    
    // MARK: - Enums
    private enum Keys: String, CodingKey {
        case needName = "Name"
        case needDescription = "Description"
        case locationName = "EFPName"
        case pledged = "QuantityPledged"
        case pledgedDate = "Timestamp"
    }
    
    // MARK: - Decodable
    required convenience init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: Keys.self)
        let needName = try container.decode(String.self, forKey: .needName)
        let needDescription = try container.decode(String.self, forKey: .needDescription)
        let locationName = try container.decode(String.self, forKey: .locationName)
        let pledged = try container.decode(String.self, forKey: .pledged)
        let pledgedDate = try container.decode(String.self, forKey: .pledgedDate)
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        
        let stringDateFormatter = DateFormatter()
        stringDateFormatter.dateFormat = "MMMM dd, yyyy @ h:MM a"
        
        guard let pledgedInt = Int(pledged),
            let date = dateFormatter.date(from: pledgedDate) else {
                throw DecodingError.typeMismatch(Int.self, DecodingError.Context(codingPath: container.codingPath, debugDescription: "Cannot decode pledge quantity or date"))
        }
        
        let stringDate = stringDateFormatter.string(from: date)
        
        self.init(needName: needName,
                  needDescription: needDescription,
                  locationName: locationName,
                  pledged: pledgedInt,
                  pledgeDateString: stringDate,
                  pledgeDate: date)
    }
}
