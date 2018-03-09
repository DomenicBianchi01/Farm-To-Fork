//
//  LoginViewController.swift
//  Farm To Fork
//
//  Created by Domenic Bianchi on 2018-02-13.
//  Copyright © 2018 Domenic Bianchi & Marshall Asch. All rights reserved.
//

import UIKit
import MaterialTextField

final class LoginViewController: UIViewController {
    // MARK: - IBOutlets
    @IBOutlet private var usernameTextField: MFTextField!
    @IBOutlet private var passwordTextField: MFTextField!
    @IBOutlet var loginButton: UIButton!
    @IBOutlet var registerButton: UIButton!
    @IBOutlet var loginErrorLabel: UILabel!
    
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
                self.performSegue(withIdentifier: "goToMapFromLogin", sender: self)
            case .error(let error):
                self.displayErrorAlert(with: error.description)
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
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        textField.resignFirstResponder()
        if textField == usernameTextField {
            viewModel.updateEmail(email: textField.text ?? "")
        } else {
            viewModel.updatePassword(password: textField.text ?? "")
        }
    }
}
