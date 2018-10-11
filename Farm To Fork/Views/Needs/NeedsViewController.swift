//
//  NeedsViewController.swift
//  Farm To Fork
//
//  Created by Domenic Bianchi on 2018-03-14.
//  Copyright © 2018 Domenic Bianchi & Marshall Asch. All rights reserved.
//

import UIKit

final class NeedsViewController: UIViewController {
    // MARK: - IBOutlets
    @IBOutlet private var tableView: UITableView!
    @IBOutlet private var addNeedBarButtonItem: UIBarButtonItem!
    @IBOutlet private var changeEFPBarButtonItem: UIBarButtonItem!
    @IBOutlet private var noNeedsLabel: UILabel!
    
    // MARK: - Properties
    let viewModel = NeedsViewModel()
    
    // MARK: - Lifecycle Functions
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // If this value is `true`, then allow the user to change their preferred location.
        if viewModel.hideCloseButton {
            navigationItem.leftBarButtonItem = changeEFPBarButtonItem
        }
        
        if !viewModel.isAdminForLocation {
            navigationItem.rightBarButtonItem = nil
        }
        
        NotificationCenter.default.addObserver(self, selector: #selector(preferredLocationSet), name:
            .preferredLocationSet, object: nil)
        
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 44
        
        refreshTitle()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        viewModel.selectedRowToEdit = nil
        refreshTitle()
        fetchNeeds()
    }

    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    // MARK: - IBActions
    @IBAction func dismissButtonTapped(_ sender: Any) {
        dismiss(animated: true)
    }
    
    @IBAction func addNeedButtonTapped(_ sender: Any) {
        let alert = UIAlertController(title: nil, message: "What do you want to do?", preferredStyle: .actionSheet)
        let addAction = UIAlertAction(title: "Add Need", style: .default, handler: nil)
        let filterAction = UIAlertAction(title: "Display \(viewModel.disabledNeedsHidden ? "All" : "Only Acitve") Needs", style: .default) { (UIAlertAction) in
            self.viewModel.updateNeedsFilter { result in
                switch result {
                case .success:
                    DispatchQueue.main.async {
                        self.tableView.reloadData()
                        self.refreshNoNeedsStatus()
                    }
                case .error(let error):
                    self.displaySCLAlert("Error", message: error.description, style: .error)
                }
            }
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        
        alert.addAction(addAction)
        alert.addAction(filterAction)
        alert.addAction(cancelAction)
        
        alert.popoverPresentationController?.sourceView = view
        alert.popoverPresentationController?.sourceRect = view.bounds
        
        present(alert, animated: true, completion: nil)
        performSegue(withIdentifier: Constants.Segues.modifyNeed, sender: self)
    }
    
    @IBAction func changeLocationButtonTapped(_ sender: Any) {
        guard let tabBar = tabBarController as? TabBarController else {
            return
        }

        tabBar.promptForPreferredLocation()
    }
    
    // MARK: - Helper Functions
    func selectedLocation(_ location: Location) {
        viewModel.location = location
    }
    
    private func refreshTitle() {
        title = viewModel.name
    }
    
    @objc private func preferredLocationSet() {
        refreshTitle()
        fetchNeeds()
    }
    
    private func fetchNeeds() {
        viewModel.fetchNeeds { result in
            DispatchQueue.main.async {
                switch result {
                case .success:
                    self.tableView.reloadData()
                    self.refreshNoNeedsStatus()
                case .error(let error):
                    self.displaySCLAlert("Error", message: error.description, style: .error)
                    self.tableView.reloadData()
                }
            }
        }
    }
    
    /// If there are no needs, the table view is hidden and a label saying "No Needs" is displayed. Opposite occurs if there is at least one need.
    private func refreshNoNeedsStatus() {
        if viewModel.noNeeds {
            tableView.separatorStyle = .none
            noNeedsLabel.isHidden = false
        } else {
            tableView.separatorStyle = .singleLine
            noNeedsLabel.isHidden = true
        }
    }
    
    // MARK: - Segue Functions
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == Constants.Segues.modifyNeed, let selectedRow = viewModel.selectedRowToEdit, let viewController = segue.destination as? AddNeedViewController {
            viewController.addNeedToViewModel(viewModel.needs[selectedRow])
        }
    }
}

// MARK: - UITextFieldDelegate
extension NeedsViewController: UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        return string.isNumber || string.isEmpty
    }
}

