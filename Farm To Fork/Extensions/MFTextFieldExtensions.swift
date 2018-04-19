//
//  MFTextFieldExtensions.swift
//  Farm To Fork
//
//  Created by Domenic Bianchi on 2018-04-15.
//  Copyright © 2018 Domenic Bianchi. All rights reserved.
//

import Foundation
import MaterialTextField

extension MFTextField {
    // MARK: - Properties
    static let passwordMismatchError = NSError(domain: "MFDemoErrorDomain", code: 100, userInfo: [NSLocalizedDescriptionKey: "Passwords do not match"])
    
    static let invalidEmailError = NSError(domain: "MFDemoErrorDomain", code: 101, userInfo: [NSLocalizedDescriptionKey: "Invalid email"])
    
    // MARK: - Helper Functions
    func setInvalidEmailError() {
        setError(MFTextField.invalidEmailError, animated: true)
        underlineColor = .red
    }
    
    func removeInvalidEmailError() {
        setError(nil, animated: true)
        underlineColor = .green
    }
}
