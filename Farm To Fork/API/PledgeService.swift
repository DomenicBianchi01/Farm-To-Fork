//
//  PledgeService.swift
//  Farm To Fork
//
//  Created by Domenic Bianchi on 2018-03-18.
//  Copyright © 2018 Domenic Bianchi & Marshall Asch. All rights reserved.
//

import Foundation

final class PledgeService: JSONService {
    /// NOTE: Calling this function does nothing since the Pledge API does not yet exist. Function parameters will be added once the API is created.
    func makePledge(with completion: @escaping ((Result<Void>) -> Void)) {
        completion(.error(NSError(domain: "The Pledge API does not yet exist", code: 0, userInfo: nil)))
    }
}
