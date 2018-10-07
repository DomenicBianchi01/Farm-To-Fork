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
    var string1: String? { get }
    var string2: String? { get }
    var string3: String? { get }
    /// A unique string that can be used to identify which view model is being used
    var identifier: String { get }
    
    // MARK: - Functions
    func updateViewModel(with data: Any)
    func fetchData(with completion: @escaping ((Result<Void>) -> Void))
}

extension CellViewModelable {
    var string1: String? { return nil }
    var string2: String? { return nil }
    var string3: String? { return nil }
    
    func fetchData(with completion: @escaping ((Result<Void>) -> Void)) {
        completion(.error(NSError(domain: "Not implemented", code: 0, userInfo: nil)))
    }
}
