//
//  PledgeHistoryViewModel.swift
//  Farm To Fork
//
//  Created by Domenic Bianchi on 2018-10-29.
//  Copyright © 2018 Domenic Bianchi. All rights reserved.
//

import UIKit

final class PledgeHistoryViewModel {
    // MARK: - Properties
    private var pledges: [PledgeHistory] = []
    var dayRange: Int? = 7
    
    // MARK: - Helper Functions
    func fetchPledges(with completion: @escaping ((Result<Void>) -> Void)) {

        guard let userID = loggedInUser?.id else {
            completion(.error(NSError(domain: "No user logged in", code: 0, userInfo: nil)))
            return
        }

        PledgeService().pledges(by: userID, dayRange: dayRange) { result in
            switch result {
            case .success(let pledges):
                self.pledges = pledges
            case .error(let error):
                self.pledges = []
                completion(.error(error))
                return
            }
            completion(.success(()))
        }
    }
}

// MARK: - TableViewModelable
extension PledgeHistoryViewModel: TableViewModelable {
    var numberOfSections: Int {
        return 1
    }
    
    func numberOfRows(in section: Int) -> Int {
        return pledges.count
    }
    
    func cellForRow(in tableView: UITableView, at indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "pledgeReuseIdentifier", for: indexPath)
        
        if let cell = cell as? PledgeHistoryItemTableViewCell {
            cell.viewModel = PledgeHistoryCellViewModel(pledgeHistory: pledges[indexPath.row])
        }
        
        return cell
    }
}
