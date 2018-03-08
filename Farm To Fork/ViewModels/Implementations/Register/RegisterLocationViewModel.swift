//
//  RegisterLocationViewModel.swift
//  Farm To Fork
//
//  Created by Domenic Bianchi on 2018-03-08.
//  Copyright © 2018 Domenic Bianchi & Marshall Asch. All rights reserved.
//

import Foundation

final class RegisterLocationViewModel {
    // MARK: - Properties
    let registerService = RegisterService()
    var countries: [String] = []
    var provinces: [String] = []
    var cities: [String] = []
    
    // MARK: - Enums
    enum PickerType: Int {
        case country = 1
        case province
        case city
    }
    
    init() {
        registerService.fetchCountries { result in
            switch result {
            case .success(let countries):
                self.countries = countries
            default:
                break
            }
        }
    }
    
    var numberOfComponents: Int {
        return 1
    }
    
    func numberOfRows(for picker: PickerType) -> Int {
        switch picker {
        case .country:
            return countries.count
        case .province:
            return provinces.count
        case .city:
            return cities.count
        }
    }
    
    func title(for row: Int, in component: Int, for picker: PickerType) -> String {
        switch picker {
        case .country:
            return countries[row]
        case .province:
            return provinces[row]
        case .city:
            return cities[row]
        }
    }
}
