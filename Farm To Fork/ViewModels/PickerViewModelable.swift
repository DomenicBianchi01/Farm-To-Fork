//
//  PickerViewModelable.swift
//  Farm To Fork
//
//  Created by Domenic Bianchi on 2018-03-13.
//  Copyright © 2018 Domenic Bianchi & Marshall Asch. All rights reserved.
//

import Foundation

protocol PickerViewModelable {
    var numberOfComponents: Int { get }
    func numberOfRows(in component: Int) -> Int
}
