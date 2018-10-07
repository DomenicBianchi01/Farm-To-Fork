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
    var string1: String? {
        return "\(need.category.name) - \(need.units.name)"
    }
    
    // In the context of this view model, this property is used for the placeholder of the textfield
    var string2: String? {
        return "\(need.currentQuantity) items pleged"
    }
    
    var string3: String? {
        if need.targetQuantity - need.currentQuantity > 0 {
           return "We need \(need.targetQuantity - need.currentQuantity) more to reach our goal of \(need.targetQuantity) items!"
        }
       return "We have reached our pledge goal of \(need.targetQuantity) items! You can still pledge if you wish!"
    }
    
    var identifier: String {
        return "" /* Not used */
    }
    
    func updateViewModel(with data: Any) { /* Not used */ }
}
