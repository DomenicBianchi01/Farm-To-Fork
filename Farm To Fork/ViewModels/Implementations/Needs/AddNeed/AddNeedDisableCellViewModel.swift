//
//  AddNeedDisableCellViewModel.swift
//  Farm To Fork
//
//  Created by Domenic Bianchi on 2018-10-07.
//  Copyright © 2018 Domenic Bianchi. All rights reserved.
//

import Foundation

final class AddNeedDisableCellViewModel {
    // MARK: - Properties
    private var disabled: Bool
    
    // MARK: - Lifecycle Functions
    init(disabled: Bool) {
        self.disabled = disabled
    }
}

extension AddNeedDisableCellViewModel: CellViewModelable {
    var title: String? {
        return "Disabled"
    }
    
    var description: String? {
        if disabled {
            return "1"
        } else {
            return "0"
        }
    }
    
    var identifier: String {
        return Need.Keys.disabled.rawValue
    }
    
    func updateViewModel(with data: Any) {
        guard let data = data as? Bool else {
            return
        }
        disabled = data
    }
}
