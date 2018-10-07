//
//  AddNeedPickerTableViewCell.swift
//  Farm To Fork
//
//  Created by Domenic Bianchi on 2018-09-23.
//  Copyright © 2018 Domenic Bianchi. All rights reserved.
//

import UIKit

final class AddNeedPickerTableViewCell: UITableViewCell, CellConfigurable, NewNeedDelgatable {
    // MARK: - IBOutlets
    @IBOutlet private var inputTextField: UITextField!
    
    // MARK: - Properties
    private let pickerView = UIPickerView()
    weak var delegate: NewNeedDelegate? = nil
    var viewModel: CellViewModelable? = nil {
        didSet {
            // If the view model is ever changed, refresh the cell based on the new view model
            viewModel?.fetchData { result in
                DispatchQueue.main.async {
                    switch result {
                    case .success:
                        self.pickerView.reloadAllComponents()
                    case .error:
                        break //TODO
                    }
                    self.refreshCell()
                }
            }
        }
    }
    
    // MARK: - Lifetcylce Functions
    override func awakeFromNib() {
        super.awakeFromNib()
        
        let pickerView = UIPickerView()
        pickerView.delegate = self
        inputTextField.inputView = pickerView
        inputTextField.delegate = self
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        inputTextField.text = nil
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
    // MARK: - Helper Functions
    private func refreshCell() {
        guard let viewModel = viewModel else {
            return
        }
        inputTextField.placeholder = viewModel.string2
        inputTextField.text = viewModel.string1
    }
}

// MARK: - UITextFieldDelegate
extension AddNeedPickerTableViewCell: UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        //Block all attempts to manually insert text into the text field. The only valid strings are ones that come from the picker view
        return false
    }
}

// MARK: - UIPickerViewDelegate
extension AddNeedPickerTableViewCell: UIPickerViewDelegate {
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        viewModel?.updateViewModel(with: row)
        refreshCell()
        
        guard let viewModel = viewModel else {
            return
        }

        delegate?.needInformationUpdated(with: [viewModel.identifier : String(row + 1)])
    }
}

// MARK: - UIPickerViewDataSource
extension AddNeedPickerTableViewCell: UIPickerViewDataSource {
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
