//
//  AddNeedDescriptionCellViewModel.swift
//  Farm To Fork
//
//  Created by Domenic Bianchi on 2018-09-23.
//  Copyright © 2018 Domenic Bianchi. All rights reserved.
//

import Foundation

final class AddNeedDescriptionCellViewModel {
    // MARK: - Properties
    private var description: String? = nil
    
    // MARK: - Lifecycle Functions
    init(description: String? = nil) {
        self.description = description
    }
}

// MARK: - CellViewModelable
extension AddNeedDescriptionCellViewModel: CellViewModelable {
    var title: String? {
        return description
    }
    
    // In the context of this view model, this property is used for the placeholder of the textfield
    var subtitle: String? {
        return "Description"
    }
    
    var identifier: String {
        return Need.Keys.description.rawValue
    }
    
    func updateViewModel(with data: Any) {
        description = data as? String
    }
}
