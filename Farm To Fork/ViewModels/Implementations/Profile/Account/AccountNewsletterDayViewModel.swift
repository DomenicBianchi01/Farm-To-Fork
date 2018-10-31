//
//  AccountNewsletterDayViewModel.swift
//  Farm To Fork
//
//  Created by Domenic Bianchi on 2018-10-31.
//  Copyright © 2018 Domenic Bianchi. All rights reserved.
//

import Foundation

final class AccountNewsletterDayViewModel {
    // MARK: - Properties
    private var newsletterDay: DayOfWeek?
    
    // MARK: - Enums
    private enum DayOfWeek: String, CaseIterable {
        case Monday
        case Tuesday
        case Wednesday
        case Thursday
        case Friday
        case Saturday
        case Sunday
    }
    
    // MARK: - Lifecycle Functions
    init(dayOfWeek: Int?) {
        guard let dayOfWeek = dayOfWeek else {
            self.newsletterDay = nil
            return
        }
        self.newsletterDay = DayOfWeek(rawValue: DayOfWeek.allCases[dayOfWeek].rawValue)
    }
}

extension AccountNewsletterDayViewModel: CellViewModelable {
    var title: String? {
        return newsletterDay?.rawValue
    }
    
    var description: String? {
        return "Newsletter Day"
    }
    
    var identifier: String {
        return User.Keys.newsletterDay.rawValue
    }
    
    func updateViewModel(with data: Any) {
        guard let data = data as? Int else {
            return
        }
        newsletterDay = DayOfWeek.init(rawValue: DayOfWeek.allCases[data].rawValue)
    }
}

// MARK: - PickerViewModelable
extension AccountNewsletterDayViewModel: PickerViewModelable {
    var numberOfComponents: Int {
        return 1
    }
    
    func numberOfRows(in component: Int) -> Int {
        return DayOfWeek.allCases.count
    }
    
    func titleForRow(in component: Int, row: Int) -> String {
        return DayOfWeek.allCases[row].rawValue
    }
}
