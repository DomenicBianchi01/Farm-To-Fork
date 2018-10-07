//
//  EFPMarker.swift
//  Farm To Fork
//
//  Created by Domenic Bianchi on 2018-03-25.
//  Copyright © 2018 Domenic Bianchi & Marshall Asch. All rights reserved.
//

import Foundation
import MapKit

final class EFPMarker: NSObject, MKAnnotation {
    // MARK: - Properties
    let title: String?
    let coordinate: CLLocationCoordinate2D
    private let id: Int
    
    // MARK: - Lifecycle Functions
    init(title: String? = nil,
         coordinate: CLLocationCoordinate2D,
         id: Int) {
        self.title = title
        self.coordinate = coordinate
        self.id = id
    }
    
    // MARK: - Equatable
    override func isEqual(_ object: Any?) -> Bool {
        guard let location = object as? Location, let title = title else {
            return false
        }
        
        return location.name == title && location.id == id
    }
}
