//
//  ChangePasswordViewController.swift
//  Farm To Fork
//
//  Created by Marshall Asch on 2018-03-15.
//  Copyright © 2018 Domenic Bianchi & Marshall Asch. All rights reserved.
//

import UIKit
import MaterialTextField

final class ChangePasswordViewController: UIViewController {
	@IBOutlet var oldPass: MFTextField!
	@IBOutlet var newPass1: MFTextField!
	@IBOutlet var newPass2: MFTextField!
	
	
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
		let newPassword1 = newPass1.text ?? "1"
		let newPasswrd2 = newPass2.text ?? "2"
		
		
		
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
		newPass2.setError(viewModel.passwordMismatchError, animated: true)
		newPass2.underlineColor = .red
	}
	
	private func removePasswordMismatchError() {
		newPass2.setError(nil, animated: true)
		newPass2.underlineColor = .green
	}
	
	
	
}

