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
    let pledge: Pledge?
    
    var needIsDisabled: Bool {
        return need.disabled
    }
    
    // MARK: - Lifecycle Functions
    init(need: Need, pledge: Pledge?) {
        self.need = need
        self.pledge = pledge
    }
}

// MARK: - CellViewModelable
extension NeedCellViewModel: CellViewModelable {
    var title: String? {
        return need.name
    }
    
    // In the context of this view model, this property is used for the placeholder of the textfield
    var description: String? {
        return need.description
    }
    
    var subDescription: String? {
        if need.disabled {
            return "This need is not active"
        } else if let pledge = pledge {
            return "You have pledged \(pledge.pledged) of this item"
        }
        return nil
    }
    
    var identifier: String { return "" /* Not used */ }
    func updateViewModel(with data: Any) { /* Not used */ }
}
