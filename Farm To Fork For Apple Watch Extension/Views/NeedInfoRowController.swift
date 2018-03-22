//
//  NeedInfoRowController.swift
//  Farm To Fork For Apple Watch Extension
//
//  Created by Domenic Bianchi on 2018-03-22.
//  Copyright © 2018 Domenic Bianchi & Marshall Asch. All rights reserved.
//

import WatchKit

final class NeedInfoRowController: NSObject {
    // MARK: - IBOutlets
    @IBOutlet var numberLabel: WKInterfaceLabel!
    @IBOutlet var subtitleLabel: WKInterfaceLabel!
    
    // MARK: - Helper Functions
    func configure(for value: Int, withDescription description: String) {
        numberLabel.setText("\(value)")
        subtitleLabel.setText(description)
    }
}
