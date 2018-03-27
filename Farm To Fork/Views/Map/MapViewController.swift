//
//  MapViewController.swift
//  Farm To Fork
//
//  Created by Domenic Bianchi on 2018-03-10.
//  Copyright © 2018 Domenic Bianchi & Marshall Asch. All rights reserved.
//

import UIKit
import MapKit
import UserNotifications

final class MapViewController: UIViewController {
    // MARK: - IBOutlets
    @IBOutlet private var mapView: MKMapView!
    @IBOutlet private var toolbar: UIToolbar!
    @IBOutlet private var toolbarView: UIView!
    @IBOutlet private var locationInfoView: UIView!
    
    // MARK: - Properties
    private let locationManager = CLLocationManager()
    private let viewModel = MapViewModel()
    private let locationPickerView = UIPickerView()
    private var textField: UITextField? = nil
    private var locationInfoViewTopSpaceConstraint: NSLayoutConstraint? = nil
    private var isLocationInfoViewPreviewing: Bool = false
    private weak var locationViewController: LocationInfoViewController? = nil
    private var resultSearchController: UISearchController!
    
    // MARK: - Lifcycle Functions
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let locationSearchController = storyboard?.instantiateViewController(withIdentifier: "searchViewController") as? LocationSearchViewController {
            resultSearchController = UISearchController(searchResultsController: locationSearchController)
            resultSearchController.searchResultsUpdater = locationSearchController
            locationSearchController.delegate = self
            
            let searchBar = resultSearchController.searchBar
            searchBar.placeholder = "Search for locations"
            searchBar.sizeToFit()
            
            resultSearchController.hidesNavigationBarDuringPresentation = false
            resultSearchController.dimsBackgroundDuringPresentation = true
            definesPresentationContext = true
            
            if #available(iOS 11.0, *) {
                navigationItem.searchController = resultSearchController
            } else {
                navigationItem.titleView = resultSearchController.searchBar
            }
        }
        
        let panGesture = UIPanGestureRecognizer(target: self, action: #selector(draggedView(_:)))
        locationInfoView.addGestureRecognizer(panGesture)
        locationInfoView.addShadow()
        
        locationInfoViewTopSpaceConstraint = view.constraints.first(where: { $0.firstAttribute == .top && ($0.firstItem as? UIView) == locationInfoView })
        locationInfoViewTopSpaceConstraint?.constant = view.frame.height
        view.layoutIfNeeded()
        
        viewModel.fetchEFPLocations { result in
            DispatchQueue.main.async {
                switch result {
                case .success():
                    self.locationPickerView.reloadAllComponents()
                    self.mapView.showAnnotations(self.viewModel.locationMarkers, animated: true)
                    (self.resultSearchController.searchResultsUpdater as? LocationSearchViewController)?.locations = self.viewModel.locations
                    
                case .error(let error):
                    self.displayAlert(title: "Error", message: error.customDescription)
                }
            }
        }
        
        toolbarView.applyBlurEffect(using: .extraLight, cornerRadius: 10, corners: [.allCorners])
        toolbarView.addShadow()
        
        //Credit: https://stackoverflow.com/a/16035779/4268022
        //Credit: https://stackoverflow.com/a/48369847/4268022
        toolbar.setBackgroundImage(UIImage(), forToolbarPosition: .any, barMetrics: .default)
        toolbar.setShadowImage(UIImage(), forToolbarPosition: .any)
        toolbar.backgroundColor = .clear
        
        toolbar.items = [MKUserTrackingBarButtonItem(mapView: mapView)]
        
        locationManager.delegate = self
        locationManager.requestAlwaysAuthorization()
        
        mapView.delegate = self
        
        if CLLocationManager.authorizationStatus() == .authorizedAlways {
            locationManager.startMonitoringSignificantLocationChanges()
            locationManager.allowsBackgroundLocationUpdates = true
            locationManager.pausesLocationUpdatesAutomatically = false
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        mapView.showAnnotations(viewModel.locationMarkers, animated: true)
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        
        mapView.userTrackingMode = .follow
    }
    
    // MARK: - IBActions
    @IBAction func preferredLocationButtonTapped(_ sender: Any) {
        if viewModel.isPreferredLocationSet {
            segueToNeeds()
        } else {
            promptForPreferredLocation()
        }
    }
    
    // MARK: - Helper Functions
    private func promptForPreferredLocation() {
        DispatchQueue.main.async {
            let alert = UIAlertController(title: "Preferred Location", message: "Please select your preferred Emergency Food Provider. You can change your preferred location at any time.", preferredStyle: .alert)
            let submitAction = UIAlertAction(title: "Save", style: .default) { _ in
                let selectedRow = self.locationPickerView.selectedRow(inComponent: 0)
                self.viewModel.setPreferredLocation(self.viewModel.locations[selectedRow])
                self.segueToNeeds()
            }
            /*let noLocationAction = UIAlertAction(title: "Can't find a location?", style: .default) { _ in
                //TODO: Display list from other cities
            }*/
            let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
            
            alert.addAction(submitAction)
            //alert.addAction(noLocationAction)
            alert.addAction(cancelAction)
            
            alert.addTextField() { addedTextField in
                self.locationPickerView.delegate = self
                addedTextField.inputView = self.locationPickerView
                addedTextField.placeholder = "Preferred Location"
                addedTextField.delegate = self
                self.textField = addedTextField
            }
            
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    private func segueToNeeds() {
        performSegue(withIdentifier: Constants.Segues.needsView, sender: self)
    }
    
    //Credit: https://stackoverflow.com/a/43714987/4268022
    @objc private func draggedView(_ sender: UIPanGestureRecognizer) {
        view.bringSubview(toFront: locationInfoView)
        let translation = sender.translation(in: view)
        guard locationInfoView.frame.origin.y + translation.y > mapView.frame.origin.y + 25 else {
            locationViewController?.setTableViewScrollable(isScrollable: true)
            return
        }
        if locationViewController?.isTableViewScrollable ?? false {
            locationViewController?.resetTableView()
            locationViewController?.setTableViewScrollable(isScrollable: false)
        }
        locationInfoView.center = CGPoint(x: locationInfoView.center.x, y: locationInfoView.center.y + translation.y)
        locationInfoViewTopSpaceConstraint?.constant += translation.y
        isLocationInfoViewPreviewing = false
        sender.setTranslation(.zero, in: view)
    }
    
    /// Calculates the distance between the given `point` and the current position of the user.
    private func distance(to point: MKAnnotation) -> Double? {
        guard let userLocation = mapView.userLocation.location else {
            return nil
        }
        let annotationLocation = CLLocation(latitude: point.coordinate.latitude, longitude: point.coordinate.longitude)
        return userLocation.distance(from: annotationLocation)
    }
    
    private func setLocationInfoHeight() {
        let heightConstraint = locationInfoView.constraints.first(where: { $0.firstAttribute == .height })
        heightConstraint?.constant = mapView.frame.height - 20
    }
    
    private func searchForNearbyGrocceryStores(from location: CLLocation) {
        let request = MKLocalSearchRequest()
        request.naturalLanguageQuery = "grocery store"
        // IMPORTANT NOTE: This only works when the map is following the user. If the map does not have the user in its region, the region will be incorrect.
        request.region = mapView.region
        let search = MKLocalSearch(request: request)
        
        search.start { response, _ in
            guard let response = response else {
                return
            }
            
            for mapItem in response.mapItems {
                guard let distance = self.distance(to: mapItem.placemark) else {
                    continue
                }
                if distance < 6000.0 {
                    guard let preferredLocationId = UserDefaults.appGroup?.string(forKey: Constants.preferredLocationId) else {
                        self.scheduleNotification(title: "Are you going grocery shopping?",
                                                  message: "Take a look at what food providers near you need so you can help out your community!")
                        break
                    }
                    NeedsService().fetchNeeds(forLocation: preferredLocationId, with: { result in
                        switch result {
                        case .success(let needs):
                            let names = needs.map { return $0.name }
                            self.scheduleNotification(title: "Are you going grocery shopping?",
                                                      message: "Your preferred food provider needs the following items: " + names.joined(separator: ", "))
                        case .error:
                            self.scheduleNotification(title: "Are you going grocery shopping?",
                                                      message: "Take a look at what food providers near you need so you can help out your community!")
                        }
                    })
                    break
                }
            }
        }
    }
    
    private func scheduleNotification(title: String, message: String) {
        UNUserNotificationCenter.current().getNotificationSettings(completionHandler: { result in
            if result.authorizationStatus == .authorized {
                let content = UNMutableNotificationContent()
                content.title = title
                content.body = message
                content.sound = UNNotificationSound.default()
                let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 1, repeats: false)
                let request = UNNotificationRequest(identifier: "FiveSecond", content: content, trigger: trigger)
                let center = UNUserNotificationCenter.current()
                center.add(request) { _ in }
            }
        })
    }
    
    private func calculateDirections(from userCoordinates: CLLocationCoordinate2D, to destinationCoordinates: CLLocationCoordinate2D, by transportType: MKDirectionsTransportType) {
        viewModel.calculateRoute(from: userCoordinates, to: destinationCoordinates, by: transportType) { response in
            self.mapView.removeOverlays(self.mapView.overlays)
            
            guard let unwrappedResponse = response,
                let route = unwrappedResponse.routes.first else {
                    self.displayAlert(title: "Error", message: "Unable to generate directions.")
                    return
            }
            
            self.mapView.add(route.polyline)
            let newRect = self.mapView.mapRectThatFits(route.polyline.boundingMapRect, edgePadding: UIEdgeInsetsMake(25, 25, 25, 25))
            self.mapView.setVisibleMapRect(newRect, animated: true)
        }
    }
    
    // MARK: - Segue Functions
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "locationInfoContainerSegue", let viewController = segue.destination as? LocationInfoViewController {
            locationViewController = viewController
            locationViewController?.delegate = self
            setLocationInfoHeight()
        } else if segue.identifier == Constants.Segues.needsView, let viewController = segue.destination.childViewControllers.first as? NeedsViewController, let location = locationViewController?.location {
            viewController.selectedLocation(location)
        }
    }
}

