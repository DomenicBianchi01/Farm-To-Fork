//
//  InterfaceController.swift
//  Farm To Fork For Apple Watch Extension
//
//  Created by Domenic Bianchi on 2018-03-21.
//  Copyright © 2018 Domenic Bianchi & Marshall Asch. All rights reserved.
//

import WatchKit
import WatchConnectivity

final class InterfaceController: WKInterfaceController {
    // MARK: - IBOutlet
    @IBOutlet private var itemsTable: WKInterfaceTable!
    @IBOutlet private var loadingLabel: WKInterfaceLabel!
    
    // MARK: - Properties
    private let viewModel = WatchNeedsViewModel()
    private let session = WCSession.default
    
    // MARK: - Lifecycle Functions
    override func awake(withContext context: Any?) {
        super.awake(withContext: context)
        
        session.delegate = self
        session.activate()
    }
    
    override func willActivate() {
        // This method is called when watch view controller is about to be visible to user
        super.willActivate()
    }
    
    override func didDeactivate() {
        // This method is called when watch view controller is no longer visible
        super.didDeactivate()
    }
    
    override func table(_ table: WKInterfaceTable, didSelectRowAt rowIndex: Int) {
        presentController(withName: "NeedInfo", context: viewModel.need(at: rowIndex))
    }
}

// MARK: - WCSessionDelegate
extension InterfaceController: WCSessionDelegate {
    func session(_ session: WCSession, activationDidCompleteWith activationState: WCSessionActivationState, error: Error?) {
        viewModel.fetchNeeds { result in
            DispatchQueue.main.async {
                switch result {
                case .success:
                    self.itemsTable.setNumberOfRows(self.viewModel.numberOfRows, withRowType: "ItemRow")
                    for index in 0 ..< self.viewModel.numberOfRows {
                        guard let controller = self.itemsTable.rowController(at: index) as? NeedRowController else { continue }
                        
                        controller.configure(for: self.viewModel.needs[index])
                    }
                    self.loadingLabel.setHidden(true)
                case .error(let error):
                    self.loadingLabel.setText(error.description)
                }
            }
        }
    }
}
