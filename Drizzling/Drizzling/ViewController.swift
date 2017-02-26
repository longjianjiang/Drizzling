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
import Social

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
    
    var router = DrizzlingRouter()
    var fetcher = DrizzlingFetcher()

    lazy var pressShare: UILongPressGestureRecognizer = {
        let gesture = UILongPressGestureRecognizer(target: self, action: #selector(showShareView))
        gesture.minimumPressDuration = 1
        return gesture
    }()
    
    
    func showShareView() {
        if (pressShare.state == UIGestureRecognizerState.began) {
            print("begin press")
            
            // text to share
            let text = "This is a small but useful weather app."
            let appURL = URL(string: "http://www.longjianjiang.com")
            
            
            // set up activity view controller
            let textToShare = [text,appURL!] as [Any]
            let activityViewController = UIActivityViewController(activityItems: textToShare, applicationActivities: nil)
            activityViewController.popoverPresentationController?.sourceView = self.view // so that iPads won't crash
            
            activityViewController.completionWithItemsHandler = {(type, _, _, error) in
                if error == nil {
                    print("share success")
                } else {
                    print("share failure")
                }
                
            }
            // present the view controller
            self.present(activityViewController, animated: true, completion: nil)
            
            
        }else if (pressShare.state == UIGestureRecognizerState.ended){
            print("end press")
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        locationManager.startUpdatingLocation()
        
        
        let forecastThreeDayURL = router.getThreeDayForecastURLWithComponents(APIKey: "38e25298c490dffs", CountryOrProvinceName: "China", cityName: "Nanjing")
        fetcher.getThreeDayForecast(url: forecastThreeDayURL) { (result) in
            switch result {
            case let .success(_days):
                self.forecastDayArr = _days;
            case let .failure(_error):
                print("Error fetching days: \(_error.forecastErrorDescription)")
            }
        }

        self.view.addGestureRecognizer(pressShare)
       
        
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
                    UIApplication.shared.openURL(URL(string: UIApplicationOpenSettingsURLString)!)
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
