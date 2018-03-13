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
        countryPickerView.tag = 1
        countryPickerView.delegate = self
        countryTextField.inputView = countryPickerView
        
        let provincePickerView = UIPickerView()
        provincePickerView.tag = 2
        provincePickerView.delegate = self
        provinceTextField.inputView = provincePickerView
        
        let cityPickerView = UIPickerView()
        cityPickerView.tag = 3
        cityPickerView.delegate = self
        cityTextField.inputView = cityPickerView
        
        backButton.layer.borderColor = UIColor.white.cgColor
        registerButton.layer.borderColor = UIColor.white.cgColor
        
        viewModel.fetchCountries()
        
        //TODO: Reload picker views after all data has been fetched
    }
    
    override func unwind(for unwindSegue: UIStoryboardSegue, towardsViewController subsequentVC: UIViewController) {
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
                self.displayErrorAlert(with: error.customDescription)
            }
        }
    }
    
    // MARK: - Helper Functions
    
    /**
     Display an error alert on the screen.
     
     - parameter message: The error message to be displayed on the alert
     */
    private func displayErrorAlert(with message: String) {
        DispatchQueue.main.async {
            let alert = UIAlertController(title: "Error", message: message, preferredStyle: .alert)
            let alertAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
            
            alert.addAction(alertAction)
            
            self.present(alert, animated: true, completion: nil)
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
