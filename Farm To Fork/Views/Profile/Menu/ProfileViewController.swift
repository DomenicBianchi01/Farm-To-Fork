//
//  ProfileViewController.swift
//  Farm To Fork
//
//  Created by Domenic Bianchi on 2018-04-14.
//  Copyright © 2018 Domenic Bianchi. All rights reserved.
//

import UIKit
import LocalAuthentication

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
        
        tableView.reloadData()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}

// MARK: - UITableViewDelegate
extension ProfileViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        defer {
            tableView.deselectRow(at: indexPath, animated: true)
        }
        if indexPath.section == 0 {
            if indexPath.row == 0 {
                performSegue(withIdentifier: Constants.Segues.personalInfo, sender: self)
            } else if indexPath.row == 1 {
                performSegue(withIdentifier: Constants.Segues.emailAddress, sender: self)
            }
        }
        if indexPath.section == 1 {
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
