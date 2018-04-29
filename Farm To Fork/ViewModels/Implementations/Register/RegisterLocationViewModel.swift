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
    private(set) var countries: [(key: String, value: String)] = [(key: "", value: "Loading...")]
    private(set) var provinces: [(key: String, value: String)] = [(key: "", value: "None")]
    private(set) var cities: [(key: String, value: String)] = [(key: "", value: "None")]
    
    var user = User()
    
    // MARK: - Enums
    enum PickerType: Int {
        case country = 1
        case province
        case city
    }
    
    // MARK: - Helper Functions
    func fetchCountries(with completion: @escaping (Result<Void>) -> Void) {
        registerService.fetchCountries { result in
            switch result {
            case .success(let countries):
                self.countries = countries
                completion(.success(()))
            case .error(let error):
                self.countries = [(key: "", value: "Error loading")]
                completion(.error(error))
            }
        }
    }
    
    func fetchProvinces(for countryRow: Int) {
        guard let countryCode = Int(countries[countryRow].key) else {
            return
        }
        registerService.fetchProvinces(for: countryCode) { result in
            switch result {
            case .success(let provinces):
                self.provinces = provinces
            case .error:
                self.provinces = [(key: "", value: "Error loading")]
            }
        }
    }
    
    func fetchCities(for provinceRow: Int) {
        guard let provinceCode = Int(provinces[provinceRow].key) else {
            return
        }
        registerService.fetchCities(for: provinceCode) { result in
            switch result {
            case .success(let cities):
                self.cities = cities
            case .error:
                self.cities = [(key: "", value: "Error loading")]
            }
        }
    }
    
    func registerUser(with completion: @escaping (Result<Void>) -> Void) {
        registerService.register(user: user) { result in
            completion(result)
        }
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
            return (row < countries.count) ? countries[row].value : "None"
        case .province:
            return (row < provinces.count) ? provinces[row].value : "None"
        case .city:
            return (row < cities.count) ? cities[row].value : "None"
        }
    }
    
    // MARK: - User Helper Functions
    func updateUserCountry(to countryRow: Int) {
        user.country = countries[countryRow]
    }
    
    func updateUserProvince(to provinceRow: Int) {
        user.province = provinces[provinceRow]
    }
    
    func updateUserCity(to cityRow: Int) {
        user.city = cities[cityRow]
    }
}

// MARK: - PickerViewModelable
extension RegisterLocationViewModel: PickerViewModelable {
    func numberOfRows(in component: Int) -> Int { /* Not used */ return 0 }
    
    var numberOfComponents: Int {
        return 1
    }
}
