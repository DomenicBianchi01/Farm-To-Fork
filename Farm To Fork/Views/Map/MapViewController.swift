//
//  MapViewController.swift
//  Farm To Fork
//
//  Created by Domenic Bianchi on 2018-03-10.
//  Copyright © 2018 Domenic Bianchi & Marshall Asch. All rights reserved.
//

import UIKit

final class MapViewController: UIViewController {
    // MARK: - Properties
    private let viewModel = MapViewModel()
    private let locationPickerView = UIPickerView()
    private var textField: UITextField? = nil
    
    // MARK: - Lifcycle Functions
    override func viewDidLoad() {
        super.viewDidLoad()
        
        viewModel.fetchEFPLocations { result in
            DispatchQueue.main.async {
                switch result {
                case .success():
                    self.locationPickerView.reloadAllComponents()
                case .error(let error):
                    self.displayAlert(title: "Error", message: error.customDescription)
                }
            }
        }
    }
    
    // MARK: - IBActions
    @IBAction func preferredLocationButtonTapped(_ sender: Any) {
        if viewModel.isPreferredLocationSet {
            // TODO: Segue to preferred location needs, urgent needs, and pleding
            promptForPreferredLocation()
        } else {
            promptForPreferredLocation()
        }
    }
    
    // MARK: - Helper Functions
    private func promptForPreferredLocation() {
        DispatchQueue.main.async {
            let alert = UIAlertController(title: "Preferred Location", message: "Please select your preferred Emergency Food Provider. You can change your preferred location at any time.", preferredStyle: .alert)
            let submitAction = UIAlertAction(title: "Save", style: .default) { _ in
                self.viewModel.setPreferredLocation(id: self.locationPickerView.selectedRow(inComponent: 0))
            }
            /*let noLocationAction = UIAlertAction(title: "Can't find a location?", style: .default) { _ in
                //TODO: Display list from other cities
            }*/
            let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
            
            alert.addAction(submitAction)
            //alert.addAction(noLocationAction)
            alert.addAction(cancelAction)
            
            alert.addTextField() { addedTextField in
                self.locationPickerView.delegate = self
                addedTextField.inputView = self.locationPickerView
                addedTextField.placeholder = "Preferred Location"
                self.textField = addedTextField
                self.textField?.delegate = self
            }
            
            self.present(alert, animated: true, completion: nil)
        }
    }
}

// MARK: - UITextFieldDelegate
extension MapViewController: UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        //Block all attempts to manually insert text into the text field. The only valid strings are ones that come from the `locationPickerView`
        return false
    }
}

// MARK: - UIPickerViewDelegate
extension MapViewController: UIPickerViewDelegate {
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if viewModel.locations.count > row {
            textField?.text = viewModel.locations[row].name
        }
    }
}

// MARK: - UIPickerViewDataSource
extension MapViewController: UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return viewModel.locations.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return viewModel.locations[row].name
    }
}
