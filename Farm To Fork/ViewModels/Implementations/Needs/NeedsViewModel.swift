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
    private let needs = [""] //TODO
    
    // MARK: - Helper Functions
    func fetchNeeds(with completion: @escaping ((Result<Void>) -> Void)) {
        guard let locationId = UserDefaults.standard.string(forKey: Constants.preferredLocationId) else {
            completion(.error(NSError(domain: "No preferred location found", code: 0, userInfo: nil)))
            return
        }
        
        NeedsService().fetchNeeds(forLocation: locationId) { result in
            //TODO
        }
    }
    
}

// MARK: - TableViewModelable
extension NeedsViewModel: TableViewModelable {
    var numberOfSections: Int {
        return 1
    }
    
    func numberOfRows(in section: Int) -> Int {
        return needs.count
    }
    
    func cellForRow(in tableView: UITableView, at indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "NeedItemReuseIdentifier", for: indexPath) as? NeedItemTableViewCell else {
            return UITableViewCell()
        }
        
        //TODO: REMOVE HARDCODING
        cell.titleLabel.text = "BLAH"
        cell.subtitleLabel.text = "5 Needed of Blah..."
        
        return cell
    }
}
