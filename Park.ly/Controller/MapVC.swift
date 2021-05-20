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
    var parkedCarAnnotation: ParkingSpot?

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
    
    @IBAction func parkButtonTapped(_ sender: RoundButton) {
        if mapView.annotations.count == 1 {
            guard let coordinates = LocationServices.shared.currentLocation else { return }
            setupAnnotation(coordinate: coordinates)
        } else {
            // move annotations
        }
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
    
    func setupAnnotation(coordinate: CLLocationCoordinate2D) {
        parkedCarAnnotation = ParkingSpot(title: "We parked here", subtitle: "Tap for directions", coordinate: coordinate)
        mapView.addAnnotation(parkedCarAnnotation!)
    }
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        if let annotation = annotation as? ParkingSpot {
            let id = "pin"
            let view = MKPinAnnotationView(annotation: annotation, reuseIdentifier: id)
            view.canShowCallout = true
            view.animatesDrop = true
            view.pinTintColor = .red
            view.calloutOffset = CGPoint(x: -8, y: -3)
            view.rightCalloutAccessoryView = UIButton(type: .detailDisclosure)
            return view
        }
        return nil
    }
}

extension MapVC: CustomUserLocDelegate {
    func userLocationUpdated(location: CLLocation) {
        centerMapOnUserLocation(coordinates: location.coordinate)
    }
}
