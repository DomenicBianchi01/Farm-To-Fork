//
//  CellViewModelable.swift
//  Farm To Fork
//
//  Created by Domenic Bianchi on 2018-09-23.
//  Copyright © 2018 Domenic Bianchi. All rights reserved.
//

import Foundation

/// This protocol assumes the cell will have up to three fields that display text.
protocol CellViewModelable {
    // MARK: - Properties
    /// The text for the primary UI element in the cell
    var title: String? { get }
    /// The text for the secondary UI element in the cell
    var description: String? { get }
    /// The text for the tertiary UI element in the cell
    var subDescription: String? { get }
    /// A unique string that can be used to identify which view model is being used
    var identifier: String { get }
    
    // MARK: - Functions
    func updateViewModel(with data: Any)
    func fetchData(with completion: @escaping ((Result<Void>) -> Void))
}

extension CellViewModelable {
    var title: String? { return nil }
    var description: String? { return nil }
    var subDescription: String? { return nil }
    
    func fetchData(with completion: @escaping ((Result<Void>) -> Void)) {
        completion(.error(NSError(domain: "Not implemented", code: 0, userInfo: nil)))
    }
}
