//
//  ViewController.swift
//  GoogleMapGB
//
//  Created by LACKY on 16.05.2022.
//

import UIKit
import GoogleMaps

class ViewController: UIViewController {

    @IBOutlet weak var mapView: GMSMapView!
    
    private var coordinate = CLLocationCoordinate2D(latitude: 55.7522200, longitude: 37.6155600)
    private var marker: GMSMarker?
    private var locationManager: CLLocationManager?
    
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
    
    @IBAction func UpdateButton(_ sender: Any) {
        locationManager?.startUpdatingLocation()
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

}

extension ViewController: GMSMapViewDelegate {
    }

extension ViewController: CLLocationManagerDelegate {
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        print(coordinate)
        let manualMarker = GMSMarker(position: coordinate)
        manualMarker.map = mapView
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print(error)
    }
}
