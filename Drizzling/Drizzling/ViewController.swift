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
import SnapKit
import Kingfisher
import UserNotifications


class ViewController: UIViewController {
    
    //MARK: - property
    let center = UNUserNotificationCenter.current()
    
    var currentCity: String! = nil
    var currentCountry: String! = nil
    var currentProvince: String! = nil
    
    var forecastDayArr: [ForecastDay] = []
    
    var router = DrizzlingRouter()
    var fetcher = DrizzlingFetcher()
    
    lazy var locationManager: CLLocationManager = {
        let manager = CLLocationManager()
        manager.delegate = self
        manager.requestWhenInUseAuthorization()
        return manager
    }()
    
    lazy var geocoder: CLGeocoder = {
        return CLGeocoder()
    }()
    
    lazy var pressShare: UILongPressGestureRecognizer = {
        let gesture = UILongPressGestureRecognizer(target: self, action: #selector(showShareView))
        gesture.minimumPressDuration = 1
        return gesture
    }()
    
    lazy var cityLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        if DeviceType.IS_IPHONE_5 {
            label.font = UIFont.systemFont(ofSize: 30)
        }
        label.textColor = UIColor.black
        return label
    }()
    
    lazy var temperatureConditionLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        if DeviceType.IS_IPHONE_5 {
            label.font = UIFont.systemFont(ofSize: 30)
        }
        label.textColor = UIColor.black
        return label
    }()
    lazy var temperatureNumberLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        if DeviceType.IS_IPHONE_5 {
            label.font = UIFont.systemFont(ofSize: 80)
        }
        label.numberOfLines = 0
        label.textColor = UIColor.black
        return label
    }()
    
    lazy var shareTextview: KMPlaceholderTextView = {
        let textview = KMPlaceholderTextView()
        textview.placeholder = "write some thing about today's weather?"
        if DeviceType.IS_IPHONE_5 {
            textview.font = UIFont.systemFont(ofSize: 20)
        }
        return textview
    }()
    
    
    
    //MARK: - life cycle
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        locationManager.startUpdatingLocation()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.white

        self.view.addSubview(temperatureConditionLabel)
        self.view.addSubview(temperatureNumberLabel)
        self.view.addSubview(cityLabel)
        self.view.addSubview(shareTextview)
        
        temperatureConditionLabel.snp.makeConstraints { (maker) in
            if DeviceType.IS_IPHONE_5 {
                maker.top.equalTo(self.view).offset(30)
                maker.left.right.equalTo(self.view)
                maker.height.equalTo(40)
            }
            maker.top.equalTo(self.view).offset(44)
            maker.left.right.equalTo(self.view)
            maker.height.equalTo(60)
        }
        temperatureNumberLabel.snp.makeConstraints { (maker) in
            if DeviceType.IS_IPHONE_5 {
                maker.top.equalTo(temperatureConditionLabel.snp.bottom).offset(20)
                maker.left.right.equalTo(self.view)
                maker.height.equalTo(100)
            }

            maker.top.equalTo(temperatureConditionLabel.snp.bottom).offset(20)
            maker.left.right.equalTo(self.view)
            maker.height.equalTo(100)
        }
        
        shareTextview.snp.makeConstraints { (maker) in
            if DeviceType.IS_IPHONE_5 {
                maker.top.equalTo(temperatureNumberLabel.snp.bottom).offset(20)
                maker.left.equalTo(self.view).offset(10)
                maker.right.equalTo(self.view).offset(-5)
                maker.height.equalTo(100)
            }
            maker.top.equalTo(temperatureNumberLabel.snp.bottom).offset(50)
            maker.left.equalTo(self.view).offset(10)
            maker.right.equalTo(self.view).offset(-5)
            maker.height.equalTo(200)
        }
        cityLabel.snp.makeConstraints { (maker) in
            if DeviceType.IS_IPHONE_5 {
                maker.bottom.equalTo(self.view).offset(-20)
                maker.left.right.equalTo(self.view)
                maker.height.equalTo(40)
            }
            maker.bottom.equalTo(self.view).offset(-20)
            maker.left.right.equalTo(self.view)
            maker.height.equalTo(60)
        }
        
        self.view.addGestureRecognizer(pressShare)
        
        
        
/**
        let content = UNMutableNotificationContent()
        content.title = "Don't forget"
        content.body = "Buy some milk"
        content.sound = UNNotificationSound.default()
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 300,
                                                        repeats: false)
        let identifier = "UYLLocalNotification"
        let request = UNNotificationRequest(identifier: identifier,
                                            content: content, trigger: trigger)
        center.add(request, withCompletionHandler: { (error) in
            if let error = error {
                // Something went wrong
            }
        })
 */
        
    }

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }

    //MARK: - response method
    func showShareView() {
        if (pressShare.state == UIGestureRecognizerState.began) {
            print("begin press")
            
            // text to share
            let text = "This is a small but beautiful weather app."
            let appURL = URL(string: "http://www.longjianjiang.com")
            
            
            // set up activity view controller
            let textToShare = [text,appURL!] as [Any]
            let activityViewController = UIActivityViewController(activityItems: textToShare, applicationActivities: nil)
            activityViewController.popoverPresentationController?.sourceView = self.view // so that iPads won't crash
            
            // present the view controller
            self.present(activityViewController, animated: true, completion: nil)
            
        }else if (pressShare.state == UIGestureRecognizerState.ended){
            print("end press")
        }
    }
    
    //MARK: - status bar
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
                self.currentCountry = pl.country // China
                self.currentCity = pl.locality   // Nanjing
                self.currentProvince = pl.administrativeArea // Jiangsu
                
                var url: URL? = nil
                let currentLang = Locale.preferredLanguages.first
                
                if pl.isoCountryCode == "CN" { // In China
                    if currentLang == "zh-Hans-CN" || currentLang == "zh-Hant-CN" {
                        url = self.router.getThreeDayForecastURLWithComponents(APIKey: "38e25298c490dffc", CountryOrProvinceName: "China", cityName: self.currentCity.transformToPinYin())
                    } else {
                        url = self.router.getThreeDayForecastURLWithComponents(APIKey: "38e25298c490dffc", CountryOrProvinceName: "China", cityName: self.currentCity)
                    }
                } else { // Other country
                    let countryAndProvince = "\(pl.isoCountryCode)/\(self.currentProvince)"
                    url = self.router.getThreeDayForecastURLWithComponents(APIKey: "38e25298c490dffc", CountryOrProvinceName: countryAndProvince, cityName: self.currentCity)
                }
                
//                self.fetcher.getThreeDayForecast(url: url!, completion: { (result) in
//                    print("fetch data")
//                    switch result {
//                    case let .success(_days):
//                        self.forecastDayArr = _days
//                        let unitStr = UserDefaults.standard.object(forKey: "unit") as! String
//                        if let icon = _days.first?.forecastIcon, let low = _days.first?.forecastLowTemperature?[unitStr],
//                            let high = _days.first?.forecastHighTemperature?[unitStr]{
//                            self.temperatureLabel.text = "\(high) / \(low)"
//    
//                        }
//    
//                    case let .failure(_error):
//                        print(_error.forecastErrorDescription ?? "error")
//                    }
//                })
                self.cityLabel.text = pl.locality
                self.temperatureConditionLabel.text = "Partly cloudy"
                self.temperatureNumberLabel.text = "18"
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
}
