//
//  AddNeedUnitsCellViewModel.swift
//  Farm To Fork
//
//  Created by Domenic Bianchi on 2018-09-23.
//  Copyright © 2018 Domenic Bianchi. All rights reserved.
//

import Foundation

final class AddNeedUnitsCellViewModel {
    // MARK: - Properties
    private var unitId: Int? = nil
    private var units: [Units] = []
    
    // MARK: - Lifecycle Functions
    init(unitId: Int? = nil) {
        self.unitId = unitId
    }
}

// MARK: - CellViewModelable
extension AddNeedUnitsCellViewModel: CellViewModelable {
    var string1: String? {
        guard let unitId = unitId else {
            return nil
        }
        return units[unitId-1].name
    }
    
    var string2: String? {
        return "Units"
    }
    
    var identifier: String {
        return Need.Keys.units.rawValue
    }
    
    func updateViewModel(with data: Any) {
        guard let id = data as? Int else {
            unitId = nil
            return
        }
        unitId = id + 1
    }
    
    func fetchData(with completion: @escaping ((Result<Void>) -> Void)) {
        NeedsService().fetchUnits { result in
            switch result {
            case .success(let units):
                self.units = units
                completion(.success(()))
            case .error(let error):
                completion(.error(error))
            }
        }
    }
}

// MARK: - PickerViewModelable
extension AddNeedUnitsCellViewModel: PickerViewModelable {
    var numberOfComponents: Int {
        return 1
    }
    
    func numberOfRows(in component: Int) -> Int {
        return units.count
    }
    
    func titleForRow(in component: Int, row: Int) -> String {
        if row < units.count {
            return units[row].name
        }
        return ""
    }
}
