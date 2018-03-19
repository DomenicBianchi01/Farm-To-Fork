//
//  PledgeDelegate.swift
//  Farm To Fork
//
//  Created by Domenic Bianchi on 2018-03-18.
//  Copyright © 2018 Domenic Bianchi & Marshall Asch. All rights reserved.
//

import Foundation

protocol PledgeDelegate: class {
    func pledgeRequested(for need: Need)
}
