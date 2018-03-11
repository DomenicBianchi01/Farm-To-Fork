//
//  LoginPreferences.swift
//  Farm To Fork
//
//  Created by Domenic Bianchi on 2018-03-09.
//  Copyright © 2018 Domenic Bianchi & Marshall Asch. All rights reserved.
//

import Foundation

enum LoginPreference: Int {
    case touchIdOrFaceId = 1
    case password
    case autoLogin
}
