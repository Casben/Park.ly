//
//  LocationManager.swift
//  Park.ly
//
//  Created by Herbert Dodge on 5/20/21.
//

import Foundation
import CoreLocation

protocol CustomUserLocDelegate {
    func userLocationUpdated(location: CLLocation)
}

class LocationServices: NSObject, CLLocationManagerDelegate {
    static let shared = LocationServices()
    
    var customUserLocDelegate: CustomUserLocDelegate?
    
    var locationManager = CLLocationManager()
    var currentLocation: CLLocationCoordinate2D?
    
    override init() {
        super.init()
        self.locationManager.delegate = self
        self.locationManager.desiredAccuracy = kCLLocationAccuracyBest
        self.locationManager.distanceFilter = 50
        self.locationManager.startUpdatingLocation()
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        self.currentLocation = manager.location?.coordinate
        
        if customUserLocDelegate != nil {
            customUserLocDelegate?.userLocationUpdated(location: locations.first!)
        }
    }
}
