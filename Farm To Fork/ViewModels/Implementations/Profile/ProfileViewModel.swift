//
//  ProfileViewModel.swift
//  Farm To Fork
//
//  Created by Domenic Bianchi on 2018-04-14.
//  Copyright © 2018 Domenic Bianchi. All rights reserved.
//

import UIKit
import Valet
import MessageUI

final class ProfileViewModel {
    // MARK: - Properties
    var canSendMail = MFMailComposeViewController.canSendMail()
    
    // MARK: - Helper Functions
    func updateLoginPreference(_ preference: LoginPreference) {
        UserDefaults.appGroup?.set(preference.rawValue, forKey: Constants.loginPreference)
    }

    func logout() {
        Valet.F2FValet.removeAllObjects()
        UserDefaults.resetAppGroup()
        loggedInUser = nil
        //TODO: Call Logout API
    }
}

extension ProfileViewModel: TableViewModelable {
    var numberOfSections: Int {
        if canSendMail {
            return 4
        }
        return 3
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
        } else if indexPath.section == 2 && canSendMail {
            reuseIdentifier = "feedbackReuseIdentifier"
        } else {
            reuseIdentifier = "logoutReuseIdentifier"
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
