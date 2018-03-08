//
//  StringExtensions.swift
//  Farm To Fork
//
//  Created by Domenic Bianchi on 2018-03-08.
//  Copyright © 2018 Domenic Bianchi & Marshall Asch. All rights reserved.
//

import Foundation

extension String {
    var asBool: Bool {
        let lowercasedString = self.lowercased()
        return lowercasedString == "true" || lowercasedString == "t"
    }
}
