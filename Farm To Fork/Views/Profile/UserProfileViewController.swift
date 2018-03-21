//
//  UserProfileViewController.swift
//  Farm To Fork
//
//  Created by Marshall Asch on 2018-03-15.
//  Copyright © 2018 Domenic Bianchi & Marshall Asch. All rights reserved.
//

import UIKit
import SwiftKeychainWrapper

class UserProfileViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    // MARK: - IBOutlets
	@IBOutlet private var profilePhoto: UIImageView!
	@IBOutlet private var logoutButton: UIButton!
	@IBOutlet private var updateButton: UIButton!
	@IBOutlet var table: UITableView!

	var user:User = User()
	
	
	
	// MARK: - Properties
	private class Setting {
		var label:String
		var value:String
		
		enum FieldType {
			case TEXT
			case PASSWORD
			case ADDRESS
			case EMAIL
			
		}
		
		var type:FieldType
		
		init(label:String, value:String, _ type:FieldType)
		{
			self.label = label
			self.value = value
			self.type = type
		}
	}
	
	private var settings = [Setting]()
	private var sections = ["Account Information"]
	
    // MARK: - Lifecycle Functions
	override func viewDidLoad() {
		super.viewDidLoad()
		loadSettings()
		
		logoutButton.layer.cornerRadius = 10
		updateButton.layer.cornerRadius = 10
		profilePhoto.image?.withRenderingMode(.alwaysTemplate)
		profilePhoto.tintColor = .blue
	}
	
	override func didReceiveMemoryWarning() {
		super.didReceiveMemoryWarning()
		// Dispose of any resources that can be recreated.
	}
	
    // MARK: - Helper Functions
	private func loadSettings()
	{
		
		
		guard let username = KeychainWrapper.standard.string(forKey: Constants.username), let password = KeychainWrapper.standard.string(forKey: Constants.password) else {
			self.performSegue(withIdentifier: Constants.Segues.loginStart, sender: self)
			return
		}
		

		UpdateUserService().fetchUserData(email: username, pass: password){ result in
			DispatchQueue.main.async {
				switch result {
				case .success(var user):

					user.password = password
					
					self.user = user
					
					self.settings = [
						Setting(label: "First Name", value: user.firstName, Setting.FieldType.TEXT),
						Setting(label: "Last Name", value: user.lastName, Setting.FieldType.TEXT),
						Setting(label: "Email", value: user.email, Setting.FieldType.EMAIL),
						Setting(label: "Password", value: user.password, Setting.FieldType.PASSWORD)]
					
				case .error(let error):
					NSLog("Loading data failed \(error.description)")
					self.settings = [
						Setting(label: "First Name", value: "temp", Setting.FieldType.TEXT),
						Setting(label: "Last Name", value: "temp", Setting.FieldType.TEXT),
						Setting(label: "Email", value: "temp", Setting.FieldType.EMAIL),
						Setting(label: "Password", value: "temp", Setting.FieldType.PASSWORD)]
				}
				self.table.reloadData()
			}
		}
		
		
		
		
	}
	
    // MARK: - Table View Functions
	func numberOfSections(in tableView: UITableView) -> Int {
		return 1
	}
	
	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return settings.count
	}
	
	
	func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
		return sections[section]
	}
	
	
	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		var cellType = "textFieldCell"
		
		let setting = settings[indexPath.row]
		
		switch setting.type {
		case Setting.FieldType.TEXT:
			cellType = "textFieldCell"
			break
		case Setting.FieldType.PASSWORD:
			cellType = "passwordFieldCell"
			break
		case Setting.FieldType.EMAIL:
			cellType = "emailFieldCell"
			break
		default:
			break
		}
		
		let cell = tableView.dequeueReusableCell(withIdentifier: cellType, for: indexPath) as! SettingUITableViewCell;
		
		
		cell.label.text = setting.label
		cell.textField.text = setting.value
		
		return cell
	}
	
    // MARK: - IBActions
	@IBAction func save(_ sender: UIButton) {
		
		
		let firstName:String = (table.cellForRow(at: IndexPath(row: 0, section: 0)) as! SettingUITableViewCell ).textField.text!
		
		let lastName:String = (table.cellForRow(at: IndexPath(row: 1, section: 0)) as! SettingUITableViewCell ).textField.text!
		
		let email:String = (table.cellForRow(at: IndexPath(row: 2, section: 0)) as! SettingUITableViewCell ).textField.text!
		
		
		user.email = email
		user.firstName = firstName
		user.lastName = lastName
		
		
		UpdateUserService().updateUser(user: user){  result in
			DispatchQueue.main.async {
				switch result {
				case .success:
					NSLog("Success update")
				case .error:
					NSLog("Fail update")
				}
			}
		}
	}
	

	@IBAction func dismissKeyboard(_ sender: UISwipeGestureRecognizer) {
		self.view.endEditing(true)
	}
	
	@IBAction func logoutAction(_ sender: UIButton) {
        let loginViewModel = LoginViewModel()
		loginViewModel.removePasswordFromKeychain()
        loginViewModel.disableLoginPreference()
		isLoggedIn = false
	}

}
