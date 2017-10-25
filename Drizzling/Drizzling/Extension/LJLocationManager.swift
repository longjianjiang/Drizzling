//
//  LJLocationManager.swift
//  Drizzling
//
//  Created by longjianjiang on 2017/10/19.
//  Copyright © 2017年 Jiang. All rights reserved.
//

import UIKit
import MapKit

protocol LJLocationManagerAuthorizationDelegate: class {
    func locationManager(_ manager: LJLocationManager, userDidChooseLocation status: CLAuthorizationStatus)
}

protocol LJLocationManagerGetLocationDelegate: class {
    func locationManager(_ manager: LJLocationManager, current city: String)
}

class LJLocationManager: NSObject {
    
    static let shared = LJLocationManager()
    weak var authorizationDelegate: LJLocationManagerAuthorizationDelegate?
    weak var getLocationDelegate: LJLocationManagerGetLocationDelegate?
    var locationManager: CLLocationManager!
    
    lazy var geocoder: CLGeocoder = {
        return CLGeocoder()
    }()
    override init() {
        super.init()
        locationManager = CLLocationManager.init()
        locationManager.delegate = self
    }
    
    public func isLocationServiceEnable() -> Bool {
        if CLLocationManager.locationServicesEnabled() {
            let authStatus = CLLocationManager.authorizationStatus()
            switch authStatus {
            case .authorizedAlways, .authorizedWhenInUse:
                return true
            default:
                return false
            }
        }
        return false
    }
    
    public func askLocation() {
        if CLLocationManager.locationServicesEnabled() {
            locationManager.requestWhenInUseAuthorization()
        }
    }
    
    public func startUseLocation() {
        locationManager.startUpdatingLocation()
    }
    
}


extension LJLocationManager: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
       authorizationDelegate?.locationManager(self, userDidChooseLocation: status)
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        locationManager.stopUpdatingLocation()
        guard let currentLocation = locations.last else { return }
        geocoder.reverseGeocodeLocation(currentLocation) { (places: [CLPlacemark]?, error: Error?) in
            if error == nil { // normal condition
                guard let pl = places?.first else { return }
                if let city = pl.locality {
                    self.getLocationDelegate?.locationManager(self, current: city)
                }
            } else {
                print("reverse geocode location error: \(error)") 
            }
        }
    }
}
