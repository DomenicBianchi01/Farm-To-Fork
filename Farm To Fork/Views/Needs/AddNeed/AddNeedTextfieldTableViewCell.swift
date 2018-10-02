//
//  AddNeedTextfieldTableViewCell.swift
//  Farm To Fork
//
//  Created by Domenic Bianchi on 2018-09-23.
//  Copyright © 2018 Domenic Bianchi. All rights reserved.
//

import UIKit

final class AddNeedTextfieldTableViewCell: UITableViewCell, CellConfigurable {
    // MARK: - IBOutlets
    @IBOutlet private var inputTextField: UITextField!
    
    // MARK: - Properties
    weak var delegate: NewNeedDelegate? = nil
    var viewModel: CellViewModelable? = nil {
        didSet {
            // If the view model is ever changed, refresh the cell based on the new view model
            refreshCell()
        }
    }

    // MARK: - Lifetcylce Functions
    override func awakeFromNib() {
        super.awakeFromNib()
        
        inputTextField.addTarget(self, action: #selector(AddNeedTextfieldTableViewCell.textFieldDidChange(_:)), for: .editingChanged)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    // MARK: - Helper Functions
    @objc private func textFieldDidChange(_ textField: UITextField) {
        guard let viewModel = viewModel, let text = textField.text else {
            return
        }
        viewModel.updateViewModel(with: text)
        delegate?.needInformationUpdated(with: [viewModel.identifier : text])
    }
    
    private func refreshCell() {
        guard let viewModel = viewModel else {
            return
        }
        inputTextField.placeholder = viewModel.subtitle
        inputTextField.text = viewModel.title
    }
}
