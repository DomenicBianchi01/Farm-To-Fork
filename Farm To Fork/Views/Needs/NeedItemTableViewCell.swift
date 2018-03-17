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
    @IBOutlet var titleLabel: UILabel!
    @IBOutlet var subtitleLabel: UILabel!
    
    // MARK: - Lifecycle Functions
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
