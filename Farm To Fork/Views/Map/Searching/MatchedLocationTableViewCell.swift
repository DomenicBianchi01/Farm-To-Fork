//
//  MatchedLocationTableViewCell.swift
//  Farm To Fork
//
//  Created by Domenic Bianchi on 2018-03-26.
//  Copyright © 2018 Domenic Bianchi & Marshall Asch. All rights reserved.
//

import UIKit

final class MatchedLocationTableViewCell: UITableViewCell {
    // MARK: - IBOutlets
    @IBOutlet private var titleLabel: UILabel!
    @IBOutlet private var subtitleLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
}

// MARK: - LocationConfigurable
extension MatchedLocationTableViewCell: LocationConfigurable {
    func configure(for location: Location) {
        titleLabel.text = location.name
    }
}
