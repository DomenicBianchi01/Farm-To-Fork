//
//  TableViewModelable.swift
//  Farm To Fork
//
//  Created by Domenic Bianchi on 2018-03-05.
//  Copyright © 2018 Domenic Bianchi & Marshall Asch. All rights reserved.
//

import Foundation
import UIKit

protocol TableViewModelable {
    var numberOfSections: Int { get }
    func numberOfRows(in section: Int)
    func cellForRow(in tableView: UITableView, at indexPath: IndexPath) -> UITableViewCell
}
