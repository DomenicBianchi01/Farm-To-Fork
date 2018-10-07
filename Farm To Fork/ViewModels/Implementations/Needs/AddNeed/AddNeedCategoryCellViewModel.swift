//
//  AddNeedCategoryCellViewModel.swift
//  Farm To Fork
//
//  Created by Domenic Bianchi on 2018-09-23.
//  Copyright © 2018 Domenic Bianchi. All rights reserved.
//

import Foundation

final class AddNeedCategoryCellViewModel {
    // MARK: - Properties
    private var categoryId: Int? = nil
    private var categories: [Category] = []
    
    // MARK: - Lifecycle Functions
    init(categoryId: Int? = nil) {
        self.categoryId = categoryId
    }
}

// MARK: - CellViewModelable
extension AddNeedCategoryCellViewModel: CellViewModelable {
    var string1: String? {
        guard let categoryId = categoryId else {
            return nil
        }
        return categories[categoryId-1].name
    }
    
    var string2: String? {
        return "Category"
    }

    var identifier: String {
        return Need.Keys.category.rawValue
    }
    
    func updateViewModel(with data: Any) {
        guard let id = data as? Int else {
            categoryId = nil
            return
        }
        categoryId = id + 1
    }
    
    func fetchData(with completion: @escaping ((Result<Void>) -> Void)) {
        NeedsService().fetchCategories { result in
            switch result {
            case .success(let categories):
                self.categories = categories
                completion(.success(()))
            case .error(let error):
                completion(.error(error))
            }
        }
    }
}

// MARK: - PickerViewModelable
extension AddNeedCategoryCellViewModel: PickerViewModelable {
    var numberOfComponents: Int {
        return 1
    }
    
    func numberOfRows(in component: Int) -> Int {
        return categories.count
    }
    
    func titleForRow(in component: Int, row: Int) -> String {
        if row < categories.count {
            return categories[row].name
        }
        return ""
    }
}
