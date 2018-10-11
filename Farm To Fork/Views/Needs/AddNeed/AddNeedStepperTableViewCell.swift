//
//  AddNeedStepperTableViewCell.swift
//  Farm To Fork
//
//  Created by Domenic Bianchi on 2018-09-23.
//  Copyright © 2018 Domenic Bianchi. All rights reserved.
//

import UIKit

final class AddNeedStepperTableViewCell: UITableViewCell, CellConfigurable, NewNeedDelgatable {
    
    // MARK: - IBOutlets
    @IBOutlet private var inputTextField: UITextField!
    @IBOutlet private var stepper: UIStepper!
    
    // MARK: - Properties
    weak var delegate: NewNeedDelegate? = nil
    var viewModel: CellViewModelable? = nil {
        didSet {
            // If the view model is ever changed, refresh the cell based on the new view model
            refreshCell()
            stepper.value = (viewModel as? StepperViewModelable)?.stepperValue ?? 0
        }
    }
    
    // MARK: - Lifecycle Functions
    override func awakeFromNib() {
        super.awakeFromNib()
        
        inputTextField.delegate = self
        inputTextField.addTarget(self, action: #selector(AddNeedStepperTableViewCell.textFieldDidChange(_:)), for: .editingChanged)
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        inputTextField.text = nil
        stepper.value = 0.0
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    // MARK: - IBActions
    @IBAction func stepperChanged(_ sender: UIStepper) {
        guard let viewModel = viewModel else {
            return
        }
        viewModel.updateViewModel(with: sender.value)
        delegate?.needInformationUpdated(with: [viewModel.identifier : Int(sender.value)])
        refreshCell()
    }
    
    // MARK: - Helper Functions
    @objc private func textFieldDidChange(_ textField: UITextField) {
        guard let viewModel = viewModel,
            let text = textField.text,
            let newValue = Int(text) else {
            return
        }
        stepper.value = Double(newValue)
        viewModel.updateViewModel(with: newValue)
        delegate?.needInformationUpdated(with: [viewModel.identifier : newValue])
    }
    
    private func refreshCell() {
        guard let viewModel = viewModel else {
            return
        }
        inputTextField.placeholder = viewModel.description
        inputTextField.text = viewModel.title
    }
}

// MARK: - UITextFieldDelegate
extension AddNeedStepperTableViewCell: UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if Int(string) == nil && !string.isEmpty {
            return false
        }
        return true
    }
}
