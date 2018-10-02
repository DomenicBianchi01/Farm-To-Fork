//
//  AddNeedNameCellViewModel.swift
//  Farm To Fork
//
//  Created by Domenic Bianchi on 2018-09-23.
//  Copyright © 2018 Domenic Bianchi. All rights reserved.
//

import Foundation

final class AddNeedNameCellViewModel {
    // MARK: - Properties
    private var name: String? = nil
    
    // MARK: - Lifecycle Functions
    init(name: String? = nil) {
        self.name = name
    }
}

// MARK: - CellViewModelable
extension AddNeedNameCellViewModel: CellViewModelable {
    var title: String? {
        return name
    }
    
    // In the context of this view model, this property is used for the placeholder of the textfield
    var subtitle: String? {
        return "Name"
    }
    
    var identifier: String {
        return Need.Keys.name.rawValue
    }
    
    func updateViewModel(with data: Any) {
        name = data as? String
    }
}
