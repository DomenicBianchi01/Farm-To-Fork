//
//  PledgeHistoryItemTableViewCell.swift
//  Farm To Fork
//
//  Created by Domenic Bianchi on 2018-10-29.
//  Copyright © 2018 Domenic Bianchi. All rights reserved.
//

import UIKit

final class PledgeHistoryItemTableViewCell: UITableViewCell {
    // MARK: - IBOutlets
    @IBOutlet private var titleLabel: UILabel!
    @IBOutlet private var descriptionLabel: UILabel!
    @IBOutlet private var infoLabel: UILabel!
    @IBOutlet private var pledgeCountLabel: UILabel!
    
    // MARK: - Properties
    var viewModel: PledgeHistoryCellViewModel? = nil {
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
    
    // MARK: - Helper Functions
    private func refreshCell() {
        titleLabel.text = viewModel?.title
        descriptionLabel.text = viewModel?.description
        infoLabel.text = viewModel?.subDescription
        pledgeCountLabel.text = viewModel?.pledgeCount
    }
}
