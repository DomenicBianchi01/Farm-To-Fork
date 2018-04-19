//
//  ProfileViewModel.swift
//  Farm To Fork
//
//  Created by Domenic Bianchi on 2018-04-14.
//  Copyright © 2018 Domenic Bianchi. All rights reserved.
//

import UIKit

final class ProfileViewModel {
    
    // MARK: - Helper Functions
    func updateLoginPreference(_ preference: LoginPreference) {
        UserDefaults.appGroup?.set(preference.rawValue, forKey: Constants.loginPreference)
    }
}

extension ProfileViewModel: TableViewModelable {
    var numberOfSections: Int {
        return 4
    }
    
    func numberOfRows(in section: Int) -> Int {
        if section == 0 {
            return 3
        }
        return 1
    }
    
    func titleForHeader(in section: Int) -> String? {
        if section == 0 {
            return "Account"
        }
        return nil
    }
    
    func cellForRow(in tableView: UITableView, at indexPath: IndexPath) -> UITableViewCell {
        let reuseIdentifier: String
        
        if indexPath.section == 0 || indexPath.section == 1 {
            reuseIdentifier = "basicCellReuseIdentifier"
        } else if indexPath.section == 2 {
            reuseIdentifier = "logoutReuseIdentifier"
        } else {
            reuseIdentifier = "feedbackReuseIdentifier"
        }
        
        let cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifier, for: indexPath)
        
        if let cell = cell as? ProfileOptionTableViewCell {
            if indexPath.section == 0 {
                if indexPath.row == 0 {
                    cell.configure(with: "Edit personal information")
                } else if indexPath.row == 1 {
                    cell.configure(with: "Update account email address")
                } else {
                    cell.configure(with: "Change password")
                }
            } else {
                cell.configure(with: "Login Preferences")
            }
        }
        
        return cell
    }
}
