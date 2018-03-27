//
//  NeedRowController.swift
//  Farm To Fork For Apple Watch Extension
//
//  Created by Domenic Bianchi on 2018-03-22.
//  Copyright © 2018 Domenic Bianchi & Marshall Asch. All rights reserved.
//

import WatchKit

final class NeedRowController: NSObject {
    // MARK: - IBOutlets
    @IBOutlet private var titleLabel: WKInterfaceLabel!
    
    // MARK: - Functions
    func configure(for need: Need) {
        titleLabel.setText(need.name)
    }
}
