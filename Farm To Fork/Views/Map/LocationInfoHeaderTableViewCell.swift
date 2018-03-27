//
//  LocationInfoHeaderTableViewCell.swift
//  Farm To Fork
//
//  Created by Domenic Bianchi on 2018-03-26.
//  Copyright © 2018 Domenic Bianchi & Marshall Asch. All rights reserved.
//

import UIKit

final class LocationInfoHeaderTableViewCell: UITableViewCell {
    // MARK: - IBOutlets
    @IBOutlet private var locationNameLabel: UILabel!
    @IBOutlet private var distanceLabel: UILabel!
    
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

// MARK: - LocationConfigurable
extension LocationInfoHeaderTableViewCell: LocationConfigurable {
    func configure(for location: Location) {
        locationNameLabel.text = location.name
        if let distance = location.distance {
            distanceLabel.text = String(describing: (distance / 1000).round()) + " km"
        } else {
            distanceLabel.text = nil
        }
    }
}
