//
//  LocationInfoHoursTableViewCell.swift
//  Farm To Fork
//
//  Created by Domenic Bianchi on 2018-03-26.
//  Copyright © 2018 Domenic Bianchi & Marshall Asch. All rights reserved.
//

import UIKit

final class LocationInfoHoursTableViewCell: UITableViewCell {
    // MARK: - IBOutlets
    @IBOutlet private var dayOfTheWeekLabel: UILabel!
    @IBOutlet private var hoursLabel: UILabel!
    
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

extension LocationInfoHoursTableViewCell: LocationConfigurable {
    func configure(for location: Location) {
        dayOfTheWeekLabel.text = location.hours.daysOfTheWeek.joined(separator: "\n")
        hoursLabel.text = location.hours.hours.joined(separator: "\n")
    }
}
