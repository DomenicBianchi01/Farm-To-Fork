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
    
    // MARK: - Properties
    private var locationName: String? = nil
    private var selectedRowToEdit: Int? = nil
    let viewModel = NeedsViewModel()
    
    // MARK: - Lifecycle Functions
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // If this value is `true`, then allow the user to change their preferred location.
        if viewModel.hideCloseButton {
            navigationItem.leftBarButtonItem = changeEFPBarButtonItem
        }
        
        if !(loggedInUser?.isAdmin ?? true) {
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
        performSegue(withIdentifier: Constants.Segues.modifyNeed, sender: self)
    }
    
    @IBAction func changeLocationButtonTapped(_ sender: Any) {
        guard let tabBar = tabBarController as? TabBarController else {
            return
        }
        //TODO: I really don't like this (using the tab bar controller to prompt for the preferred location) but I don't want to duplicate the code in the function.
        tabBar.promptForPreferredLocation()
    }
    
    // MARK: - Helper Functions
    func selectedLocation(_ location: Location) {
        viewModel.location = location
        locationName = location.name
    }
    
    private func refreshTitle() {
        locationName = UserDefaults.appGroup?.string(forKey: Constants.preferredLocationName)
        if let locationName = locationName {
            navigationItem.title = locationName + " Needs"
        }
    }
    
    @objc private func preferredLocationSet() {
        refreshTitle()
        fetchNeeds()
    }
    
    private func fetchNeeds() {
        viewModel.fetchNeeds { result in
            DispatchQueue.main.async {
                switch result {
                case .success():
                    self.tableView.reloadData()
                case .error(let error):
                    self.displaySCLAlert("Error", message: error.description, style: .error)
                    self.tableView.reloadData()
                }
            }
        }
    }
    
    // MARK: - Segue Functions
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == Constants.Segues.modifyNeed, let selectedRow = selectedRowToEdit, let viewController = segue.destination as? AddNeedViewController {
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
        
        // TODO: Avoid casting to a concrete type in the view controller
        if let cell = cell as? NeedItemTableViewCell {
            cell.delegate = self
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return viewModel.isEditable(at: indexPath)
    }
    
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        let deleteAction = UITableViewRowAction(style: .destructive, title: "Delete") { action, indexpath in
            self.viewModel.deleteNeed(at: indexPath.row) { result in
                switch result {
                case .success:
                    var indexPaths = [indexPath]
                    
                    if let expandedIndexPath = self.viewModel.expandedIndexPath, expandedIndexPath.row == indexPath.row + 1 {
                        indexPaths.append(expandedIndexPath)
                    }
                    
                    self.viewModel.expandedIndexPath = nil
                    
                    DispatchQueue.main.async {
                        tableView.performBatchUpdates({
                            tableView.deleteRows(at: indexPaths, with: .top)
                        }, completion: nil)
                    }
                case .error(let error):
                    self.displaySCLAlert("Error", message: error.description, style: .error)
                }
            }
        }
        
        let editAction = UITableViewRowAction(style: .normal, title: "Edit") { action, indexpath in
            self.selectedRowToEdit = indexPath.row
            self.performSegue(withIdentifier: "modifyNeedSegue", sender: self)
        }
        
        return [deleteAction, editAction]
    }
}

// MARK: - PledgeDelegate
extension NeedsViewController: PledgeDelegate {
    func pledgeRequested(for need: Need) {
        let alert = UIAlertController(title: "Pledge", message: "How many \(need.name)'s would you like to pledge?", preferredStyle: .alert)
        let submitAction = UIAlertAction(title: "Submit", style: .default) { _ in
            guard let textField = alert.textFields?.first, let text = textField.text, let pledgedAmount = Int(text) else {
                return
            }
            PledgeService().pledge(needID: need.id, quantity: pledgedAmount) { _ in
                //TODO
            }
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        
        alert.addAction(submitAction)
        alert.addAction(cancelAction)
        
        alert.addTextField { addedTextField in
            addedTextField.placeholder = "Number of \(need.name)'s"
            //TODO: Check that all input is numbers as user types
            addedTextField.keyboardType = .numberPad
            addedTextField.delegate = self
        }
        
        alert.popoverPresentationController?.sourceView = view
        alert.popoverPresentationController?.sourceRect = view.bounds
        
        present(alert, animated: true, completion: nil)
    }
}
