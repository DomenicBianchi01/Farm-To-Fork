//
//  NeedsViewModel.swift
//  Farm To Fork
//
//  Created by Domenic Bianchi on 2018-03-15.
//  Copyright © 2018 Domenic Bianchi & Marshall Asch. All rights reserved.
//

import UIKit

final class NeedsViewModel {
    // MARK: - Properties
    private(set) var needs: [Need] = []
    var location: Location? = nil
    var expandedIndexPath: IndexPath? = nil
    var selectedRowToEdit: Int? = nil
    var hideCloseButton: Bool = true
    
    // MARK: - Computed Properties
    var isAdminForLocation: Bool {
        let locationId: Int
        if let location = location {
            locationId = location.id
        } else if let locationIdentifier = UserDefaults.appGroup?.integer(forKey: Constants.preferredLocationId) {
            locationId = locationIdentifier
        } else {
            return false
        }
        
        if loggedInUser?.workerLocationId == locationId {
            return true
        }
        return false
    }
    
    var name: String {
        if let locationName = location?.name {
            return locationName + " Needs"
        } else if let locationName = UserDefaults.appGroup?.string(forKey: Constants.preferredLocationName) {
            return locationName + " Needs"
        }
        return "Needs"
    }
    
    // MARK: - Helper Functions
    func fetchNeeds(with completion: @escaping ((Result<Void>) -> Void)) {
        let locationId: Int
        if let location = location {
            locationId = location.id
        } else if let locationIdentifier = UserDefaults.appGroup?.integer(forKey: Constants.preferredLocationId) {
            locationId = locationIdentifier
        } else {
            completion(.error(NSError(domain: "No location info found", code: 0, userInfo: nil)))
            return
        }
        
        NeedsService().fetchNeeds(forLocation: locationId) { result in
            switch result {
            case .success(let needs):
                self.needs = needs
                completion(.success(()))
            case .error(let error):
                self.needs = []
                completion(.error(error))
            }
        }
    }
    
    func deleteNeed(at index: Int, with completion: @escaping ((Result<Void>) -> Void)) {
        guard let locationId = loggedInUser?.workerLocationId else {
            completion(.error(NSError(domain: "Not authorized to perform this action", code: 0, userInfo: nil)))
            return
        }
        NeedsService().delete(needId: needs[index].id, forLocation: String(locationId)) { result in
            switch result {
            case .success:
                self.needs.remove(at: index)
                completion(.success(()))
            case .error(let error):
                completion(.error(error))
            }
        }
    }
    
    func isEditable(at indexPath: IndexPath) -> Bool {
        guard indexPath != expandedIndexPath else {
                return false
        }
        return isAdminForLocation
    }
}

// MARK: - TableViewModelable
extension NeedsViewModel: TableViewModelable {
    var numberOfSections: Int {
        return 1
    }
    
    func numberOfRows(in section: Int) -> Int {
        if expandedIndexPath != nil {
            return needs.count + 1
        }
        return needs.count
    }
    
    func cellForRow(in tableView: UITableView, at indexPath: IndexPath) -> UITableViewCell {
        let cellIdentifier: String
        
        if let expandedIndexPath = expandedIndexPath, indexPath == expandedIndexPath {
            cellIdentifier = "ExpandedNeedItemReuseIdentifier"
        } else {
            cellIdentifier = "NeedItemReuseIdentifier"
        }
        
        let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath)

        if let cell = cell as? ExpandedNeedItemTableViewCell {
            cell.viewModel = ExpandedNeedCellViewModel(need: needs[indexPath.row-1])
        } else if let cell = cell as? NeedItemTableViewCell {
            cell.viewModel = NeedCellViewModel(need: needs[indexPath.row])
        }
        
        return cell
    }
}
