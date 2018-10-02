//
//  UserProfileViewController.swift
//  Farm To Fork
//
//  Created by Marshall Asch on 2018-03-15.
//  Copyright © 2018 Domenic Bianchi & Marshall Asch. All rights reserved.
//

import UIKit
import Valet

class UserProfileViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    // MARK: - IBOutlets
	@IBOutlet private var profilePhoto: UIImageView!
	@IBOutlet private var logoutButton: UIButton!
	@IBOutlet private var updateButton: UIButton!
	@IBOutlet private var table: UITableView!

	
	private var textField: UITextField? = nil
	private(set) var locations: [Location] = []	
	private let locationPickerView = UIPickerView()

	private var preferedLocation:Location? = nil
	//var user:User = User()
	
	// MARK: - Properties
	private class Setting {
		var label:String
		var value:String
		
		enum FieldType {
			case TEXT
			case PASSWORD
			case ADDRESS
			case EMAIL
			case PREFERED
			
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
		
		
        guard let username = Valet.F2FValet.string(forKey: Constants.username), let password = Valet.F2FValet.string(forKey: Constants.password) else {
            return
        }

		UpdateUserService().fetchUserData(email: username, pass: password){ result in
			DispatchQueue.main.async {
				switch result {
				case .success(var user):

					//user.password = password
					
					//self.user = user
					self.getEFPLocations()
					
					self.settings = [
						Setting(label: "First Name", value: user.firstName, Setting.FieldType.TEXT),
						Setting(label: "Last Name", value: user.lastName, Setting.FieldType.TEXT),
						Setting(label: "Email", value: user.email, Setting.FieldType.EMAIL),
						//Setting(label: "Password", value: user.password ?? "", Setting.FieldType.PASSWORD),
						Setting(label: "Prefered EFP", value: "location", Setting.FieldType.PREFERED)]
					
				case .error(let error):
					NSLog("Loading data failed \(error.description)")
					self.settings = [
						Setting(label: "First Name", value: "temp", Setting.FieldType.TEXT),
						Setting(label: "Last Name", value: "temp", Setting.FieldType.TEXT),
						Setting(label: "Email", value: "temp", Setting.FieldType.EMAIL),
						Setting(label: "Password", value: "temp", Setting.FieldType.PASSWORD),
						Setting(label: "Prefered EFP", value: "location", Setting.FieldType.PREFERED)]
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
		case Setting.FieldType.PREFERED:
			cellType = "locationFieldCell"
			break
		default:
			break
		}
		
//        let cell = tableView.dequeueReusableCell(withIdentifier: cellType, for: indexPath) as! SettingUITableViewCell;
//
//
//        cell.label.text = setting.label
//        cell.textField.text = setting.value
		
		return UITableViewCell()
	}
	
	func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		
		if indexPath.section == 0 && indexPath.row == 4 {
			promptForPreferredLocation()
		}
		
	}
	
    // MARK: - IBActions
	@IBAction func save(_ sender: UIButton) {
		
		
//        let firstName:String = (table.cellForRow(at: IndexPath(row: 0, section: 0)) as! SettingUITableViewCell ).textField.text!
//        let lastName:String = (table.cellForRow(at: IndexPath(row: 1, section: 0)) as! SettingUITableViewCell ).textField.text!
//        let email:String = (table.cellForRow(at: IndexPath(row: 2, section: 0)) as! SettingUITableViewCell ).textField.text!
//
//        self.setPreferredLocation(preferedLocation)
//
//        guard let username = KeychainWrapper.standard.string(forKey: Constants.username), let password = KeychainWrapper.standard.string(forKey: Constants.password) else {
//            return
//        }
//
//
//        user.email = username
//        user.password = password
//        user.firstName = firstName
//        user.lastName = lastName
//
//        self.settings[4].value = self.preferedLocation?.name ?? "Prefered Location";
//        self.table.reloadData()
//
//        NSLog("pass: \(password)")
//
//        UpdateUserService().updateUser(user: user, newEmail: email){  result in
//            DispatchQueue.main.async {
//                switch result {
//                case .success:
//                    NSLog("Success update")
//                case .error:
//                    NSLog("Fail update")
//                }
//            }
//		}
	}
	

	@IBAction func dismissKeyboard(_ sender: UISwipeGestureRecognizer) {
		self.view.endEditing(true)
	}
	
	@IBAction func logoutAction(_ sender: UIButton) {
        let loginViewModel = LoginViewModel()
		loginViewModel.removePasswordFromKeychain()
        loginViewModel.disableLoginPreference()
		loggedInUser = nil
	}
	
	
	@IBAction func unwindToProfile(sender: UIStoryboardSegue) {}
	

	func getEFPLocations()
	{
		
		LocationsService().fetchLocations(forCity: "150") {  result in
			DispatchQueue.main.async {
			switch result {
			case .success(let locations):
				self.locations = locations
				
				let locationID = UserDefaults.appGroup?.string(forKey: Constants.preferredLocationId)
				let locationName = UserDefaults.appGroup?.string(forKey: Constants.preferredLocationName)
				
				
				for  location in locations {
					if location.id == locationID {
						self.preferedLocation = location
					}
					
					
				}
				
				self.settings[4].value = self.preferedLocation?.name ?? "Prefered Location";
				self.table.reloadData()
				
				NSLog("Success get locatiosn")
			case .error(let error):
				NSLog("fail get locatiosn \(error.customDescription)")
			}
		}
		}
	}
	
	// MARK: - Helper Functions
	private func promptForPreferredLocation() {
		DispatchQueue.main.async {
			let alert = UIAlertController(title: "Preferred Location", message: "Please select your preferred Emergency Food Provider. You can change your preferred location at any time.", preferredStyle: .alert)
			let submitAction = UIAlertAction(title: "Save", style: .default) { _ in
				let selectedRow = self.locationPickerView.selectedRow(inComponent: 0)
			
					self.preferedLocation = self.locations[selectedRow]
			}
			/*let noLocationAction = UIAlertAction(title: "Can't find a location?", style: .default) { _ in
			//TODO: Display list from other cities
			}*/
			let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
			
			alert.addAction(submitAction)
			//alert.addAction(noLocationAction)
			alert.addAction(cancelAction)
			
			alert.addTextField { addedTextField in
				self.locationPickerView.delegate = self as UIPickerViewDelegate
				addedTextField.inputView = self.locationPickerView
				addedTextField.placeholder = "Preferred Location"
				addedTextField.delegate = self
				self.textField = addedTextField
			}
			
			self.present(alert, animated: true, completion: nil)
		}
	}
	
	
	func setPreferredLocation(_ location: Location?) {
		
		guard let location = location else {
			return
		}
		
		UserDefaults.appGroup?.set(location.id, forKey: Constants.preferredLocationId)
		UserDefaults.appGroup?.set(location.name, forKey: Constants.preferredLocationName)
	}

	}


// MARK: - UITextFieldDelegate
extension UserProfileViewController: UITextFieldDelegate {
	func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
		//Block all attempts to manually insert text into the text field. The only valid strings are ones that come from the `locationPickerView`
		return false
	}
}


// MARK: - UIPickerViewDataSource
extension UserProfileViewController: UIPickerViewDataSource {
	func numberOfComponents(in pickerView: UIPickerView) -> Int {
		return 1
	}
	
	func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
		return locations.count
	}
	
	func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
		return locations[row].name
	}
}
// MARK: - UIPickerViewDelegate
extension UserProfileViewController: UIPickerViewDelegate {
	func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
		if locations.count > row {
			textField?.text = locations[row].name
		}
	}
}
