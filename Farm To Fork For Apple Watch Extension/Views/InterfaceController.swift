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
    @IBOutlet private var preferredLocationPicker: WKInterfacePicker!
    @IBOutlet private var preferredLocationSaveButton: WKInterfaceButton!
    
    // MARK: - Properties
    private let viewModel = WatchNeedsViewModel()
    private let session = WCSession.default
    private var selectedRow: String? = nil
    
    // MARK: - Lifecycle Functions
    override func awake(withContext context: Any?) {
        super.awake(withContext: context)
        
        preferredLocationPicker.setHidden(true)
        preferredLocationSaveButton.setHidden(true)
        
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
        presentController(withName: "NeedInfo", context: viewModel.needs[rowIndex])
    }
    
    // MARK: - IBActions
    @IBAction func pickerSelectedLocationChanged(_ value: Int) {
        selectedRow = viewModel.locations[value].id
    }
    
    @IBAction func savePreferredLocation() {
        guard let selectedRow = selectedRow else {
            return
        }
        preferredLocationPicker.setHidden(true)
        preferredLocationSaveButton.setHidden(true)
        loadingLabel.setText("Saving...")
        viewModel.setPreferredLocation(id: selectedRow) { _ in
            self.fetchData()
        }
    }
    
    // MARK: - Helper Functions
    private func fetchData() {
        viewModel.fetchData { result in
            DispatchQueue.main.async {
                switch result {
                case .success:
                    if self.viewModel.numberOfRows > 0 {
                        self.itemsTable.setNumberOfRows(self.viewModel.numberOfRows, withRowType: "ItemRow")
                        for index in 0 ..< self.viewModel.numberOfRows {
                            guard let controller = self.itemsTable.rowController(at: index) as? NeedRowController else { continue }
                            
                            controller.configure(for: self.viewModel.needs[index])
                        }
                        self.loadingLabel.setHidden(true)
                    } else {
                        let pickerItems: [WKPickerItem] = self.viewModel.locations.map {
                            let pickerItem = WKPickerItem()
                            pickerItem.title = $0.name
                            return pickerItem
                        }
                        self.loadingLabel.setText("Select your preferred location")
                        self.preferredLocationPicker.setItems(pickerItems)
                        self.preferredLocationPicker.setHidden(false)
                        self.preferredLocationSaveButton.setHidden(false)
                        self.preferredLocationPicker.focus()
                    }
                case .error(let error):
                    self.loadingLabel.setText(error.description)
                }
            }
        }
    }
}

// MARK: - WCSessionDelegate
extension InterfaceController: WCSessionDelegate {
    func session(_ session: WCSession, activationDidCompleteWith activationState: WCSessionActivationState, error: Error?) {
        fetchData()
    }
}
