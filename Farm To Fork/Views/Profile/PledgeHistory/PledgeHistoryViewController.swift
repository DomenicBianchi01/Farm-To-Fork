//
//  PledgeHistoryViewController.swift
//  Farm To Fork
//
//  Created by Domenic Bianchi on 2018-10-29.
//  Copyright © 2018 Domenic Bianchi. All rights reserved.
//

import UIKit

final class PledgeHistoryViewController: UIViewController {
    // MARK: - IBOutlets
    @IBOutlet private var tableView: UITableView!
    
    // MARK: - Properties
    let viewModel = PledgeHistoryViewModel()
    
    // MARK: - Lifecycle Functions
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 44

        fetchPledges()
    }
    
    // MARK: - IBActions
    @IBAction func filterButtonTapped(_ sender: Any) {
        let alert = UIAlertController(title: nil, message: "How far back do you want to see your pledge history?", preferredStyle: .actionSheet)
        
        let oneWeekAction = UIAlertAction(title: "1 week", style: .default) { (UIAlertAction) in
            self.updateFilter(dayRange: 7)
        }
        
        let twoWeeksAction = UIAlertAction(title: "2 weeks", style: .default) { (UIAlertAction) in
            self.updateFilter(dayRange: 14)
        }
        
        let oneMonthAction = UIAlertAction(title: "1 month", style: .default) { (UIAlertAction) in
            self.updateFilter(dayRange: 31)
        }
        
        let allAction = UIAlertAction(title: "Show me all my history", style: .default) { (UIAlertAction) in
            self.updateFilter(dayRange: nil)
        }
        
        alert.addAction(oneWeekAction)
        alert.addAction(twoWeeksAction)
        alert.addAction(oneMonthAction)
        alert.addAction(allAction)
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        
        alert.popoverPresentationController?.sourceView = view
        alert.popoverPresentationController?.sourceRect = view.bounds
        
        present(alert, animated: true, completion: nil)
    }
    
    // MARK: - Helper Functions
    private func updateFilter(dayRange: Int?) {
        viewModel.dayRange = dayRange
        fetchPledges()
    }
    
    private func fetchPledges() {
        viewModel.fetchPledges { result in
            DispatchQueue.main.async {
                switch result {
                case .success:
                    self.tableView.reloadData()
                case .error(let error):
                    self.displaySCLAlert("Error", message: error.description, style: .error)
                }
            }
        }
    }
}

// MARK: - UITableViewDelegate
extension PledgeHistoryViewController: UITableViewDelegate { /* Not used */ }

// MARK: - UITableViewDataSource
extension PledgeHistoryViewController: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return viewModel.numberOfSections
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.numberOfRows(in: section)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return viewModel.cellForRow(in: tableView, at: indexPath)
    }
}
