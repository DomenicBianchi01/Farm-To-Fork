//
//  NeedInfoController.swift
//  Farm To Fork For Apple Watch Extension
//
//  Created by Domenic Bianchi on 2018-03-22.
//  Copyright © 2018 Domenic Bianchi & Marshall Asch. All rights reserved.
//

import WatchKit

final class NeedInfoController: WKInterfaceController {
    // MARK: - IBOutlets
    @IBOutlet private var needInfoTable: WKInterfaceTable!
    @IBOutlet private var itemNameLabel: WKInterfaceLabel!
    
    // MARK: - Lifecycle Functions
    override func awake(withContext context: Any?) {
        super.awake(withContext: context)
        guard let need = context as? Need else {
            return
        }

        itemNameLabel.setText("\(need.name)\n\(need.category) - \(need.type)")
        
        needInfoTable.setNumberOfRows(2, withRowType: "StatsRow")
        for index in 0 ..< 2 {
            guard let controller = needInfoTable.rowController(at: index) as? NeedInfoRowController else { continue }
            if index == 0 {
                controller.configure(value: need.currentQuantity, withDescription: "items pledged!")
            } else {
                controller.configure(value: need.targetQuantity - need.currentQuantity, withDescription: "more to reach our goal!")
            }
        }
    }
    
    override func willActivate() {
        // This method is called when watch view controller is about to be visible to user
        super.willActivate()
    }
    
    override func didDeactivate() {
        // This method is called when watch view controller is no longer visible
        super.didDeactivate()
    }
}
