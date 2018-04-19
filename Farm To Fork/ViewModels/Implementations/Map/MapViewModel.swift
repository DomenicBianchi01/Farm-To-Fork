//
//  MapViewModel.swift
//  Farm To Fork
//
//  Created by Domenic Bianchi on 2018-03-10.
//  Copyright © 2018 Domenic Bianchi & Marshall Asch. All rights reserved.
//

import Foundation
import CoreLocation
import MapKit

final class MapViewModel {
    // MARK: - Properties
    private(set) var locations: [Location] = []
    private(set) var locationMarkers: [EFPMarker] = []
    
    // MARK: - Helper Functions
    func fetchEFPLocations(with completion: @escaping ((Result<Void>) -> Void)) {
        //TODO: DON'T HARDCODE CITY NUMBER
        LocationsService().fetchLocations(forCity: "150", generateCoordinates: true) { result in
            switch result {
            case .success(let locations):
                self.locations = locations
                NotificationCenter.default.post(name: .locationsFetched, object: nil, userInfo: [NotificationKeys.locations : locations])
                for location in locations {
                    guard let coordinates = location.coordinates else {
                        continue
                    }
                    self.locationMarkers.append(EFPMarker(title: location.name, coordinate: coordinates, id: location.id))
                }
                completion(.success(()))
            case .error(let error):
                completion(.error(error))
            }
        }
    }
    
    /**
     Using `MapKit`, calculate a route from and to the given coordinates using the specificed transport type (automobile or walking)
     
     - parameter startLocation: Where the route should start
     - parameter endLocation: Where the route should end
     - parameter transportType: The type of directions that should be calculated (automobile or walking)
     - parameter completion: The completion block called when the route is calculated. If the route was calculated successfully, a `MKDirectionsResponse` object is included in the response. If the calculation failed, the object is nil.
     */
    func calculateRoute(from startLocation: CLLocationCoordinate2D, to endLocation: CLLocationCoordinate2D, by transportType: MKDirectionsTransportType, completion: @escaping (MKDirectionsResponse?) -> Void) {
        
        let request = MKDirectionsRequest()
        request.source = MKMapItem(placemark: MKPlacemark(coordinate: startLocation, addressDictionary: nil))
        request.destination = MKMapItem(placemark: MKPlacemark(coordinate: endLocation, addressDictionary: nil))
        request.transportType = transportType
        
        MKDirections(request: request).calculate { response, error in
            guard let response = response, error == nil else {
                completion(nil)
                return
            }
            completion(response)
        }
    }
}

// MARK: - PickerViewModelable
extension MapViewModel: PickerViewModelable {
    func numberOfRows(in component: Int) -> Int {
        return locations.count
    }
    
    var numberOfComponents: Int {
        return 1
    }
}
