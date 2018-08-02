//
//  ChangePasswordViewController.swift
//  Farm To Fork
//
//  Created by Marshall Asch on 2018-03-15.
//  Copyright © 2018 Domenic Bianchi & Marshall Asch. All rights reserved.
//

import UIKit
import MaterialTextField
import Valet

final class ChangePasswordViewController: UIViewController {
	@IBOutlet var oldPass: MFTextField!
	@IBOutlet var newPass1: MFTextField!
	@IBOutlet var newPass2: MFTextField!
	
	@IBOutlet var save: UIButton!
	
	 private let viewModel = RegisterViewModel()
	
	
	// MARK: - Lifecycle Functions
	override func viewDidLoad() {
		super.viewDidLoad()
		
		// Do any additional setup after loading the view.
	}
	
	override func didReceiveMemoryWarning() {
		super.didReceiveMemoryWarning()
		// Dispose of any resources that can be recreated.
	}
	
	@IBAction func dismissKeyboard(_ sender: UISwipeGestureRecognizer) {
		self.view.endEditing(true)
	}
	
	@IBAction func save(_ sender: UIButton) {
		
		let oldPassword = oldPass.text ?? ""
		
		guard let username = Valet.F2FValet.string(forKey: Constants.username), let password = Valet.F2FValet.string(forKey: Constants.password) else {
			self.performSegue(withIdentifier: Constants.Segues.loginStart, sender: self)
			return
		}
		
		if viewModel.passwordIsValid && password == oldPassword {
			
			NSLog("Okay to change password")
			
			var user = User()
			
			user.email = username
			user.password = password
			
			let newPass = viewModel.user.password

			
			UpdateUserService().changePassword(user: user, newPass: newPass) { result in
				DispatchQueue.main.async {
					switch result {
					case .success:
						
						// update the stored password
                        Valet.F2FValet.set(string: newPass, forKey: Constants.password)
						
						// go back to the profile page
						self.performSegue(withIdentifier: "unwindToProfile", sender: self)
						
					case .error(let error):
						NSLog("Failed to change the password: \(error.description)")
						
						self.oldPass.shake()
						self.newPass1.shake()
						self.newPass2.shake()
					}
				}
			}
		}
		else {
			NSLog("Invalid Password Try again")
			
			self.oldPass.shake()
			self.newPass1.shake()
			self.newPass2.shake()
		}
		
		
	}
	@IBAction func textChanged(_ sender: UITextField) {
		
		textFieldDidChange(textField: sender)
	}
	
	
	private func textFieldDidChange(textField: UITextField) {
		
		if textField == oldPass {
			
		} else if textField == newPass1 {
			let newPassword1 = newPass1.text ?? "1"
			let newPassword2 = newPass2.text ?? "2"
			
			viewModel.updatePasswordElements(textField.text ?? "")
			
			// make sure it meets the requirements
			if viewModel.passwordIsValid {
				removePasswordRequirementsError()
			} else {
				setPasswordRequirementsError()
			}
			
			// make sure the passwords match
			if viewModel.verify(password1: newPassword1, password2: newPassword2) {
				removePasswordMismatchError()
			} else {
				setPasswordMismatchError()
			}
		} else if textField == newPass2 {
			let newPassword1 = newPass1.text ?? "1"
			let newPassword2 = newPass2.text ?? "2"
			
			if viewModel.update(password1: newPassword1, password2: newPassword2) {
				removePasswordMismatchError()
			} else {
				setPasswordMismatchError()
			}
		}
		
	}
	
	
	private func setPasswordRequirementsError() {
		newPass1.setError(viewModel.passwordRequirementsError, animated: true)
		newPass1.underlineColor = .red
	}
	
	private func removePasswordRequirementsError() {
		newPass1.setError(nil, animated: true)
		newPass1.underlineColor = .green
	}
	
	private func setPasswordMismatchError() {
		newPass2.setError(MFTextField.passwordMismatchError, animated: true)
		newPass2.underlineColor = .red
	}
	
	private func removePasswordMismatchError() {
		newPass2.setError(nil, animated: true)
		newPass2.underlineColor = .green
	}
}

