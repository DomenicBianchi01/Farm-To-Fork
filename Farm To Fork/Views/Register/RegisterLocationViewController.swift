//
//  RegisterLocationViewController.swift
//  Farm To Fork
//
//  Created by Domenic Bianchi on 2018-03-08.
//  Copyright © 2018 Domenic Bianchi & Marshall Asch. All rights reserved.
//

import UIKit
import TextFieldEffects

final class RegisterLocationViewController: UIViewController {

    // MARK: - IBOutlets
    @IBOutlet var countryTextField: IsaoTextField!
    @IBOutlet var provinceTextField: IsaoTextField!
    @IBOutlet var cityTextField: IsaoTextField!
    @IBOutlet var backButton: UIButton!
    @IBOutlet var registerButton: UIButton!
    
    // MARK: - Properties
    let viewModel = RegisterLocationViewModel()
    
    // MARK: - Lifecycle Functions
    override func viewDidLoad() {
        super.viewDidLoad()
        
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
        provinceTextField.inputView = cityPickerView
        
        backButton.layer.borderColor = UIColor.white.cgColor
        registerButton.layer.borderColor = UIColor.white.cgColor
    }
}

// MARK: - UIPickerViewDelegate
extension RegisterLocationViewController: UIPickerViewDelegate {
    
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
