//
//  LoginViewController.swift
//  Farm To Fork
//
//  Created by Domenic Bianchi on 2018-02-13.
//  Copyright © 2018 Domenic Bianchi & Marshall Asch. All rights reserved.
//

import UIKit
import TextFieldEffects

//***TODO: ARE WE SUPPORTING PRIOR VERSIONS OF IOS? (ASK DAN!)***

final class LoginViewController: UIViewController {
    // MARK: - IBOutlets
    @IBOutlet private var usernameTextField: UITextField!
    @IBOutlet private var passwordTextField: UITextField!
    @IBOutlet var loginButton: UIButton!
    @IBOutlet var registerButton: UIButton!
    @IBOutlet var loginErrorLabel: UILabel!
    
    // MARK: - Properties
    private let viewModel = LoginViewModel()
    
    // MARK: - Lifecycle Functions
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // A gesture recognizer that will dismiss the keyboard if the screen is tapped
        let tapRecognizer = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        view.addGestureRecognizer(tapRecognizer)
        
        usernameTextField.delegate = self
        passwordTextField.delegate = self
        
        loginButton.layer.borderColor = UIColor.white.cgColor
        registerButton.layer.borderColor = UIColor.white.cgColor
    }

    // MARK: - IBActions
    @IBAction func loginButtonTapped(_ sender: Any) {
        attemptLogin()
    }
    
    @IBAction func registerButtonTapped(_ sender: Any) {
        
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
    
    /**
     Dismiss the keyboard from the screen.
     */
    @objc private func dismissKeyboard() {
        view.endEditing(true)
    }
    
    private func attemptLogin() {
        viewModel.attemptLogin() { result in
            switch result {
            case .success:
                break //Segue to map (login successful)
            case .error(let error):
                self.displayErrorAlert(with: error.customDescription)
            }
        }
    }
}

// MARK: - UITextFieldDelegate
extension LoginViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        if textField == usernameTextField {
            viewModel.updateEmail(email: textField.text ?? "")
            passwordTextField.becomeFirstResponder()
        } else {
            viewModel.updatePassword(password: textField.text ?? "")
            attemptLogin()
        }
        return true
    }
}
