//
//  NeedItemTableViewCell.swift
//  Farm To Fork
//
//  Created by Domenic Bianchi on 2018-03-15.
//  Copyright © 2018 Domenic Bianchi & Marshall Asch. All rights reserved.
//

import UIKit

final class NeedItemTableViewCell: UITableViewCell {
    // MARK: - IBOutlets
    @IBOutlet private var titleLabel: UILabel!
    @IBOutlet private var subtitleLabel: UILabel!
    @IBOutlet private var personalPledgeCountLabel: UILabel!
    
    // MARK: - Properties
    private var need: Need? = nil
    weak var delegate: PledgeDelegate? = nil
    
    // MARK: - Lifecycle Functions
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    // MARK: - IBActions
    @IBAction func pledgeButtonTapped(_ sender: Any) {
        guard let need = need else {
            return
        }
        delegate?.pledgeRequested(for: need)
    }
}

// MARK: - Configurable
extension NeedItemTableViewCell: Configurable {
    func configure(using data: Any) {
        guard let need = data as? Need else {
            return
        }
        
        titleLabel.text = need.name
        subtitleLabel.text = need.description
        personalPledgeCountLabel.text = "You have pledged 2 of this item" //TODO: This data should come from the Pledge API when it is created
        self.need = need
    }
}
