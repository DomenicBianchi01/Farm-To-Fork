//
//  WatchTableViewModelable.swift
//  Farm To Fork For Apple Watch Extension
//
//  Created by Domenic Bianchi on 2018-03-21.
//  Copyright © 2018 Domenic Bianchi & Marshall Asch. All rights reserved.
//

import Foundation

protocol WatchTableViewModelable {
    var numberOfRows: Int { get }
    func rowType(for row: Int) -> String
}
