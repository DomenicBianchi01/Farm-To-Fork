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
import DeviceKit

final class MapViewController: UIViewController {
    // MARK: - IBOutlets
    @IBOutlet private var mapView: MKMapView!
    @IBOutlet private var locationInfoView: UIView!
    
    // MARK: - Properties
    private let locationManager = CLLocationManager()
    private let viewModel = MapViewModel()
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

            navigationItem.searchController = resultSearchController
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
                    self.mapView.showAnnotations(self.viewModel.locationMarkers, animated: true)
                    (self.resultSearchController.searchResultsUpdater as? LocationSearchViewController)?.locations = self.viewModel.locations
                    
                case .error(let error):
                    self.displaySCLAlert("Error", message: error.description, style: .error)
                }
            }
        }
        
        if CLLocationManager.locationServicesEnabled() && (CLLocationManager.authorizationStatus() == .authorizedAlways || CLLocationManager.authorizationStatus() == .authorizedWhenInUse) {
            navigationItem.rightBarButtonItem = MKUserTrackingBarButtonItem(mapView: mapView)
        }
        
        locationManager.delegate = self
        locationManager.requestAlwaysAuthorization()
        
        mapView.delegate = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        mapView.showAnnotations(viewModel.locationMarkers, animated: true)
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        
        mapView.userTrackingMode = .follow
        //200 meters in all directions
        let viewRegion = MKCoordinateRegion.init(center: CLLocationCoordinate2D(), latitudinalMeters: 200, longitudinalMeters: 200)
        let adjustedRegion = mapView.regionThatFits(viewRegion)
        mapView.setRegion(adjustedRegion, animated: false)
    }
    
    // MARK: - Helper Functions
    private func segueToNeeds() {
        performSegue(withIdentifier: Constants.Segues.needsView, sender: self)
    }
    
    //Credit: https://stackoverflow.com/a/43714987/4268022
    @objc private func draggedView(_ sender: UIPanGestureRecognizer) {
        view.bringSubviewToFront(locationInfoView)
        let translation = sender.translation(in: view)
        guard locationInfoView.frame.origin.y + translation.y > mapView.frame.origin.y + 25 else {
            locationViewController?.setTableViewScrollable(isScrollable: true)
            return
        }
        if locationViewController?.isTableViewScrollable ?? false {
            locationViewController?.resetTableView()
            locationViewController?.setTableViewScrollable(isScrollable: false)
        }
        
        let heightOffset: CGFloat
        if Device() == .iPhoneX || Device() == Device.simulator(.iPhoneX) { //The second half of this conditional is included so it will work on simulators
            heightOffset = 100
        } else {
            heightOffset = 75
        }
        
        guard locationInfoView.frame.origin.y + translation.y < view.frame.height - heightOffset else {
            return
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
        heightConstraint?.constant = view.frame.height
    }
    
    private func searchForNearbyGrocceryStores(from location: CLLocation) {
        let request = MKLocalSearch.Request()
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
                //TODO: Make this value smaller in production
                if distance < 6000.0 {
                    guard let preferredLocationId = UserDefaults.appGroup?.integer(forKey: Constants.preferredLocationId) else {
                        self.scheduleNotification(title: "Are you going grocery shopping?",
                                                  message: "Take a look at what food providers near you need so you can help out your community!")
                        break
                    }

                    NeedsService().fetchNeeds(forLocation: preferredLocationId) { result in
                        switch result {
                        case .success(let needs):
                            let names = needs.map { return $0.name }
                            self.scheduleNotification(title: "Are you going grocery shopping?",
                                                      message: "Your preferred food provider needs the following items: " + names.joined(separator: ", "))
                        case .error:
                            self.scheduleNotification(title: "Are you going grocery shopping?",
                                                      message: "Take a look at what food providers near you need so you can help out your community!")
                        }
                    }
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
                content.sound = UNNotificationSound.default
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
            
            guard let route = response?.routes.first else {
                self.displaySCLAlert("Error", message: "Unable to generate directions.", style: .error)
                return
            }
            
            self.mapView.addOverlay(route.polyline)
            let newRect = self.mapView.mapRectThatFits(route.polyline.boundingMapRect, edgePadding: UIEdgeInsets.init(top: 25, left: 25, bottom: 25, right: 25))
            self.mapView.setVisibleMapRect(newRect, animated: true)
        }
    }
    
    // MARK: - Segue Functions
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "locationInfoContainerSegue", let viewController = segue.destination as? LocationInfoViewController {
            locationViewController = viewController
            locationViewController?.delegate = self
            setLocationInfoHeight()
        } else if segue.identifier == Constants.Segues.needsView, let viewController = segue.destination.children.first as? NeedsViewController, let location = locationViewController?.location {
            viewController.selectedLocation(location)
            viewController.viewModel.hideCloseButton = false
        } else if segue.identifier == Constants.Segues.viewLocations, let viewController = segue.destination.children.first as? LocationSearchViewController {
            viewController.inSearchMode = false
            viewController.locations = viewModel.locations
            viewController.delegate = self
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
        guard let userCoordinates = mapView.userLocation.location?.coordinate else {
            if CLLocationManager.locationServicesEnabled() {
                if CLLocationManager.authorizationStatus() == .authorizedWhenInUse || CLLocationManager.authorizationStatus() == .authorizedAlways {
                    displaySCLAlert("Location Error", message: "Could not determine user location", style: .error)
                } else {
                    displaySCLAlert("Location Services", message: "Please enable location services to get directions", style: .info)
                }
            } else {
                displaySCLAlert("Location Services", message: "Please enable location services to get directions", style: .info)
            }
            return
        }
        
        let alertController = UIAlertController(title: "Directions", message: "Select the type of directions you would like", preferredStyle: UIDevice.alertStyle)
        
        let walkingDirections = UIAlertAction(title: "Walking", style: .default) { (UIAlertAction) in
            self.calculateDirections(from: userCoordinates, to: location.coordinates, by: .walking)
        }
        
        let automobileDirections = UIAlertAction(title: "Automobile", style: .default) { (UIAlertAction) in
            self.calculateDirections(from: userCoordinates, to: location.coordinates, by: .automobile)
        }
        
        alertController.addAction(walkingDirections)
        alertController.addAction(automobileDirections)
        alertController.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        
        alertController.popoverPresentationController?.sourceView = view
        alertController.popoverPresentationController?.sourceRect = view.bounds
        
        present(alertController, animated: true, completion: nil)
    }
    
    func viewNeeds(for location: Location) {
       segueToNeeds()
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
            UIView.animate(withDuration: 0.5) {
                self.locationInfoViewTopSpaceConstraint?.constant = mapView.frame.height - 210
                self.view.layoutIfNeeded()
            }
        }
        
        mapView.setCenter(annotation.coordinate, animated: true)
    }
    
    func mapView(_ mapView: MKMapView, didDeselect view: MKAnnotationView) {
        isLocationInfoViewPreviewing = false
        UIView.animate(withDuration: 0.5) {
            self.locationInfoViewTopSpaceConstraint?.constant = self.view.frame.height
            self.view.layoutIfNeeded()
        }
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
        if status == .authorizedAlways {
            locationManager.startMonitoringSignificantLocationChanges()
            locationManager.allowsBackgroundLocationUpdates = true
            locationManager.pausesLocationUpdatesAutomatically = false
            mapView.showsUserLocation = true
        } else if status == .authorizedWhenInUse {
            mapView.showsUserLocation = true
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
