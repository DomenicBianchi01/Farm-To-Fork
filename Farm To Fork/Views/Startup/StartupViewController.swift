//
//  StartupViewController.swift
//  Farm To Fork
//
//  Created by Domenic Bianchi on 2018-03-09.
//  Copyright © 2018 Domenic Bianchi & Marshall Asch. All rights reserved.
//

import UIKit
import Valet
import LocalAuthentication

final class StartupViewController: UIViewController {
    // MARK: - IBOutlets
    @IBOutlet private var progressView: UIProgressView!
    
    // MARK: - Properties
    private let viewModel = StartupViewModel()
    
    // MARK: - Lifecycle Functions
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        guard loggedInUser == nil, let username = Valet.F2FValet.string(forKey: Constants.username), let password = Valet.F2FValet.string(forKey: Constants.password) else {
            self.performSegue(withIdentifier: Constants.Segues.loginStart, sender: self)
            return
        }
        
        authenticateUser { result in
            DispatchQueue.main.async {
                switch result {
                case .success:
                    self.login(email: username, password: password)
                case .error:
                    self.performSegue(withIdentifier: Constants.Segues.loginStart, sender: self)
                }
            }
        }
    }
    
    // MARK: - Helper Functions
    @objc private func updateProgressView() {
        self.progressView.progress += 1.0 / 15.0
    }
    
    private func login(email: String, password: String) {
        progressView.isHidden = false
        let timer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(updateProgressView), userInfo: nil, repeats: true)
        AuthenticationService().login(email: email, password: password) { result in
            DispatchQueue.main.async {
                timer.invalidate()
                self.progressView.progress = 1.0
                switch result {
                case .success (let user):
                    loggedInUser = user
                    self.performSegue(withIdentifier: Constants.Segues.loginStart, sender: self)
                case .error:
                    self.performSegue(withIdentifier: Constants.Segues.loginStart, sender: self)
                }
            }
        }
    }
    
    private func authenticateUser(with completion: @escaping (Result<Void>) -> Void) {
        guard let authenticationMethod = viewModel.authenticationMethod else {
            completion(.error(NSError(domain: "Could not resolve authentication method.", code: 0, userInfo: nil)))
            return
        }
        
        if authenticationMethod == .autoLogin {
            completion(.success(()))
        } else if authenticationMethod == .biometric {
            let context = LAContext()
            if context.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: nil) {
                context.evaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, localizedReason: "Identify yourself to access the app!") { (success, authenticationError) in
                    if success {
                        completion(.success(()))
                    } else {
                        completion(.error(authenticationError ?? NSError(domain: "Could not authenticate", code: 0, userInfo: nil)))
                    }
                }
            } else {
                completion(.error(NSError(domain: "Could not authenticate", code: 0, userInfo: nil)))
            }
        } else {
            completion(.error(NSError(domain: "Password required", code: 0, userInfo: nil)))
        }
    }
}
