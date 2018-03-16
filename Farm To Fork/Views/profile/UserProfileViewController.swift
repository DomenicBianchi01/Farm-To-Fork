//
//  UserProfileViewController.swift
//  Farm To Fork
//
//  Created by Marshall Asch on 2018-03-15.
//  Copyright © 2018 Domenic Bianchi & Marshall Asch. All rights reserved.
//

import UIKit

class UserProfileViewController: UIViewController,UITableViewDelegate,UITableViewDataSource {
	@IBOutlet var profilePhoto: UIImageView!
	@IBOutlet var logoutButton: UIButton!
	@IBOutlet var removeAccountButton: UIButton!
	
	
	class Setting {
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
	
	
	var settings = [Setting]()
	var sections = ["Account Information"]
	
	
	
	
	override func viewDidLoad() {
		super.viewDidLoad()
		loadSeetings()
		
		
		logoutButton.layer.cornerRadius = 10
		removeAccountButton.layer.cornerRadius = 10
		profilePhoto.image?.withRenderingMode(.alwaysTemplate)
		profilePhoto.tintColor = .blue
		
		
		// Do any additional setup after loading the view, typically from a nib.
	}
	
	override func didReceiveMemoryWarning() {
		super.didReceiveMemoryWarning()
		// Dispose of any resources that can be recreated.
	}
	
	func loadSeetings()
	{
		settings += [
			Setting(label: "First Name", value: "Marshall", Setting.FieldType.TEXT),
			Setting(label: "Last Name", value: "Asch", Setting.FieldType.TEXT),
			Setting(label: "Email", value: "masch@uoguelph.ca", Setting.FieldType.EMAIL),
			Setting(label: "Password", value: "Abcd1234", Setting.FieldType.PASSWORD)]
		
	}
	
	
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
		
		LoginViewModel().removePasswordFromKeychain()
		
	}
	
	
	
	@IBAction func passwordChange(_ sender: UITextField) {
		
		let alert = UIAlertController(title: "Change Password", message:"", preferredStyle: .alert)
		alert.addAction(UIAlertAction(title: NSLocalizedString("OK", comment: "Default action"), style: .`default`, handler: { _ in
			NSLog("The \"OK\" alert occured.")
			
			//check old pass is correct
			// check that the new passwords match
			
			let oldPass = alert.textFields![0].text!
			let newPass = alert.textFields![1].text!
			let confirmPass = alert.textFields![2].text!
			
			NSLog("oldPass = \(oldPass) \n new pass: \(newPass) \n confirmPass = \(confirmPass)")
			
			//update password
		}))
		alert.addAction(UIAlertAction(title: NSLocalizedString("Cancel", comment: "Cancel action"), style: .cancel, handler: { _ in
			NSLog("The \"OK\" alert occured.")
			//abort
		}))
		alert.addTextField { (textField) in
			textField.placeholder = "Old Password"
			if #available(iOS 11.0, *) {
				textField.textContentType = UITextContentType.password
			} else {
				// Fallback on earlier versions
			}
		}
		
		alert.addTextField { (textField) in
			textField.placeholder = "New Password"
			if #available(iOS 11.0, *) {
				textField.textContentType = UITextContentType.password
			} else {
				// Fallback on earlier versions
			}
		}
		alert.addTextField { (textField) in
			textField.placeholder = "Confirm Password"
			if #available(iOS 11.0, *) {
				textField.textContentType = UITextContentType.password
			} else {
				// Fallback on earlier versions
			}
		}
		self.present(alert, animated: true, completion: nil)
		
	}
	
	
}


