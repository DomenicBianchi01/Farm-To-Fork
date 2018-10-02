//
//  AddNeedViewController.swift
//  Farm To Fork
//
//  Created by Domenic Bianchi on 2018-09-23.
//  Copyright © 2018 Domenic Bianchi. All rights reserved.
//

import UIKit

final class AddNeedViewController: UIViewController {

    // MARK: - IBOutlets
    @IBOutlet private var tableView: UITableView!
    @IBOutlet private var saveBarButtonItem: UIBarButtonItem!
    
    // MARK: - Properties
    private let viewModel = AddNeedViewModel()
    
    // MARK: - Lifecycle Functions
    override func viewDidLoad() {
        super.viewDidLoad()

        let tapRecognizer = UITapGestureRecognizer(target: self, action: #selector(dismissFirstResponder))
        view.addGestureRecognizer(tapRecognizer)
    }
    
    // MARK: - IBActions
    @IBAction func saveButtonTapped(_ sender: Any) {
        saveBarButtonItem.isEnabled = false
        viewModel.modifyNeed { result in
            DispatchQueue.main.async {
                self.saveBarButtonItem.isEnabled = true
                switch result {
                case .success:
                    self.navigationController?.popViewController(animated: true)
                case .error(let error):
                    self.displaySCLAlert("Error", message: error.description, style: .error)
                }
            }
        }
    }
    
    // MARK: - Segue Helper Functions
    func addNeedToViewModel(_ need: Need) {
        viewModel.addNeed(need)
    }
}

// MARK: - UITableViewDelegate
extension AddNeedViewController: UITableViewDelegate { /* Not used */ }

// MARK: - UITableViewDataSource
extension AddNeedViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return viewModel.numberOfSections
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.numberOfRows(in: section)
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return viewModel.titleForHeader(in: section)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = viewModel.cellForRow(in: tableView, at: indexPath)

        if var cell = cell as? CellConfigurable {
            cell.delegate = self
        }
        
        return cell
    }
}

// MARK: - NewNeedDelegate
extension AddNeedViewController: NewNeedDelegate {
    func needInformationUpdated(with info: [String : Any]) {
        viewModel.needInformationUpdated(with: info)
    }
}
