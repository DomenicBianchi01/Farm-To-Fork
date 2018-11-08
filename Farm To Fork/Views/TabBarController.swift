//
//  TabBarController.swift
//  Farm To Fork
//
//  Created by Domenic Bianchi on 2018-04-18.
//  Copyright © 2018 Domenic Bianchi. All rights reserved.
//

import UIKit
import Intents

final class TabBarController: UITabBarController {
    // MARK: - Properties
    private let viewModel = TabBarViewModel()
    private var textField: UITextField? = nil

    // MARK: - Lifecycle Functions
    override func viewDidLoad() {
        super.viewDidLoad()
        
        NotificationCenter.default.addObserver(self, selector: #selector(locationsFetched(_:)), name:
            .locationsFetched, object: nil)
        
        refreshPreferredLocationTabBarItem()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    // MARK: - Helper Functions
    @objc private func locationsFetched(_ notification: Notification) {
        guard let locations = notification.userInfo?[NotificationKeys.locations] as? [Location] else {
                return
        }
        viewModel.locations = locations
    }
    
    private func refreshPreferredLocationTabBarItem() {
        guard let locationName = UserDefaults.appGroup?.string(forKey: Constants.preferredLocationName),
            let items = tabBar.items else {
                return
        }
        
        items[1].title = locationName
    }
    
    func promptForPreferredLocation() {
        let locationPickerView = UIPickerView()
        DispatchQueue.main.async {
            let alert = UIAlertController(title: "Preferred Location", message: "Please select your preferred Emergency Food Provider. You can change your preferred location at any time.", preferredStyle: .alert)
            let submitAction = UIAlertAction(title: "Save", style: .default) { _ in
                let selectedRow = locationPickerView.selectedRow(inComponent: 0)
                self.viewModel.setPreferredLocation(self.viewModel.locations[selectedRow])
                self.refreshPreferredLocationTabBarItem()
                NotificationCenter.default.post(name: .preferredLocationSet, object: nil, userInfo: nil)
            }
            /*let noLocationAction = UIAlertAction(title: "Can't find a location?", style: .default) { _ in
             //TODO: Display list from other cities?
             }*/
            let cancelAction = UIAlertAction(title: "Cancel", style: .cancel) { _ in
                if UserDefaults.appGroup?.integer(forKey: Constants.preferredLocationId) == nil {
                    self.selectedIndex = 0
                }
            }
            
            alert.addAction(submitAction)
            //alert.addAction(noLocationAction)
            alert.addAction(cancelAction)
            
            alert.addTextField { addedTextField in
                locationPickerView.delegate = self
                addedTextField.inputView = locationPickerView
                addedTextField.placeholder = "Preferred Location"
                addedTextField.delegate = self
                self.textField = addedTextField
            }
            
            alert.popoverPresentationController?.sourceView = self.view
            alert.popoverPresentationController?.sourceRect = self.view.bounds
            
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    // MARK: - UITabBarDelegate
    override func tabBar(_ tabBar: UITabBar, didSelect item: UITabBarItem) {
        guard let items = tabBar.items, items[1] == item else {
            return
        }

        if let locationName = viewModel.preferredLocationName {
            item.title = locationName

            //Siri Shortcuts
            if #available(iOS 12.0, *) {
                let activity = NSUserActivity(activityType: Constants.siriShortcutsIdentifier)
                activity.title = "View needs from preferred location"
                activity.userInfo = ["EFPName" : locationName]
                activity.isEligibleForSearch = true
                activity.isEligibleForPrediction = true
                activity.persistentIdentifier = Constants.siriShortcutsIdentifier
                view.userActivity = activity
                activity.becomeCurrent()
            }
        } else {
            promptForPreferredLocation()
        }
    }
}

// MARK: - UITextFieldDelegate
extension TabBarController: UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        //Block all attempts to manually insert text into the text field. The only valid strings are ones that come from the `locationPickerView`
        return false
    }
}

// MARK: - UIPickerViewDelegate
extension TabBarController: UIPickerViewDelegate {
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if viewModel.locations.count > row {
            textField?.text = viewModel.locations[row].name
        }
    }
}

// MARK: - UIPickerViewDataSource
extension TabBarController: UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return viewModel.numberOfComponents
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return viewModel.numberOfRows(in: component)
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return viewModel.titleForRow(in: component, row: row)
    }
}
