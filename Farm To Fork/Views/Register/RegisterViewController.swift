//
//  RegisterViewController.swift
//  Farm To Fork
//
//  Created by Domenic Bianchi on 2018-03-07.
//  Copyright © 2018 Domenic Bianchi & Marshall Asch. All rights reserved.
//

import UIKit
import MaterialTextField

final class RegisterViewController: UIViewController {
    // MARK: - IBOutlets
    @IBOutlet private var continueButton: UIButton!
    @IBOutlet private var backButton: UIButton!
    @IBOutlet private var firstNameTextField: MFTextField!
    @IBOutlet private var lastNameTextField: MFTextField!
    @IBOutlet private var emailTextField: MFTextField!
    @IBOutlet private var passwordTextField: MFTextField!
    @IBOutlet private var reenterTextField: MFTextField!
    
    // MARK: - Properties
    private let viewModel = RegisterViewModel()
    
    // MARK: - Lifecycle Functions
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // A gesture recognizer that will dismiss the keyboard if the screen is tapped
        let tapRecognizer = UITapGestureRecognizer(target: self, action: #selector(dismissFirstResponder))
        view.addGestureRecognizer(tapRecognizer)
        
        continueButton.layer.borderColor = UIColor.white.cgColor
        backButton.layer.borderColor = UIColor.white.cgColor
        
        firstNameTextField.delegate = self
        lastNameTextField.delegate = self
        emailTextField.delegate = self
        passwordTextField.delegate = self
        reenterTextField.delegate = self
        
        passwordTextField.errorColor = .white
    }
    
    override func unwind(for unwindSegue: UIStoryboardSegue, towardsViewController subsequentVC: UIViewController) {
        let segue = UnwindRegisterAccountSegue(identifier: unwindSegue.identifier, source: unwindSegue.source, destination: unwindSegue.destination)
        segue.perform()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let registerLocationVC = segue.destination as? RegisterLocationViewController else {
            return
        }
        registerLocationVC.viewModel.user = viewModel.user
    }
    
    // MARK: - IBActions
    @IBAction func unwindToRegisterViewController(segue: UIStoryboardSegue) {}
    
    @IBAction func textFieldDidChange(_ sender: UITextField) {
        textFieldDidChange(textField: sender)
    }
    
    // MARK: - Helper Functions
    private func textFieldDidChange(textField: UITextField) {
        if textField == passwordTextField {
            let password1 = textField.text ?? ""
            let password2 = reenterTextField.text ?? "2"
            viewModel.updatePasswordElements(textField.text ?? "")
            if viewModel.passwordIsValid {
                removePasswordRequirementsError()
            } else {
                setPasswordRequirementsError()
            }
            
            if viewModel.verify(password1: password1, password2: password2) {
                removePasswordMismatchError()
            } else {
                setPasswordMismatchError()
            }
        } else if textField == reenterTextField {
            let password1 = textField.text ?? "1"
            let password2 = passwordTextField.text ?? "2"
            if viewModel.update(password1: password1, password2: password2) {
                removePasswordMismatchError()
            } else {
                setPasswordMismatchError()
            }
        } else if textField == firstNameTextField {
            viewModel.update(firstName: textField.text ?? "")
        } else if textField == lastNameTextField {
            viewModel.update(lastName: textField.text ?? "")
        } else if textField == emailTextField {
            viewModel.update(email: textField.text ?? "")
            guard let mfTextField = textField as? MFTextField else {
                return
            }
            if mfTextField.text?.isEmailAddress ?? false {
                mfTextField.removeInvalidEmailError()
            } else {
                mfTextField.setInvalidEmailError()
            }
        }
    }
}

// MARK: - UITextFieldDelegate
extension RegisterViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        passwordTextField.placeholder = "Password"
        if textField == firstNameTextField {
            lastNameTextField.becomeFirstResponder()
        } else if textField == lastNameTextField {
            emailTextField.becomeFirstResponder()
        } else if textField == emailTextField {
            passwordTextField.becomeFirstResponder()
        }
        
        return true
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        if textField == passwordTextField {
            if !viewModel.passwordIsValid {
                setPasswordRequirementsError()
            }
        }
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        if textField == firstNameTextField {
            viewModel.update(firstName: textField.text ?? "")
        } else if textField == lastNameTextField {
            viewModel.update(lastName: textField.text ?? "")
        } else if textField == emailTextField {
            viewModel.update(email: textField.text ?? "")
        } else if textField == passwordTextField {
            passwordTextField.setError(nil, animated: true)
        }
    }
    
    private func setPasswordRequirementsError() {
        passwordTextField.setError(viewModel.passwordRequirementsError, animated: true)
        passwordTextField.underlineColor = .red
    }
    
    private func removePasswordRequirementsError() {
        passwordTextField.setError(nil, animated: true)
        passwordTextField.underlineColor = .green
    }
    
    private func setPasswordMismatchError() {
        reenterTextField.setError(MFTextField.passwordMismatchError, animated: true)
        reenterTextField.underlineColor = .red
    }
    
    private func removePasswordMismatchError() {
        reenterTextField.setError(nil, animated: true)
        reenterTextField.underlineColor = .green
    }
}
