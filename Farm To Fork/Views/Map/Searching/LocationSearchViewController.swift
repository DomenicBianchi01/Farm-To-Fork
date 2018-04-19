//
//  LocationSearchViewController.swift
//  Farm To Fork
//
//  Created by Domenic Bianchi on 2018-03-26.
//  Copyright © 2018 Domenic Bianchi & Marshall Asch. All rights reserved.
//

import UIKit

final class LocationSearchViewController: UIViewController {
    // MARK: - IBOutlets
    @IBOutlet private var tableView: UITableView!
    
    // MARK: - Properties
    var locations: [Location] = []
    private var matchedLocations: [Location] = []
    /// If this view controller is being used to show matching locations based on a search, the value of this variable should be `true`. If this view controller is being used to simply show the list of all EFP locations, the value of this should variable be `false`.
    var inSearchMode: Bool = true
    weak var delegate: LocationDelegate? = nil
    
    // MARK: - Lifecycle Functions
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.reloadData()
    }
    
    // MARK: - IBActions
    @IBAction func closeButtonTapped(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
}

// MARK: - UISearchResultsUpdating
extension LocationSearchViewController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        guard let searchText = searchController.searchBar.text?.lowercased() else {
            return
        }
        
        matchedLocations = locations.filter { $0.name.lowercased().contains(searchText) }
        tableView.reloadData()
    }
}

// MARK: - UITableViewDelegate
extension LocationSearchViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let location = inSearchMode ? matchedLocations[indexPath.row] : locations[indexPath.row]
        delegate?.selected(location: location)
        dismiss(animated: true, completion: nil)
    }
}

// MARK: - UITableViewDataSource
extension LocationSearchViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return inSearchMode ? matchedLocations.count : locations.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "matchedLocationReuseIdentifier", for: indexPath)
        
        if let cell = cell as? LocationConfigurable {
            let location = inSearchMode ? matchedLocations[indexPath.row] : locations[indexPath.row]
            cell.configure(for: location)
        }
        
        return cell
    }
}
