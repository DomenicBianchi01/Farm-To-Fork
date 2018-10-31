//
//  AccountViewModel.swift
//  Farm To Fork
//
//  Created by Domenic Bianchi on 2018-10-30.
//  Copyright © 2018 Domenic Bianchi. All rights reserved.
//

import UIKit

final class AccountViewModel {
    // MARK: - Properties
    private var userInfo: [String : Any] = [:]
    
    // MARK: - Lifecycle Functions
    init() {
        userInfo[User.Keys.email.rawValue] = loggedInUser?.email
        userInfo[User.Keys.firstName.rawValue] = loggedInUser?.firstName
        userInfo[User.Keys.lastName.rawValue] = loggedInUser?.lastName
        userInfo[User.Keys.newsletterDay.rawValue] = loggedInUser?.newsletterDay
    }

    // MARK: - Functions
    func updateUser(with completion: @escaping ((Result<Void>) -> Void)) {
        guard let user = User(encodingDictionary: userInfo) else {
            completion(.error(NSError(domain: "Email, first name, and last name are required.", code: 0, userInfo: nil)))
            return
        }

        UserService().updateUserDetails(user) { result in
            switch result {
            case .success(let user):
                loggedInUser = user
                completion(.success(()))
            case .error(let error):
                completion(.error(error))
            }
        }
    }
    
    func userInformationUpdated(with newInfo: [String : Any]) {
        var newInfoMutable = newInfo
        
        if let email = newInfo[User.Keys.email.rawValue] as? String {
            newInfoMutable[User.Keys.email.rawValue] = email
        } else if let firstName = newInfo[User.Keys.firstName.rawValue] as? String {
            newInfoMutable[User.Keys.firstName.rawValue] = firstName
        } else if let lastName = newInfo[User.Keys.lastName.rawValue] as? String {
            newInfoMutable[User.Keys.lastName.rawValue] = lastName
        } else if let newsletterDay = newInfo[User.Keys.newsletterDay.rawValue] as? Int {
            newInfoMutable[User.Keys.newsletterDay.rawValue] = newsletterDay
        }
        
        //https://developer.apple.com/documentation/swift/dictionary/2892855-merge
        userInfo.merge(newInfoMutable) { (_, new) in new }
    }
}

// MARK: - TableViewModelable
extension AccountViewModel: TableViewModelable {
    var numberOfSections: Int {
        return 3
    }
    
    func numberOfRows(in section: Int) -> Int {
        if section == 1 {
            return 2
        }
        return 1
    }
    
    func titleForHeader(in section: Int) -> String? {
        if section == 0 {
            return "Email"
        } else if section == 1 {
            return "Name"
        } else if section == 2 {
            return "Newsletter Day"
        }
        return nil
    }
    
    func titleForFooter(in section: Int) -> String? {
        if section == 2 {
            return "If you have location services enabled, this is the day you will receive a notification letting you know what \(UserDefaults.appGroup?.string(forKey: Constants.preferredLocationName) ?? "your local EFP") needs when you go grocery shopping"
        }
        return nil
    }
    
    func cellForRow(in tableView: UITableView, at indexPath: IndexPath) -> UITableViewCell {
        let reuseIdentifier: String
        let viewModel: CellViewModelable
        
        if indexPath.section == 0 {
            reuseIdentifier = "textReuseIdentifier"
            viewModel = AccountEmailViewModel(email: userInfo[User.Keys.email.rawValue] as? String)
        } else if indexPath.section == 1 && indexPath.row == 0 {
            reuseIdentifier = "textReuseIdentifier"
            viewModel = AccountFirstNameViewModel(firstName: userInfo[User.Keys.firstName.rawValue] as? String)
        } else if indexPath.section == 1 && indexPath.row == 1 {
            reuseIdentifier = "textReuseIdentifier"
            viewModel = AccountLastNameViewModel(lastName: userInfo[User.Keys.lastName.rawValue] as? String)
        } else {
            reuseIdentifier = "pickerReuseIdentifier"
            viewModel = AccountNewsletterDayViewModel(dayOfWeek: userInfo[User.Keys.newsletterDay.rawValue] as? Int)
        }
        
        let cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifier, for: indexPath)
        
        if var configurableCell = cell as? CellConfigurable {
            configurableCell.viewModel = viewModel
        }
        
        return cell
    }
}
