//
//  ChangeEmailViewController.swift
//  Farm To Fork
//
//  Created by Domenic Bianchi on 2018-04-15.
//  Copyright © 2018 Domenic Bianchi. All rights reserved.
//

import UIKit
import MaterialTextField
import SwiftKeychainWrapper

final class ChangeEmailViewController: UIViewController {
    // MARK: - IBOutlets
    @IBOutlet private var currentAddressLabel: UILabel!
    @IBOutlet private var newAddressTextField: MFTextField!
    
    // MARK: - Properties
    private let viewModel = ChangeEmailViewModel()
    
    // MARK: - Lifecycle Functions
    override func viewDidLoad() {
        super.viewDidLoad()
        
        currentAddressLabel.text = KeychainWrapper.standard.string(forKey: Constants.username) ?? "Unknown"
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - IBActions
    @IBAction func textFieldDidChange(_ sender: Any) {
        guard let textField = sender as? MFTextField else {
            return
        }
        
        if textField.text?.isEmailAddress ?? false {
            textField.removeInvalidEmailError()
        } else {
            textField.setInvalidEmailError()
        }
    }
    
    @IBAction func saveChangesButtonTapped(_ sender: Any) {
        guard let newEmail = newAddressTextField.text else {
            return
        }
        
        viewModel.updateInfo(for: User(email: newEmail)) { result in
            switch result {
            case .success:
                //TODO
                break
            case .error(let error):
                self.displayAlert(title: "Error", message: error.customDescription)
            }
        }
    }
}
