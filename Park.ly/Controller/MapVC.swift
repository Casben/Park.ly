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
    @IBOutlet weak var parkButton: RoundButton!
    @IBOutlet weak var directionButton: RoundButton!
    var parkedCarAnnotation: ParkingSpot?

    override func viewDidLoad() {
        super.viewDidLoad()
        checkLocationAuthStatus()
        configure()
    }
    
    func configure() {
        mapView.delegate = self
        directionButton.isEnabled = false
        setupLongPress()
    }
    
    @IBAction func resetMapCenter(_ sender: RoundButton) {
        guard let coordinates = LocationServices.shared.currentLocation else { return }
        centerMapOnUserLocation(coordinates: coordinates)
    }
    
    @IBAction func parkButtonTapped(_ sender: RoundButton) {
        mapView.removeAnnotations(mapView.annotations)
        
        if parkedCarAnnotation == nil {
            guard let coordinates = LocationServices.shared.currentLocation else { return }
            setupAnnotation(coordinate: coordinates)
            parkButton.setImage(#imageLiteral(resourceName: "foundCar"), for: .normal)
            directionButton.isEnabled = true
        } else {
            parkButton.setImage(#imageLiteral(resourceName: "parkCar"), for: .normal)
            parkedCarAnnotation = nil
            directionButton.isEnabled = false
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
            view.pinTintColor = .systemIndigo
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

extension MapVC {
    func setupLongPress() {
        let longPress = UILongPressGestureRecognizer(target: self, action: #selector(hanldeLongPress))
        longPress.minimumPressDuration = 0.75
        mapView.addGestureRecognizer(longPress)
    }
    
    @objc func hanldeLongPress(_ gesture: UILongPressGestureRecognizer) {
        mapView.removeAnnotations(mapView.annotations)
        
        if gesture.state == .ended {
            let point = gesture.location(in: mapView)
            let coordinate = mapView.convert(point, toCoordinateFrom: mapView)
            setupAnnotation(coordinate: coordinate)
            parkButton.setImage(#imageLiteral(resourceName: "foundCar"), for: .normal)
            directionButton.isEnabled = true
        }
    }
}
