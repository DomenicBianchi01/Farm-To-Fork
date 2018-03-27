//
//  LocationConfigurable.swift
//  Farm To Fork
//
//  Created by Domenic Bianchi on 2018-03-26.
//  Copyright © 2018 Domenic Bianchi & Marshall Asch. All rights reserved.
//

import UIKit

protocol LocationConfigurable: class {
    func configure(for location: Location)
    func configure(using string: String, and image: UIImage?)
}

extension LocationConfigurable {
    func configure(for location: Location) {}
    func configure(using string: String, and image: UIImage?) {}
}
