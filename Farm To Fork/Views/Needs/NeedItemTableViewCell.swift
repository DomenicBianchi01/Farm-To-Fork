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
    
    // MARK: - Helper Functions
    func configure(for need: Need) {
        titleLabel.text = need.name
        subtitleLabel.text = need.description
        self.need = need
    }
}