// MARK: - LocationDelegate
extension MapViewController: LocationDelegate {
    func selected(location: Location) {
        guard let selectedAnnotation = mapView.annotations.first(where: { ($0 as? EFPMarker)?.isEqual(location) ?? false }) else {
            return
        }
        
        mapView.selectAnnotation(selectedAnnotation, animated: true)
    }
}

// MARK: - LocationInfoDelegate
extension MapViewController: LocationInfoDelegate {
    func directionsRequested(to location: Location) {
        guard let userCoordinates = mapView.userLocation.location?.coordinate, let locationCoordinates = location.coordinates else {
            return
        }
        
        let alertController = UIAlertController(title: "Directions", message: "Select the type of directions you would like", preferredStyle: .actionSheet)
        
        let walkingDirections = UIAlertAction(title: "Walking", style: .default) { (UIAlertAction) in
            self.calculateDirections(from: userCoordinates, to: locationCoordinates, by: .walking)
        }
        
        let automobileDirections = UIAlertAction(title: "Automobile", style: .default) { (UIAlertAction) in
            self.calculateDirections(from: userCoordinates, to: locationCoordinates, by: .automobile)
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        
        alertController.addAction(walkingDirections)
        alertController.addAction(automobileDirections)
        alertController.addAction(cancelAction)
        
        present(alertController, animated: true, completion: nil)
    }
    
    func viewNeeds(for location: Location) {
       segueToNeeds()
    }
}

// MARK: - UITextFieldDelegate
extension MapViewController: UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        //Block all attempts to manually insert text into the text field. The only valid strings are ones that come from the `locationPickerView`
        return false
    }
}

