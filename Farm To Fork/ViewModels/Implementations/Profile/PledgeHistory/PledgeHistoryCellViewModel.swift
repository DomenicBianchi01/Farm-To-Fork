//
//  PledgeHistoryCellViewModel.swift
//  Farm To Fork
//
//  Created by Domenic Bianchi on 2018-10-29.
//  Copyright © 2018 Domenic Bianchi. All rights reserved.
//

import Foundation

final class PledgeHistoryCellViewModel {
    // MARK: - Properties
    let pledge: PledgeHistory
    
    var pledgeCount: String {
        return "\(pledge.pledged)\n pledged"
    }
    
    // MARK: - Lifecycle Functions
    init(pledgeHistory: PledgeHistory) {
        self.pledge = pledgeHistory
    }
}

// MARK: - CellViewModelable
extension PledgeHistoryCellViewModel: CellViewModelable {
    var title: String? {
        return pledge.needName
    }
    
    var description: String? {
        return pledge.needDescription
    }
    
    var subDescription: String? {
        return "Pledged for \(pledge.locationName) on \(pledge.pledgeDate)"
    }
    
    var identifier: String { return "" /* Not used */ }
    func updateViewModel(with data: Any) { /* Not used */ }
}
