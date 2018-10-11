//
//  ExpandedNeedCellViewModel.swift
//  Farm To Fork
//
//  Created by Domenic Bianchi on 2018-10-04.
//  Copyright © 2018 Domenic Bianchi. All rights reserved.
//

import Foundation

final class ExpandedNeedCellViewModel {
    // MARK: - Properties
    private let need: Need
    
    // MARK: - Lifecycle Functions
    init(need: Need) {
        self.need = need
    }
}

// MARK: - CellViewModelable
extension ExpandedNeedCellViewModel: CellViewModelable {
    var title: String? {
        return "\(need.category.name) - \(need.units.name)"
    }
    
    // In the context of this view model, this property is used for the placeholder of the textfield
    var description: String? {
        return "\(need.currentQuantity) items pleged"
    }
    
    var subDescription: String? {
        if need.disabled {
            return "This item is not active. \(need.currentQuantity) items were pledged."
        } else if need.targetQuantity - need.currentQuantity > 0 {
            return "We need \(need.targetQuantity - need.currentQuantity) more to reach our goal of \(need.targetQuantity) items!"
        } else {
            return "We have reached our pledge goal of \(need.targetQuantity) items! You can still pledge if you wish!"
        }
    }
    
    var identifier: String {
        return "" /* Not used */
    }
    
    func updateViewModel(with data: Any) { /* Not used */ }
}
