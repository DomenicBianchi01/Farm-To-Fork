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

final class LoginViewController: UIViewController {
    // MARK: - IBOutlets
    @IBOutlet private var usernameTextField: MFTextField!
    @IBOutlet private var passwordTextField: MFTextField!
    @IBOutlet private var loginButton: UIButton!
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
        viewModel.attemptLogin() { result in
            switch result {
            case .success:
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
    
    private func promptForLoginPreferences() {
        DispatchQueue.main.async {
            let alert = UIAlertController(title: "Login", message: "Would you like to be automatically logged in each time you open this app?", preferredStyle: .actionSheet)
            let yesAction = UIAlertAction(title: "Yes!", style: .default) { _ in
                self.viewModel.enableLoginPreference(.autoLogin)
                self.promptForSiriKit()
            }
            let touchIdAction = UIAlertAction(title: "No, but enable Touch ID or Face ID", style: .default) { _ in
                self.viewModel.enableLoginPreference(.touchIdOrFaceId)
                self.promptForSiriKit()
            }
            let passwordAction = UIAlertAction(title: "No, I want to enter my password each time", style: .default) { _ in
                self.viewModel.enableLoginPreference(.password)
                self.promptForSiriKit()
            }
            
            alert.addAction(yesAction)
            alert.addAction(touchIdAction)
            alert.addAction(passwordAction)
            
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    private func promptForSiriKit() {
        DispatchQueue.main.async {
            if INPreferences.siriAuthorizationStatus() == .notDetermined {
                INPreferences.requestSiriAuthorization() { _ in
                    self.performSegue(withIdentifier: "goToMapFromLogin", sender: self)
                }
            } else {
                self.performSegue(withIdentifier: "goToMapFromLogin", sender: self)
            }
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
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        textField.resignFirstResponder()
        if textField == usernameTextField {
            viewModel.updateEmail(email: textField.text ?? "")
        } else {
            viewModel.updatePassword(password: textField.text ?? "")
        }
    }
}
