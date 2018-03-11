//
//  StartupViewController.swift
//  Farm To Fork
//
//  Created by Domenic Bianchi on 2018-03-09.
//  Copyright © 2018 Domenic Bianchi & Marshall Asch. All rights reserved.
//

import UIKit
import SwiftKeychainWrapper

final class StartupViewController: UIViewController {
    // MARK: - IBOutlets
    @IBOutlet private var progressView: UIProgressView!
    
    // MARK: - Lifecycle Functions
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        guard let username = KeychainWrapper.standard.string(forKey: Constants.username), let password = KeychainWrapper.standard.string(forKey: Constants.password) else {
            self.performSegue(withIdentifier: Constants.Segues.loginStart, sender: self)
            return
        }
        
        let user = User(email: username, password: password)
        
        progressView.isHidden = false
        
        let timer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(updateProgressView), userInfo: nil, repeats: true)
        LoginService().login(user: user) { result in
            DispatchQueue.main.async {
                timer.invalidate()
                self.progressView.progress = 1.0
                switch result {
                case .success:
                    self.performSegue(withIdentifier: Constants.Segues.autoLoginStart, sender: self)
                case .error:
                    StartupViewModel().removeSavedCredentials()
                    self.performSegue(withIdentifier: Constants.Segues.loginStart, sender: self)
                }
            }
        }
    }
    
    // MARK: - Helper Functions
    @objc private func updateProgressView() {
        self.progressView.progress += 1.0 / 15.0
    }
}
