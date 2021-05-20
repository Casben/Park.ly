//
//  ViewController.swift
//  Park.ly
//
//  Created by Herbert Dodge on 5/20/21.
//

import UIKit
import CoreLocation

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        checkLocationAuthStatus()
    }

}

extension ViewController {
    func checkLocationAuthStatus() {
        if LocationServices.shared.locationManager.authorizationStatus == .authorizedWhenInUse {
            print("location service enabled")
        } else {
            LocationServices.shared.locationManager.requestWhenInUseAuthorization()
        }
    }
}
