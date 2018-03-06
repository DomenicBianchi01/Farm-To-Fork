//
//  Interactable.swift
//  Farm To Fork
//
//  Created by Domenic Bianchi on 2018-03-05.
//  Copyright © 2018 Domenic Bianchi & Marshall Asch. All rights reserved.
//

import Foundation

protocol Interactable {
    /// This function should be used to execute business logic and possibly call data providers to make network calls.
    func doAction(with completion: @escaping (Result<Any>) -> Void)
}
