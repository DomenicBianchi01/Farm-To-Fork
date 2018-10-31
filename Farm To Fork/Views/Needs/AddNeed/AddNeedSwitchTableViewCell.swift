//
//  AddNeedSwitchTableViewCell.swift
//  Farm To Fork
//
//  Created by Domenic Bianchi on 2018-10-07.
//  Copyright © 2018 Domenic Bianchi. All rights reserved.
//

import UIKit

final class AddNeedSwitchTableViewCell: UITableViewCell, CellConfigurable, InformationDelgatable {
    // MARK: - IBOutlets
    @IBOutlet private var switcher: UISwitch!
    @IBOutlet private var cellLabel: UILabel!
    
    // MARK: - Properties
    weak var delegate: InformationDelegate? = nil
    var viewModel: CellViewModelable? {
        didSet {
            refreshCell()
        }
    }
    
    // MARK: - Lifecycle Functions
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }
    
    // MARK: - IBActions
    @IBAction func switcherValueChanged(_ sender: Any) {
        guard let viewModel = viewModel else {
            return
        }

        viewModel.updateViewModel(with: switcher.isOn)
        delegate?.informationUpdated(with: [viewModel.identifier : switcher.isOn])
    }
    
    // MARK: - Helper Functions
    private func refreshCell() {
        cellLabel.text = viewModel?.title
        switcher.isOn = viewModel?.description?.asBool ?? false
    }
}