// MARK: - UITableViewDelegate
extension NeedsViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        // If the expanded cell is tapped or its parent cell is tapped
        if let expandedIndexPath = viewModel.expandedIndexPath, indexPath.row == expandedIndexPath.row || indexPath.row == expandedIndexPath.row - 1 {
            viewModel.expandedIndexPath = nil
            tableView.performBatchUpdates({
                tableView.deleteRows(at: [expandedIndexPath], with: .top)
            }, completion: nil)
        } else if let expandedIndexPath = viewModel.expandedIndexPath {
            let newExpandedIndexPath: IndexPath
            if indexPath.row > expandedIndexPath.row {
                newExpandedIndexPath = IndexPath(row: indexPath.row, section: 0)
            } else {
                newExpandedIndexPath = IndexPath(row: indexPath.row + 1, section: 0)
            }
            
            viewModel.expandedIndexPath = newExpandedIndexPath

            tableView.performBatchUpdates({
                tableView.deleteRows(at: [expandedIndexPath], with: .top)
                tableView.insertRows(at: [newExpandedIndexPath], with: .top)
            }, completion: nil)
        } else {
            let newExpandedIndexPath = IndexPath(row: indexPath.row + 1, section: 0)
            viewModel.expandedIndexPath = newExpandedIndexPath

            tableView.performBatchUpdates({
                tableView.insertRows(at: [newExpandedIndexPath], with: .top)
            }, completion: nil)
        }
    }
}

// MARK: - UITableViewDataSource
extension NeedsViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return viewModel.numberOfSections
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.numberOfRows(in: section)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = viewModel.cellForRow(in: tableView, at: indexPath)

        if var cell = cell as? PledgeDelegatable {
            cell.delegate = self
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return viewModel.isEditable(at: indexPath)
    }
    
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
//        let deleteAction = UITableViewRowAction(style: .destructive, title: "Delete") { action, indexpath in
//
//            self.viewModel.deleteNeed(at: indexPath.row) { result in
//                switch result {
//                case .success:
//                    var indexPaths = [indexPath]
//
//                    if let expandedIndexPath = self.viewModel.expandedIndexPath, expandedIndexPath.row == indexPath.row + 1 {
//                        indexPaths.append(expandedIndexPath)
//                    }
//
//                    self.viewModel.expandedIndexPath = nil
//
//                    DispatchQueue.main.async {
//                        tableView.performBatchUpdates({
//                            tableView.deleteRows(at: indexPaths, with: .top)
//                        }, completion: nil)
//                        self.refreshNoNeedsStatus()
//                    }
//                case .error(let error):
//                    self.displaySCLAlert("Error", message: error.description, style: .error)
//                }
//            }
//        }
        
        let editAction = UITableViewRowAction(style: .normal, title: "Edit") { action, indexpath in
            self.viewModel.selectedRowToEdit = indexPath.row
            self.performSegue(withIdentifier: Constants.Segues.modifyNeed, sender: self)
        }
        
        editAction.backgroundColor = .orange
        
        return [/*deleteAction,*/ editAction]
    }
}

// MARK: - PledgeDelegate
extension NeedsViewController: PledgeDelegate {
    func pledgeRequested(for needId: Int) {
        guard let need = viewModel.needs.first(where: { $0.id == needId}) else {
            return
        }

        let alert = UIAlertController(title: "Pledge", message: "How many \(need.name)'s would you like to pledge?", preferredStyle: .alert)
        let submitAction = UIAlertAction(title: "Submit", style: .default) { _ in
            guard let locationId = self.viewModel.location?.id,
                let textField = alert.textFields?.first,
                let text = textField.text,
                let pledgedAmount = Int(text),
                let userId = loggedInUser?.id else {
                return
            }
            
            let pledge = Pledge(id: 0, needId: need.id, userId: userId, locationId: locationId, pledged: pledgedAmount)
            
            self.viewModel.pledge(pledge) { result in
                DispatchQueue.main.async {
                    switch result {
                    case .success:
                        self.displaySCLAlert("Pledge Submitted", message: "Your pledge has been submitted. Thank-you!", style: .success)
                    case .error(let error):
                        self.displaySCLAlert("Error", message: error.description, style: .error)
                    }
                }
            }
        }

        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        
        alert.addAction(submitAction)
        alert.addAction(cancelAction)
        
        alert.addTextField { addedTextField in
            addedTextField.placeholder = "Number of \(need.name)"
            addedTextField.keyboardType = .numberPad
            addedTextField.delegate = self
        }
        
        alert.popoverPresentationController?.sourceView = view
        alert.popoverPresentationController?.sourceRect = view.bounds
        
        present(alert, animated: true, completion: nil)
    }
}
