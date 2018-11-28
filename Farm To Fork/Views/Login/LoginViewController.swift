//
//  LoginViewController.swift
//  Farm To Fork
//
//  Created by Domenic Bianchi on 2018-02-13.
//  Copyright © 2018 Domenic Bianchi & Marshall Asch. All rights reserved.
//

import UIKit
import MaterialTextField
import SCLAlertView
import Intents
import LocalAuthentication
import AudioToolbox
import UserNotifications

final class LoginViewController: UIViewController {
    // MARK: - IBOutlets
    @IBOutlet private var usernameTextField: MFTextField!
    @IBOutlet private var passwordTextField: MFTextField!
    @IBOutlet private var loginButton: ProgressButton!
    @IBOutlet private var registerButton: UIButton!
    @IBOutlet private var loginErrorLabel: UILabel!
    @IBOutlet private var splashBackgroundImageView: UIImageView!
    
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
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if loggedInUser != nil {
            view.alpha = 0
        } else {
            view.alpha = 1
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        usernameTextField.text = nil
        passwordTextField.text = nil
        
        DispatchQueue.main.async {
            self.splashBackgroundImageView.isHidden = true
            
            if loggedInUser != nil {
                self.scheduleNotification()
                self.performSegue(withIdentifier: Constants.Segues.loginToMap, sender: self)
            }
        }
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        usernameTextField.text = nil
        passwordTextField.text = nil
    }

    // MARK: - IBActions
    @IBAction func loginButtonTapped(_ sender: Any) {
        resignFirstResponder()
        attemptLogin()
    }
    
    @IBAction func unwindToViewController(segue: UIStoryboardSegue) {
        if segue.source.isKind(of: RegisterLocationViewController.self) {
            displaySCLAlert("Registration Complete", message: "You can now login to access Farm To Fork!", style: .success)
        }
    }
    
    @IBAction func textFieldDidChange(_ sender: UITextField) {
        textFieldDidChange(textField: sender)
    }
    
    // MARK: - Helper Functions
    private func scheduleNotification() {
        guard let newsletterDay = loggedInUser?.newsletterDay else {
            return
        }
        
        UNUserNotificationCenter.current().getNotificationSettings(completionHandler: { result in
            if result.authorizationStatus == .authorized {
                var notificationAlreadyPending = false
                let center = UNUserNotificationCenter.current()
                center.getPendingNotificationRequests(completionHandler: { (requests) in
                    for request in requests {
                        if request.identifier == "F2FLocationNotification" {
                            notificationAlreadyPending = true
                            break
                        }
                    }
                })
                
                if !notificationAlreadyPending {
                    let content = UNMutableNotificationContent()
                    content.title = "Are you going grocery shopping today?"
                    content.body = "Make sure to check out what some of your local EFP's need the most!"
                    content.sound = .default
                    
                    var dateInfo = DateComponents()
                    //8am on the user's newsletter day
                    dateInfo.day = newsletterDay
                    dateInfo.hour = 8
                    dateInfo.minute = 0
                    
                    let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 1, repeats: true)
                    let request = UNNotificationRequest(identifier: "F2FLocationNotification", content: content, trigger: trigger)
                    center.add(request) { _ in }
                }
            }
        })
    }
    
    private func displayError(message: String) {
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
        viewModel.attemptLogin { result in
            DispatchQueue.main.async {
                self.loginButton.hideActivityIndicator()
                switch result {
                case .success (let user):
                    self.viewModel.removePasswordFromKeychain()
                    self.viewModel.savePasswordToKeychain()
                    loggedInUser = user
                    self.scheduleNotification()
                    if self.viewModel.firstLogin {
                        self.promptForLoginPreferences()
                    } else {
                        self.performSegue(withIdentifier: Constants.Segues.loginToMap, sender: self)
                    }
                case .error(let error):
                    self.displayError(message: error.description)
                    AudioServicesPlayAlertSound(SystemSoundID(kSystemSoundID_Vibrate))
                }
            }
        }
    }
    
    private func promptForLoginPreferences() {
        let alert = UIAlertController(title: "Login", message: "Would you like to be automatically logged in each time you open this app?", preferredStyle: UIDevice.alertStyle)
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
        
        alert.popoverPresentationController?.sourceView = view
        alert.popoverPresentationController?.sourceRect = view.frame
        
        present(alert, animated: true, completion: nil)
    }
    
    private func promptForSiriKit() {
        DispatchQueue.main.async {
            if INPreferences.siriAuthorizationStatus() == .notDetermined {
                INPreferences.requestSiriAuthorization { _ in
                    self.performSegue(withIdentifier: Constants.Segues.loginToMap, sender: self)
                }
            } else {
                self.performSegue(withIdentifier: Constants.Segues.loginToMap, sender: self)
            }
        }
    }

    private func textFieldDidChange(textField: UITextField) {
        if textField == usernameTextField, let email = usernameTextField.text {
            viewModel.email = email
        } else if textField == passwordTextField, let password = passwordTextField.text {
            viewModel.password = password
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
