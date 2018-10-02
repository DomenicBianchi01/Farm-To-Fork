//
//  CellViewModelable.swift
//  Farm To Fork
//
//  Created by Domenic Bianchi on 2018-09-23.
//  Copyright © 2018 Domenic Bianchi. All rights reserved.
//

import Foundation

/// This protocol assumes the cell will have up two two fields that display text.
protocol CellViewModelable {
    // MARK: - Properties
    var title: String? { get }
    var subtitle: String? { get }
    /// A unique string that can be used to identify which view model is being used
    var identifier: String { get }
    
    // MARK: - Functions
    func updateViewModel(with data: Any)
    func fetchData(with completion: @escaping ((Result<Void>) -> Void))
}

extension CellViewModelable {
    func fetchData(with completion: @escaping ((Result<Void>) -> Void)) {
        completion(.error(NSError(domain: "Not implemented", code: 0, userInfo: nil)))
    }
}
