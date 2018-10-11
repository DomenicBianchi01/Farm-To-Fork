//
//  NeedItemTableViewCell.swift
//  Farm To Fork
//
//  Created by Domenic Bianchi on 2018-03-15.
//  Copyright © 2018 Domenic Bianchi & Marshall Asch. All rights reserved.
//

import UIKit

final class NeedItemTableViewCell: UITableViewCell, PledgeDelegatable {
    // MARK: - IBOutlets
    @IBOutlet private var titleLabel: UILabel!
    @IBOutlet private var subtitleLabel: UILabel!
    @IBOutlet private var personalPledgeCountLabel: UILabel!
    @IBOutlet private var pledgeButton: UIButton!
    
    // MARK: - Properties
    weak var delegate: PledgeDelegate? = nil
    var viewModel: NeedCellViewModel? = nil {
        didSet {
            refreshCell()
        }
    }
    
    // MARK: - Lifecycle Functions
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    // MARK: - IBActions
    @IBAction func pledgeButtonTapped(_ sender: Any) {
        guard let viewModel = viewModel else {
            return
        }
        delegate?.pledgeRequested(for: viewModel.need.id)
    }
    
    // MARK: - Helper Functions
    private func refreshCell() {
        pledgeButton.isHidden = viewModel?.needIsDisabled ?? false
        titleLabel.text = viewModel?.title
        subtitleLabel.text = viewModel?.description
        personalPledgeCountLabel.text = viewModel?.subDescription
    }
}
