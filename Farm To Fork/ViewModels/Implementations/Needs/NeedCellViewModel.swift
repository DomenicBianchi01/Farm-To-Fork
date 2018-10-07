//
//  NeedCellViewModel.swift
//  Farm To Fork
//
//  Created by Domenic Bianchi on 2018-10-04.
//  Copyright © 2018 Domenic Bianchi. All rights reserved.
//

import Foundation

final class NeedCellViewModel {
    // MARK: - Properties
    let need: Need
    
    // MARK: - Lifecycle Functions
    init(need: Need) {
        self.need = need
    }
}

// MARK: - CellViewModelable
extension NeedCellViewModel: CellViewModelable {
    var string1: String? {
        return need.name
    }
    
    // In the context of this view model, this property is used for the placeholder of the textfield
    var string2: String? {
        return need.description
    }
    
    var string3: String? {
        return "You have pledged 2 of this item" //TODO: This data should come from the Pledge API when it is created
    }
    
    var identifier: String {
        return "" /* Not used */
    }
    
    func updateViewModel(with data: Any) { /* Not used */ }
}
