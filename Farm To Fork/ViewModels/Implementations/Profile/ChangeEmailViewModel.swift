//
//  ChangeEmailViewModel.swift
//  Farm To Fork
//
//  Created by Domenic Bianchi on 2018-04-16.
//  Copyright © 2018 Domenic Bianchi. All rights reserved.
//

import Foundation

final class ChangeEmailViewModel {
    // MARK: - Helper Function
    func updateInfo(for user: User, with completion: @escaping (Result<Void>) -> Void) {
        UpdateUserService().updateInfo(for: user) { result in
            switch result {
            case .success:
                completion(.success(()))
            case .error(let error):
                completion(.error(error))
            }
        }
    }
}
