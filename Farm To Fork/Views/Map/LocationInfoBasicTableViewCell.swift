//
//  LocationInfoBasicTableViewCell.swift
//  Farm To Fork
//
//  Created by Domenic Bianchi on 2018-03-26.
//  Copyright © 2018 Domenic Bianchi & Marshall Asch. All rights reserved.
//

import UIKit

class LocationInfoBasicTableViewCell: UITableViewCell {
    // MARK: - IBOutlets
    @IBOutlet private var label: UILabel!
    @IBOutlet private var imageBackgroundView: UIView!
    @IBOutlet private var iconImageView: UIImageView!
    
    // MARK: - Lifecycle Functions
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    // MARK: - Helper Computed Properties
    var webpage: URL? {
        guard let string = label.text else {
            return nil
        }
        if string.hasPrefix("http://") || string.hasPrefix("https://") {
            return URL(string: string)
        }
        return URL(string: "http://\(string)")
    }
    
    var phoneNumber: URL? {
        guard let string = label.text else {
            return nil
        }
        return string.isPhoneNumber ? URL(string: "tel://\(string)") : nil
    }
}

// MARK: - LocationConfigurable
extension LocationInfoBasicTableViewCell: LocationConfigurable {
    func configure(using string: String, and image: UIImage?) {
        label.text = string
        if image == nil {
            iconImageView.image = nil
            iconImageView.isHidden = true
            imageBackgroundView.isHidden = true
        } else {
            iconImageView.image = image
            iconImageView.isHidden = false
            imageBackgroundView.isHidden = false
        }
    }
}
