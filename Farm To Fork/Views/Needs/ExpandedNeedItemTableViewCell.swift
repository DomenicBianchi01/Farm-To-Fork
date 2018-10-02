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
    
    // MARK - Lifecycle Functions
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
}

// MARK: - Configurable
extension ExpandedNeedItemTableViewCell: Configurable {
    func configure(using data: Any) {
        guard let need = data as? Need else {
            return
        }
        
        categoryLabel.text = "\(need.category.name) - \(need.units.name)"
        pledgeLabel.text = "\(need.currentQuantity) items pleged"
        
        if need.targetQuantity - need.currentQuantity > 0 {
            pledgesNeededLabel.text = "We need \(need.targetQuantity - need.currentQuantity) more to reach our goal of \(need.targetQuantity) items!"
        } else {
            pledgesNeededLabel.text = "We have reached our pledge goal of \(need.targetQuantity) items! You can still pledge if you wish!"
        }
    }
}
