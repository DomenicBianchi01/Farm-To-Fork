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
    private var needs: [Need] = []
    var expandedIndexPath: IndexPath? = nil
    
    // MARK: - Helper Functions
    func fetchNeeds(with completion: @escaping ((Result<Void>) -> Void)) {
        guard let locationId = UserDefaults.standard.string(forKey: Constants.preferredLocationId) else {
            completion(.error(NSError(domain: "No preferred location found", code: 0, userInfo: nil)))
            return
        }
        
        NeedsService().fetchNeeds(forLocation: locationId) { result in
            switch result {
            case .success(let needs):
                self.needs = needs
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

        if let cell = cell as? NeedItemTableViewCell {
            cell.configure(for: needs[indexPath.row])
        } else if let cell = cell as? ExpandedNeedItemTableViewCell {
            cell.configure(for: needs[indexPath.row-1])
        }
        
        return cell
    }
}
