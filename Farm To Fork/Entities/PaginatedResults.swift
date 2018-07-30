//
//  PaginatedResults.swift
//  Farm To Fork
//
//  Created by Domenic Bianchi on 2018-07-27.
//  Copyright © 2018 Domenic Bianchi. All rights reserved.
//

import Foundation

//TODO: Might not need this
protocol Pagination {
    var totalCount: Int { get set }
    var offset: Int { get set }
    var limit: Int { get set }
}
