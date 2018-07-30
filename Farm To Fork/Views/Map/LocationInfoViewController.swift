//
//  LocationInfoViewController.swift
//  Farm To Fork
//
//  Created by Domenic Bianchi on 2018-03-25.
//  Copyright © 2018 Domenic Bianchi & Marshall Asch. All rights reserved.
//

import UIKit

final class LocationInfoViewController: UIViewController {
    // MARK: - IBOutlets
    @IBOutlet private var tableView: UITableView!
    
    // MARK: - Properties
    private let viewModel = LocationInfoViewModel()
    var location: Location? = nil
    weak var delegate: LocationInfoDelegate? = nil
    
    // MARK: - Lifecycle Functions
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 44

        view.applyBlurEffect(using: .extraLight, cornerRadius: 15, corners: [.topLeft, .topRight])
    }
    
    // MARK: - IBActions
    @IBAction func viewNeeds(_ sender: Any) {
        guard let location = location else {
            return
        }
        delegate?.viewNeeds(for: location)
    }
    
    @IBAction func getDirections(_ sender: Any) {
        guard let location = location else {
            return
        }
        delegate?.directionsRequested(to: location)
    }
    
    // MARK: - Helper Functions
    //TODO: Try to use the delegate below instead
    func selected(location: Location) {
        self.location = location
        viewModel.location = location
        tableView.reloadData()
    }
    
    func setTableViewScrollable(isScrollable: Bool) {
        tableView.isScrollEnabled = isScrollable
    }
    
    func resetTableView() {
        tableView.setContentOffset(.zero, animated: true)
    }
    
    var isTableViewScrollable: Bool {
        return tableView.isScrollEnabled
    }
}

// MARK: - UIScrollViewDelegate
extension LocationInfoViewController: UIScrollViewDelegate {
    func scrollViewDidScrollToTop(_ scrollView: UIScrollView) {
        tableView.isScrollEnabled = false
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if tableView.contentOffset.y == 0 {
            tableView.isScrollEnabled = false
        }
    }
}

// MARK: - UITableViewDelegate
extension LocationInfoViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        let cell = tableView.cellForRow(at: indexPath)
        if let cell = cell as? LocationInfoBasicTableViewCell {
            if let phoneNumber = cell.phoneNumber {
                UIApplication.shared.open(phoneNumber, options: [:])
            } else if let webpage = cell.webpage {
                UIApplication.shared.open(webpage, options: [:])
            }
        }
    }
}

// MARK: - UITableViewDataSource
extension LocationInfoViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return viewModel.numberOfSections
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.numberOfRows(in: section)
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return viewModel.titleForHeader(in: section)
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return viewModel.heightForHeader(in: section)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = viewModel.cellForRow(in: tableView, at: indexPath)
        
        if let locationCell = cell as? LocationConfigurable, let location = location {
            if indexPath.section == 0 {
                if indexPath.row == 0 {
                    locationCell.configure(for: location)
                } else if indexPath.row == 1, let phoneNumber = location.phoneNumber {
                    locationCell.configure(using: phoneNumber, and: #imageLiteral(resourceName: "phone"))
                } else if indexPath.row == 1, let website = location.website {
                    locationCell.configure(using: website, and: #imageLiteral(resourceName: "compass"))
                } else if indexPath.row == 1 {
                    locationCell.configure(using: location.fullAddressWithNewlines, and: nil)
                    cell.selectionStyle = .none
                } else if indexPath.row == 2, let website = location.website {
                    locationCell.configure(using: website, and: #imageLiteral(resourceName: "compass"))
                } else if indexPath.row == 2 || indexPath.row == 3 {
                    locationCell.configure(using: location.fullAddressWithNewlines, and: nil)
                    cell.selectionStyle = .none
                }
            } else {
                locationCell.configure(for: location)
            }
        }
        
        return cell
    }
}

//extension LocationInfoViewController: LocationDelegate {
//    func selected(location: Location) {
//        self.location = location
//    }
//}

