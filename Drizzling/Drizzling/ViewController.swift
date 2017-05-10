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
    var currentCity: String! = nil
    var currentCountry: String! = nil
    var currentProvince: String! = nil
    
    var forecastDayArr: [ForecastDay] = []
    
    var router = DrizzlingRouter()
    var fetcher = DrizzlingFetcher()
    
    var threeDaysForecastView = ThreeDaysForecastView()
    
    var timer = Timer()

    let introduceView = IntroduceView()
    
    
    
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
    
    lazy var pullDownShowThreeDays: UIPanGestureRecognizer = {
        let gesture = UIPanGestureRecognizer(target: self, action: #selector(showThreeDaysCondition(gesture:)))
        return gesture
    }()
    //MARK: - lazy property
    lazy var cityLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        if DeviceType.IS_IPHONE_5 {
            label.font = UIFont.systemFont(ofSize: 30)
        } else  {
            label.font = UIFont.systemFont(ofSize: 40)
        }
        label.textColor = UIColor.black
        return label
    }()
    
    lazy var temperatureConditionLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        if DeviceType.IS_IPHONE_5 {
            label.font = UIFont.systemFont(ofSize: 30)
        }else  {
            label.font = UIFont.systemFont(ofSize: 40)
        }

        label.textColor = UIColor.black
        return label
    }()
    lazy var temperatureNumberLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        if DeviceType.IS_IPHONE_5 {
            label.font = UIFont.systemFont(ofSize: 80)
        } else  {
            label.font = UIFont.systemFont(ofSize: 100)
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
        } else  {
            textview.font = UIFont.systemFont(ofSize: 25)
        }

        return textview
    }()
    
    
    // update the weather condition one hour a time.
    func updateCondition() {
        timer = Timer.scheduledTimer(timeInterval: 60*60, target: self, selector: #selector(updateHourCondition), userInfo: nil, repeats: true)
    }
    
    func updateHourCondition() {
        self.locationManager.startUpdatingLocation()
    }
    func getTheTomorrowForecast() -> String{
        var msg: String! = "open the app to know tomorrow weather forecast 😄"
        let unitStr = UserDefaults.standard.object(forKey: "unit") as! String
        if forecastDayArr.count > 0 {
            let forecast = forecastDayArr[1]
            
            if  let low = forecast.forecastLowTemperature?[unitStr],
                let high = forecast.forecastHighTemperature?[unitStr],
                let condition = forecast.forecastCondition{
                if condition.contains("Rain") {
                    msg = "remember to bring a umbrella, temperature is \(high) - \(low)"
                } else {
                    msg = "\(condition), temperature is \(high) - \(low)"
                }
            }
        }
        return msg
    }

    //MARK: - life cycle
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        locationManager.startUpdatingLocation()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
    }
    override func viewDidLoad() {
        super.viewDidLoad()

        self.view.backgroundColor = UIColor.white
        updateCondition()
        setUpView()
        
        // add the first introduction for users.
        let isFirstTime = UserDefaults.standard.object(forKey: "FirstToUse")
        if isFirstTime == nil { // mean first time to use this app.
            self.view.addSubview(introduceView)
            introduceView.snp.makeConstraints { (maker) in
                maker.edges.equalTo(self.view)
            }
            UserDefaults.standard.set(false, forKey: "FirstToUse")
            UserDefaults.standard.synchronize()
        }
    
        // add observer to response change theme notification
        NotificationCenter.default.addObserver(self, selector: #selector(changeTheme), name: NSNotification.Name(rawValue: "ChangeThemeNotification"), object: nil)
        
        
        // add observer to share image when user did screenshot
        NotificationCenter.default.addObserver(self, selector: #selector(shareScreenshot), name: NSNotification.Name.UIApplicationUserDidTakeScreenshot, object: nil)
        
    }

   
    func setUpView() {
        self.view.addSubview(threeDaysForecastView)
        threeDaysForecastView.backgroundColor = UIColor.red
        threeDaysForecastView.snp.makeConstraints { (maker) in
            maker.left.right.equalTo(self.view)
            maker.bottom.equalTo(self.view.snp.top)
            maker.height.equalTo(150)
        }
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
                maker.height.equalTo(100)
            } else {
                if DeviceType.IS_IPHONE_6 {
                    maker.top.equalTo(temperatureNumberLabel.snp.bottom).offset(30)
                    maker.height.equalTo(150)
                } else {
                    maker.top.equalTo(temperatureNumberLabel.snp.bottom).offset(40)
                    maker.height.equalTo(200)
                }
            }
            
            maker.left.equalTo(self.view).offset(10)
            maker.right.equalTo(self.view).offset(-5)
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
        self.view.addGestureRecognizer(pullDownShowThreeDays)

    }
    
    deinit {
        timer.invalidate()
        NotificationCenter.default.removeObserver(self)
    }
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }

    //MARK: - response method
    func shareScreenshot() {
        let screenshotImage = self.screenshot()
        
        let activityItem: [AnyObject] = [screenshotImage as AnyObject]
        let activityViewController = UIActivityViewController(activityItems: activityItem as [AnyObject], applicationActivities: nil)
        self.present(activityViewController, animated: true, completion: nil)
    }
    func changeTheme() {
        self.view.backgroundColor = UIColor.black
        self.shareTextview.backgroundColor = UIColor.black
        self.cityLabel.textColor = UIColor.white
        self.temperatureNumberLabel.textColor = UIColor.white
        self.temperatureConditionLabel.textColor = UIColor.white
        self.shareTextview.textColor = UIColor.white
        self.shareTextview.placeholderColor = UIColor.gray
    }
    func showShareView() {
        if (pressShare.state == UIGestureRecognizerState.began) {
            print("begin press")
            
            // text to share
            let text: String!
            if shareTextview.text.lengthOfBytes(using: .utf8) > 0 {
                text = shareTextview.text
            } else {
                text = "This is a simple weather app but can allow you write something to share with others."
            }
            
            let appURL = URL(string: "http://www.longjianjiang.com/projects/")
            
            
            // set up activity view controller
            let textToShare = [text,appURL!] as [Any]
            // add the screenshot activity
            let screenshotActivity = ScreenshotShareActivity()
            screenshotActivity.completionHandler = {() in
                let screenshotImage = self.screenshot()
                
                let activityItem: [AnyObject] = [screenshotImage as AnyObject]
                let activityViewController = UIActivityViewController(activityItems: activityItem as [AnyObject], applicationActivities: nil)
                self.present(activityViewController, animated: true, completion: nil)
            }
            
            
            let activityViewController = UIActivityViewController(activityItems: textToShare, applicationActivities: [screenshotActivity])
            activityViewController.popoverPresentationController?.sourceView = self.view // so that iPads won't crash
            
            // present the view controller
            self.present(activityViewController, animated: true, completion: nil)
            
        }else if (pressShare.state == UIGestureRecognizerState.ended){
            print("end press")
        }
    }
    
    
    func screenshot() -> UIImage {
        let imageSize = UIScreen.main.bounds.size as CGSize;
        UIGraphicsBeginImageContextWithOptions(imageSize, false, 0)
        let context = UIGraphicsGetCurrentContext()
        for obj : AnyObject in UIApplication.shared.windows {
            if let window = obj as? UIWindow {
                if window.responds(to: #selector(getter: UIWindow.screen)) || window.screen == UIScreen.main {
                    // so we must first apply the layer's geometry to the graphics context
                    context!.saveGState();
                    // Center the context around the window's anchor point
                    context!.translateBy(x: window.center.x, y: window.center
                        .y);
                    // Apply the window's transform about the anchor point
                    context!.concatenate(window.transform);
                    // Offset by the portion of the bounds left of and above the anchor point
                    context!.translateBy(x: -window.bounds.size.width * window.layer.anchorPoint.x,
                                         y: -window.bounds.size.height * window.layer.anchorPoint.y);
                    
                    // Render the layer hierarchy to the current context
                    window.layer.render(in: context!)
                    
                    // Restore the context
                    context!.restoreGState();
                }
            }
        }
        let image = UIGraphicsGetImageFromCurrentImageContext();
        return image!
    }
    
    func recognizePanDirection(translation: CGPoint) {
        let absX = fabs(translation.x);
        let absY = fabs(translation.y);
        
        if (absX > absY ) {
            
            if (translation.x<0) {
                print("left")
                //向左滑动
            }else{
                print("right")
                //向右滑动
            }
            
        } else if (absY > absX) {
            if (translation.y<0) {
                print("up")
                //向上滑动
            }else{  
                print("dwon")
                //向下滑动  
                UIView.animate(withDuration: 6, animations: {
                    self.threeDaysForecastView.snp.updateConstraints({ (maker) in
                        maker.bottom.equalTo(self.view.snp.top).offset(150)
                    })
                    self.temperatureNumberLabel.isHidden = true
                    self.temperatureConditionLabel.isHidden = true
                })

            }  
        }
    }
    
    func showThreeDaysCondition(gesture: UIPanGestureRecognizer) {
        if gesture.state == .began {
            recognizePanDirection(translation: gesture.translation(in: self.view))
        }
        if gesture.state == .ended {
            UIView.animate(withDuration: 15, animations: {
                self.threeDaysForecastView.snp.updateConstraints({ (maker) in
                    maker.bottom.equalTo(self.view.snp.top)
                })
                self.temperatureNumberLabel.isHidden = false
                self.temperatureConditionLabel.isHidden = false
            })
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
        
        print("use location")
        manager.stopUpdatingLocation()
        guard let CurrentLocation = locations.last else {
            return
        }
        let currentLocation = locations.last
        var currentConditionURL: URL? = nil
        var threedaysForecastURL: URL? = nil
        if let latitudeStr = currentLocation?.coordinate.latitude, let longitudeStr = currentLocation?.coordinate.longitude {
            currentConditionURL = self.router.getCurrentTemperatureURL(latitude: "\(latitudeStr)", longitude: "\(longitudeStr)")
            threedaysForecastURL = self.router.getThreeDayForecastURL(latitude: "\(latitudeStr)", longitude: "\(longitudeStr)")
        }
        self.fetcher.getCurrentTemperature(url: currentConditionURL!) { (result) in
            switch result {
            case let .success(_current):
                DispatchQueue.main.async {
                    self.temperatureConditionLabel.text = _current.weather
                    let unitStr = UserDefaults.standard.object(forKey: "unit") as! String
                    if unitStr == "celsius" {
                        self.temperatureNumberLabel.text = _current.feelslike_c! + "°"
                    } else {
                        self.temperatureNumberLabel.text = _current.feelslike_f! + "°"
                    }
                }

            case let .failure(_error):
                let alertVC = UIAlertController(title: "API Server don't let Drizzling get the data 😂", message: nil, preferredStyle: .alert)
                let okAction = UIAlertAction(title: "Got it", style: .default, handler: nil)
                alertVC.addAction(okAction)
                self.present(alertVC, animated: true, completion: nil)
                print(_error.forecastErrorDescription ?? "error")
            }
        }
        
        
        self.fetcher.getThreeDayForecast(url: threedaysForecastURL!) { (result) in
            switch result {
            case let .success(_days):
                self.forecastDayArr = _days
                self.threeDaysForecastView.forecastDays = self.forecastDayArr

                // send local nitification to users everyday!
                if #available(iOS 10.0, *) {
                    let center = UNUserNotificationCenter.current()
                    let content = UNMutableNotificationContent()
                    content.title = "Tomorrow Weather"
                    content.body = self.getTheTomorrowForecast()
                    content.sound = UNNotificationSound.default()
                    content.badge = 1
                    var dateComponents = DateComponents()
                    dateComponents.hour = 21
                    dateComponents.minute = 11
                    let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: true)
                    let identifier = "com.longjianjiang.notification"
                    let request = UNNotificationRequest(identifier: identifier,
                                                        content: content,
                                                        trigger: trigger)
                    center.add(request, withCompletionHandler: { (error) in
                        if let error = error {
                            // Something went wrong
                        }
                    })

                }
                
            case let .failure(_error):
                print(_error.forecastErrorDescription ?? "error")
            }
        }
        geocoder.reverseGeocodeLocation(CurrentLocation) { (places: [CLPlacemark]?, error: Error?) in
            if error == nil { // normal condition
                
                guard let pl = places?.first else {return}
                self.currentCountry = pl.country // China
                self.currentCity = pl.locality   // Nanjing
                self.currentProvince = pl.administrativeArea // Jiangsu
                self.cityLabel.text = self.currentCity
                
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
