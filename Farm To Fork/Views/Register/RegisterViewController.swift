//
//  RegisterViewController.swift
//  Farm To Fork
//
//  Created by Domenic Bianchi on 2018-03-07.
//  Copyright © 2018 Domenic Bianchi & Marshall Asch. All rights reserved.
//

import UIKit
import TextFieldEffects

final class RegisterViewController: UIViewController {
    // MARK: - IBOutlets
    @IBOutlet var continueButton: UIButton!
    @IBOutlet var backButton: UIButton!
    @IBOutlet var firstNameTextField: IsaoTextField!
    @IBOutlet var lastNameTextField: IsaoTextField!
    @IBOutlet var emailTextField: IsaoTextField!
    @IBOutlet var passwordTextField: IsaoTextField!
    @IBOutlet var reenterTextField: IsaoTextField!
    
    // MARK: - Lifecycle Functions
    override func viewDidLoad() {
        super.viewDidLoad()
        
        continueButton.layer.borderColor = UIColor.white.cgColor
        backButton.layer.borderColor = UIColor.white.cgColor
        
        firstNameTextField.delegate = self
        lastNameTextField.delegate = self
        emailTextField.delegate = self
        passwordTextField.delegate = self
        reenterTextField.delegate = self
    }
    
    override func unwind(for unwindSegue: UIStoryboardSegue, towardsViewController subsequentVC: UIViewController) {
        let segue = UnwindRegisterAccountSegue(identifier: unwindSegue.identifier, source: unwindSegue.source, destination: unwindSegue.destination)
        segue.perform()
    }
}

// MARK: - UITextFieldDelegate
extension RegisterViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        if textField == firstNameTextField {
            lastNameTextField.becomeFirstResponder()
        } else if textField == lastNameTextField {
            emailTextField.becomeFirstResponder()
        } else if textField == emailTextField {
            passwordTextField.becomeFirstResponder()
        } else if textField == passwordTextField {
            reenterTextField.becomeFirstResponder()
        } else if textField == reenterTextField {
            //TODO
        }
        
        return true
    }
}
