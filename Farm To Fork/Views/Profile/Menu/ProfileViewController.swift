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
    private var currentPasswordField: UITextField? = nil
    private var newPasswordField: UITextField? = nil
    private var newPasswordField2: UITextField? = nil
    private var submitAction = UIAlertAction()
    
    // MARK: - Lifecycle Functions
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationController?.navigationBar.prefersLargeTitles = true
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
    
    @objc private func textFieldDidChange(_ textField: UITextField) {
        if currentPasswordField?.text?.isEmpty ?? true || newPasswordField?.text?.isEmpty ?? true || newPasswordField2?.text?.isEmpty ?? true {
            submitAction.isEnabled = false
        } else {
            submitAction.isEnabled = true
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
                let alert = UIAlertController(title: "Change Password", message: "Enter your current and new password below. The new password must meet the following requirements:\nAt least 8 characters, 1 number, 1 uppercase letter, and 1 lowercase letter", preferredStyle: .alert)
                
                let submitAction = UIAlertAction(title: "Submit", style: .default) { _ in
                    guard let newPassword = self.newPasswordField?.text else {
                        return
                    }
                    self.viewModel.changePassword(newPassword)
                }
                
                alert.addAction(submitAction)
                alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
                
                submitAction.isEnabled = false
                self.submitAction = submitAction
                
                alert.addTextField { addedTextField in
                    addedTextField.placeholder = "Current Password"
                    addedTextField.isSecureTextEntry = true
                    self.currentPasswordField = addedTextField
                }
                alert.addTextField { addedTextField in
                    addedTextField.placeholder = "New Password"
                    addedTextField.isSecureTextEntry = true
                    self.newPasswordField = addedTextField
                }
                alert.addTextField { addedTextField in
                    addedTextField.placeholder = "Re-enter New Password"
                    addedTextField.isSecureTextEntry = true
                    self.newPasswordField2 = addedTextField
                }
                
                currentPasswordField?.addTarget(self, action: #selector(ProfileViewController.textFieldDidChange(_:)), for: .editingChanged)
                newPasswordField?.addTarget(self, action: #selector(ProfileViewController.textFieldDidChange(_:)), for: .editingChanged)
                newPasswordField2?.addTarget(self, action: #selector(ProfileViewController.textFieldDidChange(_:)), for: .editingChanged)
                
                alert.popoverPresentationController?.sourceView = self.view
                alert.popoverPresentationController?.sourceRect = self.view.bounds
                
                self.present(alert, animated: true, completion: nil)
            }
        } else if indexPath.section == 2 {
            let alertController = UIAlertController(title: "Login Preference", message: "Select one of the options below to change your login preference", preferredStyle: UIDevice.alertStyle)
            
            let autoAction = UIAlertAction(title: "Automatically log in", style: .default) { _ in
                self.viewModel.updateLoginPreference(.autoLogin)
            }
            
            let manualAction = UIAlertAction(title: "Manually enter password", style: .default) { _ in
                self.viewModel.updateLoginPreference(.password)
            }
            
            if LAContext().canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: nil) {
                let biometricAction = UIAlertAction(title: "Use Face ID or Touch ID", style: .default) { _ in
                    self.viewModel.updateLoginPreference(.biometric)
                }
                
                alertController.addAction(biometricAction)
            }
            
            alertController.addAction(autoAction)
            alertController.addAction(manualAction)
            alertController.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
            
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
