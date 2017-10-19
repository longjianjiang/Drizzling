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

class LJLocationManager: NSObject {
    
    static let shared = LJLocationManager()
    weak var authorizationDelegate: LJLocationManagerAuthorizationDelegate?
    var locationManager: CLLocationManager!
    
    override init() {
        super.init()
        locationManager = CLLocationManager.init()
        locationManager.delegate = self
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
}
