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
	@IBOutlet private var removeAccountButton: UIButton!
	
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
		loadSeetings()
		
		logoutButton.layer.cornerRadius = 10
		removeAccountButton.layer.cornerRadius = 10
		profilePhoto.image?.withRenderingMode(.alwaysTemplate)
		profilePhoto.tintColor = .blue
	}
	
	override func didReceiveMemoryWarning() {
		super.didReceiveMemoryWarning()
		// Dispose of any resources that can be recreated.
	}
	
    // MARK: - Helper Functions
	private func loadSeetings()
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
					
					self.settings = [
						Setting(label: "First Name", value: user.firstName, Setting.FieldType.TEXT),
						Setting(label: "Last Name", value: user.lastName, Setting.FieldType.TEXT),
						Setting(label: "Email", value: user.email, Setting.FieldType.EMAIL),
						Setting(label: "Password", value: user.password, Setting.FieldType.PASSWORD)]
					
					
				case .error(let error):
					self.settings = [
						Setting(label: "First Name", value: "temp", Setting.FieldType.TEXT),
						Setting(label: "Last Name", value: "temp", Setting.FieldType.TEXT),
						Setting(label: "Email", value: "temp", Setting.FieldType.EMAIL),
						Setting(label: "Password", value: "temp", Setting.FieldType.PASSWORD)]
				}
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
	@IBAction func deleteAccountAction(_ sender: UIButton) {
		
		let alert = UIAlertController(title: "Delete Account", message:"Warning! This action is permanent are you sure you want to continue?", preferredStyle: .alert)
		
		alert.addAction(UIAlertAction(title: NSLocalizedString("Cancel", comment: "Cancel action"), style: .cancel, handler: { _ in
			NSLog("Abort")
			//abort
		}))
		
		alert.addAction(UIAlertAction(title: NSLocalizedString("Delete", comment: "Delete action"), style: .destructive, handler: { _ in
			NSLog("Account deleted")
			//delete account
		}))
		
		self.present(alert, animated: true, completion: nil)
	}
	
	@IBAction func logoutAction(_ sender: UIButton) {
        let loginViewModel = LoginViewModel()
		loginViewModel.removePasswordFromKeychain()
        loginViewModel.disableLoginPreference()
		isLoggedIn = false
	}

}
