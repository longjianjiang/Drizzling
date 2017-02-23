//
//  ViewController.swift
//  Drizzling
//
//  Created by longjianjiang on 2017/2/7.
//  Copyright © 2017年 Jiang. All rights reserved.
//

import UIKit
import MapKit
import Alamofire
import SwiftyJSON
import ObjectMapper


class ViewController: UIViewController {

    lazy var locationManager: CLLocationManager = {
        let manager = CLLocationManager()
        manager.delegate = self
        manager.requestWhenInUseAuthorization()
        return manager
    }()
    
    lazy var geocoder: CLGeocoder = {
        return CLGeocoder()
    }()
    
    var currentCity: String! = nil
    var currentCountry: String! = nil
    var forecastDayArr: [ForecastDay] = []
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        locationManager.startUpdatingLocation()
        
//        Alamofire.request("https://api.wunderground.com/api/38e25298c490dffc/forecast/q/China/Nanjing.json").responseJSON { (response) in
//            if let JSONObject = response.result.value {
//                let forecastDays = JSON(JSONObject)["forecast"]["simpleforecast"]["forecastday"].array
//                for obj in forecastDays! {
//                    self.forecastDayArr.append(ForecastDay(JSONString: obj.rawString()!)!)
//                }
//                
//                
//            }
//        }
        
       
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    override var prefersStatusBarHidden: Bool {
        return true
    }
}


// MARK: - CLLocationManagerDelegate
extension ViewController: CLLocationManagerDelegate {
    // when the location is enabled and get the location info then will invoked.
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        manager.stopUpdatingLocation()
        
        guard let CurrentLocation = locations.last else {
            return
        }
        
        geocoder.reverseGeocodeLocation(CurrentLocation) { (places: [CLPlacemark]?, error: Error?) in
            if error == nil { // normal condition
                guard let pl = places?.first else {return}
                self.currentCountry = pl.country
                self.currentCity = pl.locality
                print("current city is \(pl.locality), country is \(pl.country)")
            } else { // no internet condition
                let alertVC = UIAlertController(title: "Drizzling uses the internet to show the weather.\nAre you connected?", message: nil, preferredStyle: .alert)
                let okAction = UIAlertAction(title: "Got it", style: .default, handler: nil)
                alertVC.addAction(okAction)
                self.present(alertVC, animated: true, completion: nil)
            }
        }
    }
    
    // when the location service not enabled will invoked.
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        let alertVC = UIAlertController(title: "Use the location show the weather where you are.", message: nil, preferredStyle: .alert)
        
        let openLocationAction = UIAlertAction(title: "Ok", style: .default) { (action: UIAlertAction) in
            if let appSettings = URL(string: UIApplicationOpenSettingsURLString) {
                if #available(iOS 10.0, *) {
                    UIApplication.shared.open(appSettings, options: [:], completionHandler: nil)
                } else {
                    // Fallback on earlier versions
                }
            }
        }
        
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .default, handler: nil)
        
        alertVC.addAction(openLocationAction)
        alertVC.addAction(cancelAction)
        
        present(alertVC, animated: true, completion: nil)
    }
    
    
//    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
//        switch status {
//        case .authorizedWhenInUse:
//            manager.startUpdatingLocation()
//        default:
//            return
//        }
//    }
    
}
