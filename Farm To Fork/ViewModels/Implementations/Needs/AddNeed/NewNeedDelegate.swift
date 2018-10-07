//
//  NewNeedDelegate.swift
//  Farm To Fork
//
//  Created by Domenic Bianchi on 2018-09-23.
//  Copyright © 2018 Domenic Bianchi. All rights reserved.
//

import Foundation

protocol NewNeedDelegate: class {
    func needInformationUpdated(with info: [String : Any])
}

protocol NewNeedDelgatable {
    var delegate: NewNeedDelegate? { get set }
}
