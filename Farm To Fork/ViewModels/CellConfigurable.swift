//
//  CellConfigurable.swift
//  Farm To Fork
//
//  Created by Domenic Bianchi on 2018-09-23.
//  Copyright © 2018 Domenic Bianchi. All rights reserved.
//

import Foundation

protocol CellConfigurable {
    var viewModel: CellViewModelable? { get set }
    var delegate: NewNeedDelegate? { get set } //TODO: Get this out of here!!!!!
}
