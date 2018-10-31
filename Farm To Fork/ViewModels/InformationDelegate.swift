//
//  InformationDelegate.swift
//  Farm To Fork
//
//  Created by Domenic Bianchi on 2018-09-23.
//  Copyright © 2018 Domenic Bianchi. All rights reserved.
//

import Foundation

protocol InformationDelegate: class {
    func informationUpdated(with info: [String : Any])
}

protocol InformationDelgatable {
    var delegate: InformationDelegate? { get set }
}
