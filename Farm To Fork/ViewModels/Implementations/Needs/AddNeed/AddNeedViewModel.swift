//
//  AddNeedViewModel.swift
//  Farm To Fork
//
//  Created by Domenic Bianchi on 2018-09-23.
//  Copyright © 2018 Domenic Bianchi. All rights reserved.
//

import UIKit

final class AddNeedViewModel {
    // MARK: - Properties
    // Used when creating a new need. Also, init with properties we do not care about when creating a new need (we still need these values in the dictionary for the Need class init.
    private var needInfo: [String : Any] = [Need.Keys.id.rawValue : 0, Need.Keys.currentQuantity.rawValue : 0, Need.Keys.disabled.rawValue : false]

    // False if creating a new need, true if modifying an existing need
    private var isEditingNeed: Bool = false
    
    var name: String {
        if isEditingNeed {
            return "Edit Need"
        }
        return "Add Need"
    }
    
    // MARK: - Functions
    func needInformationUpdated(with newInfo: [String : Any]) {
        var newInfoMutable = newInfo
        if let unitId = newInfo[Need.Keys.units.rawValue] as? String, let unitIdInt = Int(unitId) {
            newInfoMutable[Need.Keys.units.rawValue] = Units(id: unitIdInt, name: "")
        } else if let categoryId = newInfo[Need.Keys.category.rawValue] as? String, let categoryIdInt = Int(categoryId) {
            newInfoMutable[Need.Keys.category.rawValue] = Category(id: categoryIdInt, name: "")
        }

        //https://developer.apple.com/documentation/swift/dictionary/2892855-merge
        needInfo.merge(newInfoMutable) { (_, new) in new }
    }

    func modifyNeed(with completion: @escaping ((Result<Void>) -> Void)) {
        guard let need = Need(dictionary: needInfo),
            let userLocationId = loggedInUser?.workerLocationId else {
            completion(.error(NSError(domain: "Could not create need.", code: 0, userInfo: nil)))
            return
        }
        
        let requestType: JSONService.RequestType
        
        if isEditingNeed {
            requestType = .put
        } else {
            requestType = .post
        }
        
        NeedsService().modify(need: need, forLocation: String(userLocationId), requestType: requestType) { result in
            completion(result)
        }
    }
    
    /// Using this function will change the behaviour of the app to the "modify need" workflow (vs "create need" workflow)
    func addNeed(_ need: Need) {
        isEditingNeed = true
        needInfo[Need.Keys.id.rawValue] = need.id
        needInfo[Need.Keys.name.rawValue] = need.name
        needInfo[Need.Keys.description.rawValue] = need.description
        needInfo[Need.Keys.units.rawValue] = need.units
        needInfo[Need.Keys.category.rawValue] = need.category
        needInfo[Need.Keys.targetQuantity.rawValue] = need.targetQuantity
        needInfo[Need.Keys.disabled.rawValue] = need.disabled
    }
}

extension AddNeedViewModel: TableViewModelable {
    var numberOfSections: Int {
        return 4
    }
    
    func numberOfRows(in section: Int) -> Int {
        if section == 0 || section == 2 {
            return 2
        }
        return 1
    }
    
    func titleForHeader(in section: Int) -> String? {
        if section == 1 {
            return "Target Quantity"
        } else if section == 2 {
            return "Attributes"
        }
        return nil
    }
    
    func titleForFooter(in section: Int) -> String? {
        if section == 3 {
            return "Disabling a need will remove it from the list of needs that the public can see. Needs cannot be deleted however disabling is the equivalent. A disabled need can be re-enabled at any time."
        }
        return nil
    }
    
    func cellForRow(in tableView: UITableView, at indexPath: IndexPath) -> UITableViewCell {
        let cellIdentifier: String
        let viewModel: CellViewModelable
        
        if indexPath.section == 0 && indexPath.row == 0 {
            cellIdentifier = "basicTextFieldReuseIdentifier"
            viewModel = AddNeedNameCellViewModel(name: needInfo[Need.Keys.name.rawValue] as? String)
        } else if indexPath.section == 0 {
            cellIdentifier = "basicTextFieldReuseIdentifier"
            viewModel = AddNeedDescriptionCellViewModel(description: needInfo[Need.Keys.description.rawValue] as? String)
        } else if indexPath.section == 1 {
            cellIdentifier = "stepperReuseIdentifier"
            viewModel = AddNeedQuantityCellViewModel(quantity: needInfo[Need.Keys.targetQuantity.rawValue] as? Int)
        } else if indexPath.section == 2 && indexPath.row == 0 {
            cellIdentifier = "pickerReuseIdentifier"
            viewModel = AddNeedCategoryCellViewModel(categoryId: (needInfo[Need.Keys.category.rawValue] as? Category)?.id)
        } else if indexPath.section == 2 {
            cellIdentifier = "pickerReuseIdentifier"
            viewModel = AddNeedUnitsCellViewModel(unitId: (needInfo[Need.Keys.units.rawValue] as? Units)?.id)
        } else {
            cellIdentifier = "switchReuseIdentifier"
            viewModel = AddNeedDisableCellViewModel(disabled: needInfo[Need.Keys.disabled.rawValue] as? Bool ?? false)
        }
        
        let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath)
        
        if var configurableCell = cell as? CellConfigurable {
            configurableCell.viewModel = viewModel
        }
        
        return cell
    }
}
