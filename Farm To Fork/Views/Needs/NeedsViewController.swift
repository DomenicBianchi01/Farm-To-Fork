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
    @IBOutlet var tableView: UITableView!
    
    // MARK: - Properties
    let viewModel = NeedsViewModel()
    
    // MARK: - Lifecycle Functions
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    // MARK: - IBActions
    @IBAction func dismissButtonTapped(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
}

extension NeedsViewController: UITableViewDelegate {
    
}

extension NeedsViewController: UITableViewDataSource {
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
