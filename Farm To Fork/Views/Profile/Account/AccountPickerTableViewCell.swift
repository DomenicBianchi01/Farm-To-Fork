//
//  AccountPickerTableViewCell.swift
//  Farm To Fork
//
//  Created by Domenic Bianchi on 2018-10-31.
//  Copyright © 2018 Domenic Bianchi. All rights reserved.
//

import UIKit

final class AccountPickerTableViewCell: UITableViewCell, CellConfigurable, InformationDelgatable {
    // MARK: - IBOutlets
    @IBOutlet var textField: UITextField!
    
    // MARK: - Properties
    private let pickerView = UIPickerView()
    weak var delegate: InformationDelegate? = nil
    var viewModel: CellViewModelable? = nil {
        didSet {
            refreshCell()
        }
    }
    
    // MARK: - Lifecycle Functions
    override func awakeFromNib() {
        super.awakeFromNib()
        
        let pickerView = UIPickerView()
        pickerView.delegate = self
        textField.inputView = pickerView
        textField.delegate = self
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        textField.text = nil
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    // MARK: - Helper Functions
    private func refreshCell() {
        textField.placeholder = viewModel?.description
        textField.text = viewModel?.title
    }
}

// MARK: - UITextFieldDelegate
extension AccountPickerTableViewCell: UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        //Block all attempts to manually insert text into the text field. The only valid strings are ones that come from the picker view
        return false
    }
}

// MARK: - UIPickerViewDelegate
extension AccountPickerTableViewCell: UIPickerViewDelegate {
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        viewModel?.updateViewModel(with: row)
        refreshCell()
        
        guard let viewModel = viewModel else {
            return
        }
        
        delegate?.informationUpdated(with: [viewModel.identifier : row])
    }
}

// MARK: - UIPickerViewDataSource
extension AccountPickerTableViewCell: UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return (viewModel as? PickerViewModelable)?.numberOfComponents ?? 0
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return (viewModel as? PickerViewModelable)?.numberOfRows(in: component) ?? 0
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return (viewModel as? PickerViewModelable)?.titleForRow(in: component, row: row) ?? "Error"
    }
}
