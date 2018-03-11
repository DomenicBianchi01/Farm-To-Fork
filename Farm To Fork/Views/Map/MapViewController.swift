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
    let viewModel = MapViewModel()
    
    // MARK: - Lifcycle Functions
    override func viewDidLoad() {
        super.viewDidLoad()

        //TODO: Marshall will implement the location API and can implement the rest of setting a preferred location
        //viewModel.fetchLocations()
    }

    // MARK: - IBActions
    @IBAction func preferredLocationButtonTapped(_ sender: Any) {
        if viewModel.isPreferredLocationSet {
            // TODO: Segue to preferred location needs, urgent needs, and pleding
        } else {
            //TEMP CODE
            UserDefaults.standard.set("1", forKey: Constants.preferredLocationId)
            //promptForPreferredLocation()
        }
    }
    
    // MARK: - Helper Functions
    private func promptForPreferredLocation() {
        DispatchQueue.main.async {
            var textField: UITextField? = nil
            let alert = UIAlertController(title: "Preferred Location", message: "Please select your preferred Emergency Food Provider. You can change your preferred location at any time.", preferredStyle: .alert)
            let submitAction = UIAlertAction(title: "Submit", style: .default) { _ in
                //TODO: Save location
            }
            let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
            
            alert.addAction(submitAction)
            alert.addAction(cancelAction)
            
            alert.addTextField() { addedTextField in
                let locationPickerView = UIPickerView()
                locationPickerView.delegate = self
                addedTextField.inputView = locationPickerView
                addedTextField.placeholder = "Preferred Location"
                textField = addedTextField
            }
            
            self.present(alert, animated: true, completion: nil)
        }
    }
}

// MARK: - UIPickerViewDelegate
extension MapViewController: UIPickerViewDelegate {

}

// MARK: - UIPickerViewDataSource
extension MapViewController: UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 0
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return 0
    }
    
}
