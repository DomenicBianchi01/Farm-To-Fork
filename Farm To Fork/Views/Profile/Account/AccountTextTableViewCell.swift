//
//  AccountTextTableViewCell.swift
//  Farm To Fork
//
//  Created by Domenic Bianchi on 2018-10-30.
//  Copyright © 2018 Domenic Bianchi. All rights reserved.
//

import UIKit

final class AccountTextTableViewCell: UITableViewCell, CellConfigurable, InformationDelgatable {
    // MARK: - IBOutlets
    @IBOutlet private var textField: UITextField!

    // MARK: - Properties
    weak var delegate: InformationDelegate?
    var viewModel: CellViewModelable? {
        didSet {
            refreshCell()
        }
    }
    
    // MARK: - Lifecycle Functions
    override func awakeFromNib() {
        super.awakeFromNib()
        
        textField.addTarget(self, action: #selector(AccountTextTableViewCell.textFieldDidChange(_:)), for: .editingChanged)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    // MARK: - Functions
    @objc private func textFieldDidChange(_ textField: UITextField) {
        guard let viewModel = viewModel, let text = textField.text else {
            return
        }
        viewModel.updateViewModel(with: text)
        delegate?.informationUpdated(with: [viewModel.identifier : text])
    }

    private func refreshCell() {
        textField.placeholder = viewModel?.description
        textField.text = viewModel?.title
    }
}
