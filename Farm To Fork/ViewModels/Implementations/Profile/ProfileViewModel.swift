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
import UserNotifications

final class ProfileViewModel {
    // MARK: - Properties
    var canSendMail = MFMailComposeViewController.canSendMail()
    
    // MARK: - Helper Functions
    func updateLoginPreference(_ preference: LoginPreference) {
        UserDefaults.appGroup?.set(preference.rawValue, forKey: Constants.loginPreference)
    }

    func logout() {
        AuthenticationService().logout { result in
            switch result {
            case .success:
                Valet.F2FValet.removeAllObjects()
                UserDefaults.resetAppGroup()
                loggedInUser = nil
                self.descheduleNotification()
            case .error:
                break //TODO
            }
        }
    }
    
    func changePassword(_ newPassword: String) {
        
    }
    
    private func descheduleNotification() {
        let center = UNUserNotificationCenter.current()
        center.removeAllPendingNotificationRequests()
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
            return 1
        } else if section == 1 {
            return 2
        }
        return 1
    }
    
    func titleForHeader(in section: Int) -> String? {
        if section == 0 {
            return "Pledges"
        } else if section == 1 {
            return "Account"
        }
        return nil
    }
    
    func cellForRow(in tableView: UITableView, at indexPath: IndexPath) -> UITableViewCell {
        let reuseIdentifier: String
        
        if indexPath.section == 0 || indexPath.section == 1 {
            reuseIdentifier = "basicCellReuseIdentifier"
        } else if indexPath.section == numberOfSections - 1 && canSendMail {
            reuseIdentifier = "feedbackReuseIdentifier"
        } else {
            reuseIdentifier = "logoutReuseIdentifier"
        }
        
        let cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifier, for: indexPath)
        
        if let cell = cell as? ProfileOptionTableViewCell {
            if indexPath.section == 0 {
                cell.configure(with: "Pledge History")
            } else if indexPath.section == 1 {
                if indexPath.row == 0 {
                    cell.configure(with: "Edit account information")
                } else {
                    cell.configure(with: "Login Preferences")
                }
            }
        }
        
        return cell
    }
}
