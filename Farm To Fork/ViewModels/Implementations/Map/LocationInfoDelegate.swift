//
//  LocationInfoDelegate.swift
//  Farm To Fork
//
//  Created by Domenic Bianchi on 2018-03-26.
//  Copyright © 2018 Domenic Bianchi & Marshall Asch. All rights reserved.
//

import Foundation

protocol LocationInfoDelegate: class {
    func directionsRequested(to location: Location)
    func viewNeeds(for location: Location)
}
