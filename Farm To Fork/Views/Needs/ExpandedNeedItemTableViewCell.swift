//
//  ExpandedNeedItemTableViewCell.swift
//  Farm To Fork
//
//  Created by Domenic Bianchi on 2018-03-18.
//  Copyright © 2018 Domenic Bianchi & Marshall Asch. All rights reserved.
//

import UIKit

final class ExpandedNeedItemTableViewCell: UITableViewCell {
    // MARK: - IBOutlets
    @IBOutlet private var categoryLabel: UILabel!
    @IBOutlet private var pledgeLabel: UILabel!
    @IBOutlet private var pledgesNeededLabel: UILabel!
    
    // MARK: - Properties
    var viewModel: ExpandedNeedCellViewModel? = nil {
        didSet {
            refreshCell()
        }
    }
    
    // MARK - Lifecycle Functions
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
        categoryLabel.text = viewModel?.string1
        pledgeLabel.text = viewModel?.string2
        pledgesNeededLabel.text = viewModel?.string3
    }
}
