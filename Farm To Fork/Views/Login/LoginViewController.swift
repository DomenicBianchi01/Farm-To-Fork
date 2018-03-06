//
//  LoginViewController.swift
//  Farm To Fork
//
//  Created by Domenic Bianchi on 2018-02-13.
//  Copyright © 2018 Domenic Bianchi & Marshall Asch. All rights reserved.
//

import UIKit

//***TODO: ARE WE SUPPORTING PRIOR VERSIONS OF IOS? (ASK DAN!)***

final class LoginViewController: UIViewController {
    // MARK: - IBOutlets
    @IBOutlet private var usernameTextField: UITextField!
    @IBOutlet private var passwordTextField: UITextField!
    
    // MARK: - Lifecycle Functions
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - IBActions
    @IBAction func loginButtonTapped(_ sender: Any) {
        
    }
    
    @IBAction func registerButtonTapped(_ sender: Any) {
        
    }
}

