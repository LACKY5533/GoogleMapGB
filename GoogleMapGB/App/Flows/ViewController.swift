//
//  ViewController.swift
//  GoogleMapGB
//
//  Created by LACKY on 16.05.2022.
//

import UIKit
import GoogleMaps
import Realm
import RealmSwift

class ViewController: UIViewController {

    @IBOutlet weak var mapView: GMSMapView!
    
    private var coordinate = CLLocationCoordinate2D(latitude: 55.7522200, longitude: 37.6155600)
    private var marker: GMSMarker?
    private var locationManager: CLLocationManager?
    private var route: GMSPolyline?
    private var routePath: GMSMutablePath?
    private var cllocationCoordinates = [CLLocation]()
    private var markers = [GMSMarker]()
    private var isTracking: Bool = false
    
    private let database = LocationRealmDB()
    private let locationObject = LocationObject()
    private var locationsArr = [Location]()
    private var locationsDB: Results<Location>?
    
    // MARK: Lifecycle methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureMap()
        configureLocationManager()
    }
    
    @IBAction func addMarkerButton(_ sender: Any) {
        marker == nil ? addMarker() : removeMarker()
    }
    
    @IBAction func actualLocationButton(_ sender: Any) {
        locationManager?.requestLocation()
    }
    
    @IBAction func beginTrackButton(_ sender: Any) {
        cllocationCoordinates.removeAll()
        route?.map = mapView
        locationManager?.startUpdatingLocation()
        isTracking = true
    }
    
    @IBAction func stopTrackButton(_ sender: Any) {
        markers.forEach { $0.map = nil }
        database.deleteAll()
        database.saveToRealm(cllocationCoordinates)
        route?.map = nil
        cllocationCoordinates.removeAll()
        locationManager?.stopUpdatingLocation()
        isTracking = false
    }
    
    @IBAction func lastRouteButton(_ sender: Any) {
        guard isTracking == false else { showAlert()
            return }
        cllocationCoordinates.removeAll()
        loadRoute(database.getPersistedRoutes(), index: 0)
        route?.map = nil
        route = GMSPolyline()
        routePath = GMSMutablePath()
        cllocationCoordinates.forEach { coordinate in
            routePath?.add(coordinate.coordinate)
        }
        route?.path = routePath
        route?.map = mapView
        let position = GMSCameraPosition.camera(withTarget: cllocationCoordinates.middle?.coordinate ?? CLLocationCoordinate2D(latitude: 55.7522200, longitude: 37.6155600), zoom: 15)
        mapView.animate(to: position)
    }
    
    private func configureMap() {
        let camera = GMSCameraPosition.camera(withTarget: coordinate, zoom: 15)
        mapView.camera = camera
        mapView.isMyLocationEnabled = true
        mapView.delegate = self
    }
    
    private func addMarker() {
        marker = GMSMarker(position: coordinate)
        marker?.icon = GMSMarker.markerImage(with: .green)
        marker?.map = mapView
        markers.append(marker!)
    }
    
    private func removeMarker() {
        marker?.map = nil
        marker = nil
    }
    
    private func configureLocationManager() {
        locationManager = CLLocationManager()
        locationManager?.delegate = self
        locationManager?.requestAlwaysAuthorization()
        locationManager?.requestWhenInUseAuthorization()
    }
    
    private func showAlert() {
        let alertVC = UIAlertController(title: "Error", message: "!!!", preferredStyle: .alert)
        let alertItem = UIAlertAction(title: "Okey", style: .cancel) { [weak self] _ in
            self?.database.deleteAll()
            self?.database.saveToRealm(self!.cllocationCoordinates)
            self?.route?.map = nil
            self?.cllocationCoordinates.removeAll()
            self?.locationManager?.stopUpdatingLocation()
            self?.isTracking = false
        }
        alertVC.addAction(alertItem)
        present(alertVC, animated: true)
    }
    
    private func loadRoute(_ routesArray: [LocationObject], index: Int = 0) {
        let currentRoute = routesArray[index]
        currentRoute.coordinates.forEach { coordinate in
            cllocationCoordinates.append(coordinate.clLocation)
        }
    }

}

extension ViewController: GMSMapViewDelegate {
    }

extension ViewController: CLLocationManagerDelegate {
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.last else { return }
        route = GMSPolyline()
        routePath = GMSMutablePath()
        routePath?.add(location.coordinate)
        route?.path = routePath
        let position = GMSCameraPosition.camera(withTarget: location.coordinate, zoom: 15)
        coordinate = location.coordinate
        mapView.animate(to: position)
        cllocationCoordinates.append(location)
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print(error)
    }
}
