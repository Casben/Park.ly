//
//  ViewController.swift
//  Park.ly
//
//  Created by Herbert Dodge on 5/20/21.
//

import UIKit
import MapKit

class MapVC: UIViewController {
    
    @IBOutlet weak var mapView: MKMapView!

    override func viewDidLoad() {
        super.viewDidLoad()
        checkLocationAuthStatus()
        configure()
    }
    
    func configure() {
        mapView.delegate = self
    }
    
    @IBAction func resetMapCenter(_ sender: RoundButton) {
        guard let coordinates = LocationServices.shared.currentLocation else { return }
        centerMapOnUserLocation(coordinates: coordinates)
    }

}

extension MapVC: MKMapViewDelegate {
    func checkLocationAuthStatus() {
        if LocationServices.shared.locationManager.authorizationStatus == .authorizedWhenInUse {
            mapView.showsUserLocation = true
            LocationServices.shared.customUserLocDelegate = self
        } else {
            LocationServices.shared.locationManager.requestWhenInUseAuthorization()
        }
    }
    
    func centerMapOnUserLocation(coordinates: CLLocationCoordinate2D) {
        let region = MKCoordinateRegion(center: coordinates, latitudinalMeters: 1000, longitudinalMeters: 1000)
        self.mapView.setRegion(region, animated: true)
    }
}

extension MapVC: CustomUserLocDelegate {
    func userLocationUpdated(location: CLLocation) {
        centerMapOnUserLocation(coordinates: location.coordinate)
    }
}
