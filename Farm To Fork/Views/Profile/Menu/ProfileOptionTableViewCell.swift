//
//  ProfileOptionTableViewCell.swift
//  Farm To Fork
//
//  Created by Domenic Bianchi on 2018-04-14.
//  Copyright © 2018 Domenic Bianchi. All rights reserved.
//

import UIKit

final class ProfileOptionTableViewCell: UITableViewCell {
    // MARK: - IBOutlets
    @IBOutlet private var optionLabel: UILabel!
    
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
    func configure(with optionText: String) {
        optionLabel.text = optionText
    }
}
