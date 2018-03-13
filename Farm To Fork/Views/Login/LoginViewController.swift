//
//  LoginViewController.swift
//  Farm To Fork
//
//  Created by Domenic Bianchi on 2018-02-13.
//  Copyright © 2018 Domenic Bianchi & Marshall Asch. All rights reserved.
//

import UIKit
import MaterialTextField
import Intents
import LocalAuthentication

final class LoginViewController: UIViewController {
    // MARK: - IBOutlets
    @IBOutlet private var usernameTextField: MFTextField!
    @IBOutlet private var passwordTextField: MFTextField!
    @IBOutlet private var loginButton: ProgressButton!
    @IBOutlet private var registerButton: UIButton!
    @IBOutlet private var loginErrorLabel: UILabel!
    
    // MARK: - Properties
    private let viewModel = LoginViewModel()
    
    // MARK: - Lifecycle Functions
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // A gesture recognizer that will dismiss the keyboard if the screen is tapped
        let tapRecognizer = UITapGestureRecognizer(target: self, action: #selector(dismissFirstResponder))
        view.addGestureRecognizer(tapRecognizer)
        
        usernameTextField.delegate = self
        passwordTextField.delegate = self
        
        loginButton.layer.borderColor = UIColor.white.cgColor
        registerButton.layer.borderColor = UIColor.white.cgColor
    }

    // MARK: - IBActions
    @IBAction func loginButtonTapped(_ sender: Any) {
        resignFirstResponder()
        attemptLogin()
    }
    
    @IBAction func unwindToViewController(segue: UIStoryboardSegue) {}
    
    @IBAction func textFieldDidChange(_ sender: UITextField) {
        textFieldDidChange(textField: sender)
    }
    
    // MARK: - Helper Functions
    
    /**
     Display an error alert on the screen.
     
     - parameter message: The error message to be displayed on the alert
     */
    private func displayErrorAlert(with message: String) {
        DispatchQueue.main.async {
            self.loginErrorLabel.text = message
            
            UIView.animate(withDuration: 0.5) {
                self.loginErrorLabel.alpha = 1.0
            }
            
            self.usernameTextField.shake()
            self.passwordTextField.shake()
        }
    }
    
    private func attemptLogin() {
        loginButton.showActivityIndicator()
        viewModel.attemptLogin() { result in
            DispatchQueue.main.async {
                self.loginButton.hideActivityIndicator()
                switch result {
                case .success:
                    self.viewModel.removePasswordFromKeychain()
                    self.viewModel.savePasswordToKeychain()
                    if self.viewModel.firstLogin {
                        self.promptForLoginPreferences()
                    } else {
                        self.performSegue(withIdentifier: "goToMapFromLogin", sender: self)
                    }
                case .error(let error):
                    self.displayErrorAlert(with: error.description)
                }
            }
        }
    }
    
    private func promptForLoginPreferences() {
        let alert = UIAlertController(title: "Login", message: "Would you like to be automatically logged in each time you open this app?", preferredStyle: .actionSheet)
        let yesAction = UIAlertAction(title: "Yes!", style: .default) { _ in
            self.viewModel.enableLoginPreference(.autoLogin)
            self.promptForSiriKit()
        }
        
        let passwordAction = UIAlertAction(title: "No, I want to enter my password each time", style: .default) { _ in
            self.viewModel.enableLoginPreference(.password)
            self.promptForSiriKit()
        }
        
        alert.addAction(yesAction)
        
        if LAContext().canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: nil) {
            let biometricsAction = UIAlertAction(title: "No, but enable Touch ID or Face ID", style: .default) { _ in
                self.viewModel.enableLoginPreference(.biometric)
                self.promptForSiriKit()
            }
            alert.addAction(biometricsAction)
        }
        
        alert.addAction(passwordAction)
        
        present(alert, animated: true, completion: nil)
    }
    
    private func promptForSiriKit() {
//        DispatchQueue.main.async {
//            if INPreferences.siriAuthorizationStatus() == .notDetermined {
//                INPreferences.requestSiriAuthorization() { _ in
//                    self.performSegue(withIdentifier: "goToMapFromLogin", sender: self)
//                }
//            } else {
//                self.performSegue(withIdentifier: "goToMapFromLogin", sender: self)
//            }
//        }
    }

    private func textFieldDidChange(textField: UITextField) {
        if textField == usernameTextField, let email = usernameTextField.text {
            viewModel.updateEmail(email: email)
        } else if textField == passwordTextField, let password = passwordTextField.text {
            viewModel.updatePassword(password: password)
        }
    }
}

// MARK: - UITextFieldDelegate
extension LoginViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        if textField == usernameTextField {
            passwordTextField.becomeFirstResponder()
        } else {
            attemptLogin()
        }
        return true
    }
}
