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
    private var pledges: [Pledge] = []
    private(set) var disabledNeedsHidden: Bool = true
    var location: Location? = nil
    var expandedIndexPath: IndexPath? = nil
    var selectedRowToEdit: Int? = nil
    var hideCloseButton: Bool = true
    
    // MARK: - Computed Properties
    var isAdminForLocation: Bool {
        let locationId: Int
        if let location = location {
            locationId = location.id
        } else if let locationIdentifier = UserDefaults.appGroup?.object(forKey: Constants.preferredLocationId) as? Int {
            locationId = locationIdentifier
        } else {
            return false
        }
        
        if loggedInUser?.workerLocationId == locationId {
            return true
        }
        return false
    }
    
    var locationId: Int? {
        if let location = location {
            return location.id
        } else if let locationIdentifier = UserDefaults.appGroup?.object(forKey: Constants.preferredLocationId) as? Int {
            return locationIdentifier
        }
        return nil
    }
    
    var name: String {
        if let locationName = location?.name {
            return locationName + " Needs"
        } else if let locationName = UserDefaults.appGroup?.string(forKey: Constants.preferredLocationName) {
            return locationName + " Needs"
        }
        return "Needs"
    }
    
    var noNeeds: Bool {
        return needs.count == 0 || (disabledNeedsHidden && needs.filter({ !$0.disabled }).count == 0)
    }
    
    // MARK: - Helper Functions
    /// Calling this function will make two API requests. One to fetch the needs, and one to fetch the pledges for each need (for the logged in user)
    func fetchNeeds(with completion: @escaping ((Result<Void>) -> Void)) {
        let locationId: Int
        if let location = location {
            locationId = location.id
        } else if let locationIdentifier = UserDefaults.appGroup?.object(forKey: Constants.preferredLocationId) as? Int {
            locationId = locationIdentifier
        } else {
            completion(.error(NSError(domain: "No location info found", code: 0, userInfo: nil)))
            return
        }
        
        expandedIndexPath = nil
        
        let dispatchGroup = DispatchGroup()
        var apiError: Error? = nil
        dispatchGroup.enter()
        
        NeedsService().fetchNeeds(forLocation: locationId, disabledNeeds: !disabledNeedsHidden) { result in
            switch result {
            case .success(let needs):
                self.needs = needs
            case .error(let error):
                self.needs = []
                apiError = error
            }
            dispatchGroup.leave()
        }
        
        dispatchGroup.wait()
        
        if let apiError = apiError {
            completion(.error(apiError))
            return
        }
        
        if let userId = loggedInUser?.id {
            dispatchGroup.enter()
            PledgeService().pledges(by: userId, at: locationId) { result in
                switch result {
                case .success(let pledges):
                    self.pledges = pledges
                case .error(let error):
                    self.pledges = []
                    apiError = error
                }
                dispatchGroup.leave()
            }
        }
        
        dispatchGroup.wait()
        
        if let apiError = apiError {
            completion(.error(apiError))
            return
        }

        completion(.success(()))
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
    
    func pledge(_ pledge: Pledge, with completion: @escaping ((Result<Void>) -> Void)) {
        PledgeService().pledge(pledge) { result in
            completion(result)
        }
    }
    
    func isEditable(at indexPath: IndexPath) -> Bool {
        guard indexPath != expandedIndexPath else {
                return false
        }
        return isAdminForLocation
    }
    
    func updateNeedsFilter(with completion: @escaping ((Result<Void>) -> Void)) {
        disabledNeedsHidden = !disabledNeedsHidden
        
        fetchNeeds { result in
            switch result {
            case .success:
                completion(.success(()))
            case .error(let error):
                completion(.error(error))
            }
        }
    }
}

// MARK: - TableViewModelable
extension NeedsViewModel: TableViewModelable {
    var numberOfSections: Int {
        return 1
    }
    
    func numberOfRows(in section: Int) -> Int {
        let needsCount: Int
        
        if disabledNeedsHidden {
            needsCount = needs.filter({ !$0.disabled }).count
        } else {
            needsCount = needs.count
        }
        
        if expandedIndexPath != nil {
            return needsCount + 1
        }

        return needsCount
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
            let need = needs[indexPath.row]
            let pledge = pledges.first(where: { $0.needId == need.id }) ?? nil
            cell.viewModel = NeedCellViewModel(need: need, pledge: pledge)
        }
        
        return cell
    }
}
