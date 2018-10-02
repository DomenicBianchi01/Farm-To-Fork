//
//  Configurable.swift
//  Farm To Fork
//
//  Created by Domenic Bianchi on 2018-09-09.
//  Copyright © 2018 Domenic Bianchi. All rights reserved.
//

import Foundation

/**
 Use this protocol to say that some object is configurable. For example, a `UITableViewCell` would be configurable. The cell would implement this protocol and know how to handle the `data` parameter (for example, casting to a specific type and populating labels). Then, the parent would use this function to pass data to the child. For example, the `TableViewController` would cast the dequeued cell to this protocol rather than a concrete type.
 */
protocol Configurable {
    func configure(using data: Any)
}
