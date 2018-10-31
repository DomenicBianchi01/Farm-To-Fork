//
//  ProfileViewController.swift
//  Farm To Fork
//
//  Created by Domenic Bianchi on 2018-04-14.
//  Copyright © 2018 Domenic Bianchi. All rights reserved.
//

import UIKit
import LocalAuthentication
import MessageUI
import DeviceKit

final class ProfileViewController: UIViewController {
    // MARK: - IBOutlets
    @IBOutlet private var tableView: UITableView!
    
    // MARK: - Properties
    private let viewModel = ProfileViewModel()
    
    // MARK: - Lifecycle Functions
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if #available(iOS 11.0, *) {
            navigationController?.navigationBar.prefersLargeTitles = true
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    //TODO: Why is this not being called?
    override func unwind(for unwindSegue: UIStoryboardSegue, towards subsequentVC: UIViewController) {
        let segue = LogoutSegue(identifier: unwindSegue.identifier, source: unwindSegue.source, destination: unwindSegue.destination)
        segue.perform()
    }
    
    // MARK: - IBActions
    @IBAction func logoutButtonTapped(_ sender: Any) {
        viewModel.logout()
    }
    
    // MARK: - Helper Functions
    private func promptForFeedback() {
        if viewModel.canSendMail {
            let mail = MFMailComposeViewController()
            mail.mailComposeDelegate = self
            mail.setToRecipients(["dbianchi@uoguelph.ca"])
            mail.setSubject("Farm To Fork iOS Feedback")
            
            let appVersion = (Bundle.main.object(forInfoDictionaryKey: "CFBundleShortVersionString") as? String) ?? "Unknown"
            let operatingSystemVersion = ProcessInfo.processInfo.operatingSystemVersion
            
            mail.setMessageBody("""
                Enter your feedback here!
                \n------\n\n
                Version: \(appVersion) \n
                iOS \(operatingSystemVersion.majorVersion).\(operatingSystemVersion.minorVersion).\(operatingSystemVersion.patchVersion) (\(Device().description))
                """, isHTML: false)
            
            present(mail, animated: true)
        }
    }
}

// MARK: - MFMailComposeViewControllerDelegate
extension ProfileViewController: MFMailComposeViewControllerDelegate {
    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        controller.dismiss(animated: true)
    }
}

// MARK: - UITableViewDelegate
extension ProfileViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        defer {
            tableView.deselectRow(at: indexPath, animated: true)
        }
        
        if indexPath.section == 0 {
            performSegue(withIdentifier: Constants.Segues.pledgeHistory, sender: self)
        } else if indexPath.section == 1 {
            if indexPath.row == 0 {
                performSegue(withIdentifier: Constants.Segues.accountInfo, sender: self)
            } else {
                //TODO: Change password
            }
        } else if indexPath.section == 2 {
            let alertController = UIAlertController(title: "Login Preference", message: "Select one of the options below to change your login preference", preferredStyle: UIDevice.alertStyle)
            
            let autoAction = UIAlertAction(title: "Automatically log in", style: .default) { _ in
                self.viewModel.updateLoginPreference(.autoLogin)
            }
            
            let manualAction = UIAlertAction(title: "Manually enter password", style: .default) { _ in
                self.viewModel.updateLoginPreference(.password)
            }
            
            let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
            
            if LAContext().canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: nil) {
                let biometricAction = UIAlertAction(title: "Use Face ID or Touch ID", style: .default) { _ in
                    self.viewModel.updateLoginPreference(.biometric)
                }
                
                alertController.addAction(biometricAction)
            }
            
            alertController.addAction(autoAction)
            alertController.addAction(manualAction)
            alertController.addAction(cancelAction)
            
            alertController.popoverPresentationController?.sourceView = view
            alertController.popoverPresentationController?.sourceRect = view.frame
            
            present(alertController, animated: true, completion: nil)
        } else if indexPath.section == 3 {
            promptForFeedback()
        }
    }
}

// MARK: - UITableViewDataSource
extension ProfileViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return viewModel.numberOfSections
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.numberOfRows(in: section)
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return viewModel.titleForHeader(in: section)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return viewModel.cellForRow(in: tableView, at: indexPath)
    }
}
