//
//  RegisterLocationViewController.swift
//  Farm To Fork
//
//  Created by Domenic Bianchi on 2018-03-08.
//  Copyright © 2018 Domenic Bianchi & Marshall Asch. All rights reserved.
//

import UIKit
import MaterialTextField

final class RegisterLocationViewController: UIViewController {
    // MARK: - IBOutlets
    @IBOutlet private var countryTextField: MFTextField!
    @IBOutlet private var provinceTextField: MFTextField!
    @IBOutlet private var cityTextField: MFTextField!
    @IBOutlet private var backButton: UIButton!
    @IBOutlet private var registerButton: UIButton!
    
    // MARK: - Properties
    let viewModel = RegisterLocationViewModel()
    
    // MARK: - Lifecycle Functions
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // A gesture recognizer that will dismiss the keyboard if the screen is tapped
        let tapRecognizer = UITapGestureRecognizer(target: self, action: #selector(dismissFirstResponder))
        view.addGestureRecognizer(tapRecognizer)
        
        let countryPickerView = UIPickerView()
        countryPickerView.tag = RegisterLocationViewModel.PickerType.country.rawValue
        countryPickerView.delegate = self
        countryTextField.inputView = countryPickerView
        countryTextField.delegate = self
        
        let provincePickerView = UIPickerView()
        provincePickerView.tag = RegisterLocationViewModel.PickerType.province.rawValue
        provincePickerView.delegate = self
        provinceTextField.inputView = provincePickerView
        countryTextField.delegate = self
        
        let cityPickerView = UIPickerView()
        cityPickerView.tag = RegisterLocationViewModel.PickerType.city.rawValue
        cityPickerView.delegate = self
        cityTextField.inputView = cityPickerView
        countryTextField.delegate = self
        
        backButton.layer.borderColor = UIColor.white.cgColor
        registerButton.layer.borderColor = UIColor.white.cgColor
        
        viewModel.fetchCountries() { _ in
            DispatchQueue.main.async {
                countryPickerView.reloadAllComponents()
            }
        }
    }
    
    override func unwind(for unwindSegue: UIStoryboardSegue, towards subsequentVC: UIViewController) {
        let segue = UnwindRegisterAccountSegue(identifier: unwindSegue.identifier, source: unwindSegue.source, destination: unwindSegue.destination)
        segue.perform()
    }
    
    // MARK: - IBActions
    @IBAction func registerButtonTapped(_ sender: Any) {
        viewModel.registerUser { result in
            switch result {
            case .success():
                DispatchQueue.main.async {
                    self.performSegue(withIdentifier: "unwindBackToLogin", sender: self)
                }
            case .error(let error):
                self.displaySCLAlert("Registration Error", message: error.customDescription, style: .error)
            }
        }
    }
}

// MARK: - UIPickerViewDelegate
extension RegisterLocationViewController: UIPickerViewDelegate {
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        guard let pickerType = RegisterLocationViewModel.PickerType(rawValue: pickerView.tag) else {
            return
        }
        
        let selectionName = viewModel.title(for: row, in: component, for: pickerType)
        
        //TODO: Reload picker views after all data has been fetched
        
        switch pickerType {
        case .country:
            viewModel.fetchProvinces(for: row)
            viewModel.updateUserCountry(to: row)
            countryTextField.text = selectionName
            provinceTextField.text = nil
            cityTextField.text = nil
        case .province:
            viewModel.fetchCities(for: row)
            viewModel.updateUserProvince(to: row)
            provinceTextField.text = selectionName
            cityTextField.text = nil
        case .city:
            viewModel.updateUserCity(to: row)
            cityTextField.text = selectionName
        }
    }
}

// MARK: - UITextFieldDelegate
extension RegisterLocationViewController: UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        //Block all attempts to manually insert text into the text field. The only valid strings are ones that come from the picker views
        return false
    }
}

// MARK: - UIPickerViewDataSource
extension RegisterLocationViewController: UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return viewModel.numberOfComponents
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        guard let pickerType = RegisterLocationViewModel.PickerType(rawValue: pickerView.tag) else {
            return 0
        }
        return viewModel.numberOfRows(for: pickerType)
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        guard let pickerType = RegisterLocationViewModel.PickerType(rawValue: pickerView.tag) else {
            return "Error"
        }
        return viewModel.title(for: row, in: component, for: pickerType)
    }
}
