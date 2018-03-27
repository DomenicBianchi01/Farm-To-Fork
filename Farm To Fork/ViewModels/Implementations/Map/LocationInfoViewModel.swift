//
//  LocationInfoViewModel.swift
//  Farm To Fork
//
//  Created by Domenic Bianchi on 2018-03-25.
//  Copyright © 2018 Domenic Bianchi & Marshall Asch. All rights reserved.
//

import UIKit

final class LocationInfoViewModel {
    // MARK: - Properties
    var location: Location? = nil
}

// MARK: - TableViewModelable
extension LocationInfoViewModel: TableViewModelable {
    var numberOfSections: Int {
        return 2
    }
    
    func numberOfRows(in section: Int) -> Int {
        var rowCount: Int
        if section == 0 {
            rowCount = 2
            if location?.phoneNumber != nil {
                rowCount += 1
            }
            if location?.website != nil {
                rowCount += 1
            }
        } else {
            rowCount = 1
        }

        return rowCount
    }
    
    func titleForHeader(in section: Int) -> String? {
        if section == 1 {
            return "Hours"
        }
        return nil
    }
    
    func heightForHeader(in section: Int) -> CGFloat {
        if section == 0 {
            return CGFloat.leastNormalMagnitude
        }
        return 30
    }
    
    func cellForRow(in tableView: UITableView, at indexPath: IndexPath) -> UITableViewCell {
        let reuseIdentifier: String
        
        if indexPath.section == 0 && indexPath.row == 0 {
            reuseIdentifier = "locationHeaderReuseIdentifier"
        } else if indexPath.section == 0 {
            reuseIdentifier = "basicLabelReuseIdentifier"
        } else {
            reuseIdentifier = "hoursReuseIdentifier"
        }
        
        let cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifier, for: indexPath)
        
        if (indexPath.section == 0 && indexPath.row == 0) || indexPath.section == 1 {
            cell.separatorInset = UIEdgeInsets(top: 0, left: 10000, bottom: 0, right: 0)
        }
        
        return cell
    }
}
