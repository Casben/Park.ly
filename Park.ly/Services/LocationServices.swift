//
//  LocationManager.swift
//  Park.ly
//
//  Created by Herbert Dodge on 5/20/21.
//

import Foundation
import CoreLocation

class LocationServices: NSObject, CLLocationManagerDelegate {
    static let shared = LocationServices()
    
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
    }
}
