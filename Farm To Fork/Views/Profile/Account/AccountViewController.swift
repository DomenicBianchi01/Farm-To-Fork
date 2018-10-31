//
//  AccountViewController.swift
//  Farm To Fork
//
//  Created by Domenic Bianchi on 2018-10-30.
//  Copyright © 2018 Domenic Bianchi. All rights reserved.
//

import UIKit

final class AccountViewController: UIViewController {
    // MARK: - IBOutlets
    @IBOutlet private var tableView: UITableView!
    
    // MARK: - Properties
    private let viewModel = AccountViewModel()

    // MARK: - Lifecycle Functions
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    // MARK: - IBActions
    @IBAction func saveButtonTapped(_ sender: Any) {
        viewModel.updateUser { result in
            DispatchQueue.main.async {
                switch result {
                case .success:
                    self.navigationController?.popViewController(animated: true)
                case .error(let error):
                    self.displaySCLAlert("Error", message: error.description, style: .error)
                }
            }
        }
    }
}

// MARK: - UITableViewDelegate
extension AccountViewController: UITableViewDelegate { /* Not used */ }

// MARK: - UITableViewDataSource
extension AccountViewController: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return viewModel.numberOfSections
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.numberOfRows(in: section)
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return viewModel.titleForHeader(in: section)
    }
    
    func tableView(_ tableView: UITableView, titleForFooterInSection section: Int) -> String? {
        return viewModel.titleForFooter(in: section)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = viewModel.cellForRow(in: tableView, at: indexPath)
        
        if var cell = cell as? InformationDelgatable {
            cell.delegate = self
        }
        
        return cell
    }
}

// MARK: - InformationDelegate
extension AccountViewController: InformationDelegate {
    func informationUpdated(with info: [String : Any]) {
        viewModel.userInformationUpdated(with: info)
    }
}
