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
    var hideCloseButton: Bool = true
    
    // MARK: - Helper Functions
    func fetchNeeds(with completion: @escaping ((Result<Void>) -> Void)) {
        let locationId: String
        if let location = location {
            locationId = location.id
        } else if let locationIdentifier = UserDefaults.appGroup?.string(forKey: Constants.preferredLocationId) {
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
        if indexPath == expandedIndexPath {
            return false
        }
        return loggedInUser?.isAdmin ?? false
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
        let need: Need
        
        if let expandedIndexPath = expandedIndexPath, indexPath == expandedIndexPath {
            cellIdentifier = "ExpandedNeedItemReuseIdentifier"
            need = needs[indexPath.row-1]
        } else {
            guard indexPath.row < needs.count else {
                return UITableViewCell()
            }
            cellIdentifier = "NeedItemReuseIdentifier"
            need = needs[indexPath.row]
        }
        
        let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath)

        if let cell = cell as? Configurable {
            cell.configure(using: need)
        }
        
        return cell
    }
}
