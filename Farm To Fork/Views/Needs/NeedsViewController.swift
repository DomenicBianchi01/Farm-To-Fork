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
    
    // MARK: - Properties
    private let viewModel = NeedsViewModel()
    
    // MARK: - Lifecycle Functions
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 44
        
        viewModel.fetchNeeds { result in
            DispatchQueue.main.async {
                switch result {
                case .success():
                    self.tableView.reloadData()
                case .error(let error):
                    self.displayAlert(title: "Error", message: error.customDescription)
                }
            }
        }
    }

    // MARK: - IBActions
    @IBAction func dismissButtonTapped(_ sender: Any) {
        dismiss(animated: true, completion: nil)
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
        if let expandedIndexPath = viewModel.expandedIndexPath, indexPath.row == expandedIndexPath.row || indexPath.row == expandedIndexPath.row - 1 {
            viewModel.expandedIndexPath = nil
            if #available(iOS 11.0, *) {
                tableView.performBatchUpdates({
                    tableView.deleteRows(at: [expandedIndexPath], with: .top)
                }, completion: nil)
            } else {
                tableView.beginUpdates()
                tableView.deleteRows(at: [expandedIndexPath], with: .top)
                tableView.endUpdates()
            }
        } else if let expandedIndexPath = viewModel.expandedIndexPath {
            let newExpandedIndexPath = IndexPath(row: indexPath.row + 1, section: 0)
            viewModel.expandedIndexPath = newExpandedIndexPath
            
            if #available(iOS 11.0, *) {
                tableView.performBatchUpdates({
                    tableView.insertRows(at: [newExpandedIndexPath], with: .top)
                    tableView.deleteRows(at: [expandedIndexPath], with: .top)
                }, completion: nil)
            } else {
                tableView.beginUpdates()
                tableView.insertRows(at: [newExpandedIndexPath], with: .top)
                tableView.deleteRows(at: [expandedIndexPath], with: .top)
                tableView.endUpdates()
            }
        } else {
            let newExpandedIndexPath = IndexPath(row: indexPath.row + 1, section: 0)
            viewModel.expandedIndexPath = newExpandedIndexPath
            
            if #available(iOS 11.0, *) {
                tableView.performBatchUpdates({
                    tableView.insertRows(at: [newExpandedIndexPath], with: .top)
                }, completion: nil)
            } else {
                tableView.beginUpdates()
                tableView.insertRows(at: [newExpandedIndexPath], with: .top)
                tableView.endUpdates()
            }
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
}

// MARK: - PledgeDelegate
extension NeedsViewController: PledgeDelegate {
    func pledgeRequested(for need: Need) {
        let alert = UIAlertController(title: "Pledge", message: "How many \(need.name)'s would you like to pledge?", preferredStyle: .alert)
        let submitAction = UIAlertAction(title: "Submit", style: .default) { _ in
            guard let textField = alert.textFields?.first, let pledgedAmount = Int(textField.text ?? "") else {
                return
            }
            PledgeService().makePledge() { _ in
                //TODO
            }
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        
        alert.addAction(submitAction)
        alert.addAction(cancelAction)
        
        alert.addTextField() { addedTextField in
            addedTextField.placeholder = "Number of \(need.name)'s"
            addedTextField.keyboardType = .numberPad
            addedTextField.delegate = self
        }
        
        present(alert, animated: true, completion: nil)
    }
}
