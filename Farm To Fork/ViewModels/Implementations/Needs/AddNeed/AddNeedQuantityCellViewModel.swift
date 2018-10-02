//
//  AddNeedQuantityCellViewModel.swift
//  Farm To Fork
//
//  Created by Domenic Bianchi on 2018-09-23.
//  Copyright © 2018 Domenic Bianchi. All rights reserved.
//

import Foundation

final class AddNeedQuantityCellViewModel {
    // MARK: - Properties
    var quantity = 0
    
    // MARK: - Lifecycle Functions
    init(quantity: Int? = nil) {
        self.quantity = quantity ?? 0
    }
}

// MARK: - CellViewModelable
extension AddNeedQuantityCellViewModel: CellViewModelable {
    var title: String? {
        if quantity == 0 {
            return nil
        }
        return String(quantity)
    }
    
    // In the context of this view model, this property is used for the placeholder of the textfield
    var subtitle: String? {
        return "Quantity"
    }
    
    var identifier: String {
        return Need.Keys.targetQuantity.rawValue
    }
    
    func updateViewModel(with data: Any) {
        guard let newQuantity = data as? Double else {
            return
        }
        quantity = Int(newQuantity)
    }
}

// MARK: - StepperViewModelable
extension AddNeedQuantityCellViewModel: StepperViewModelable {
    var stepperValue: Double {
        return Double(quantity)
    }
}