// MARK: - UIPickerViewDelegate
extension MapViewController: UIPickerViewDelegate {
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if viewModel.locations.count > row {
            textField?.text = viewModel.locations[row].name
        }
    }
}

// MARK: - UIPickerViewDataSource
extension MapViewController: UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return viewModel.numberOfComponents
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return viewModel.numberOfRows(in: component)
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return viewModel.locations[row].name
    }
}

// MARK: - MKMapViewDelegate
extension MapViewController: MKMapViewDelegate {
    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
        guard let annotation = view.annotation, let location = viewModel.locations.first(where: { annotation.isEqual($0) }) else {
            return
        }
        location.distance = distance(to: annotation)
        locationViewController?.selected(location: location)
        
        if !isLocationInfoViewPreviewing {
            isLocationInfoViewPreviewing = true
            locationInfoViewTopSpaceConstraint?.constant = self.view.frame.height - 250
            self.view.refreshView()
        }
        
        mapView.setCenter(annotation.coordinate, animated: true)
    }
    
    func mapView(_ mapView: MKMapView, didDeselect view: MKAnnotationView) {
        isLocationInfoViewPreviewing = false
        locationInfoViewTopSpaceConstraint?.constant = self.view.frame.height
        self.view.refreshView()
    }
    
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        let polylineRenderer = MKPolylineRenderer(overlay: overlay)
        polylineRenderer.strokeColor = .blue
        polylineRenderer.lineWidth = 2
        return polylineRenderer
    }
}

// MARK: - CLLocationManagerDelegate
extension MapViewController: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        if status == .authorizedWhenInUse || status == .authorizedAlways {
            locationManager.startMonitoringSignificantLocationChanges()
            locationManager.allowsBackgroundLocationUpdates = true
            locationManager.pausesLocationUpdatesAutomatically = false
        } else {
            mapView.showsUserLocation = false
        }
        
        UNUserNotificationCenter.current().requestAuthorization(options: [.badge, .alert, .sound]) { _,_  in }
    }
    
    // https://developer.apple.com/documentation/corelocation/getting_the_user_s_location/using_the_significant_change_location_service
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.last else {
            return
        }
        searchForNearbyGrocceryStores(from: location)
        
    }
}
