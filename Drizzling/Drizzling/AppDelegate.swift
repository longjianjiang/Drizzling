//
//  AppDelegate.swift
//  Drizzling
//
//  Created by longjianjiang on 2017/2/7.
//  Copyright © 2017年 Jiang. All rights reserved.
//

import UIKit
import MapKit
import UserNotifications


@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    let reachability = Reachability()!
    
    

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
//        self.isChangeTheme() // at there notification method won't be invoked
        
        let defaults = UserDefaults.standard
        let unit = defaults.object(forKey: LJConstants.UserDefaultsKey.unit)
        let askLocation = defaults.object(forKey: LJConstants.UserDefaultsKey.askLocation)
        let askNotification = defaults.object(forKey: LJConstants.UserDefaultsKey.askNotification)
        
        
        if unit != nil {
            if askLocation != nil {
                if askNotification != nil {
                    window?.rootViewController = ViewController()
                } else {
                    window?.rootViewController = LJAskNotificationViewController()
                }
            } else {
                window?.rootViewController = LJAskUseLocationViewController()
            }
        } else {
            window?.rootViewController = LJChooseTemperatureUnitViewController()
        }
    
        // monitor the network condition
        networkMonitor()
        
        UIApplication.shared.applicationIconBadgeNumber = 0
        
        return true
    }

    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        LJLocationManager.shared.askLocation()
        
        UIApplication.shared.applicationIconBadgeNumber = 0
        
        self.isChangeTheme()
        
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }

    deinit {
        reachability.stopNotifier()
    }
    
    //MARK: Public method
    func networkMonitor() {
        do {
            try reachability.startNotifier()
        } catch {
            print("Unable to start notifier")
        }
        
        reachability.whenReachable = { reachability in
            
            DispatchQueue.main.async {
                if reachability.isReachableViaWiFi {
                    print("Reachable via WiFi")
                } else {
                    print("Reachable via Cellular")
                }
                
               
            }
        }
        reachability.whenUnreachable = { reachability in
            print("Not reachable")
            
        }
    }
    
    public static func askNotification() {
        let center = UNUserNotificationCenter.current()
        center.delegate = AppDelegate()
        let options: UNAuthorizationOptions = [.alert, .sound, .badge]
        center.requestAuthorization(options: options) {
            (granted, error) in
            if !granted {
                print("Something went wrong")
            }
        }
    }
    
    //MARK: date method
    func isChangeTheme() {
        // when at night, send a notification to change the app theme
        if self.isBetweenFromHour(5, toHour: 19) {
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "ChangeToNightNotification"), object: nil)
        } else {
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "ChangeToDayNotification"), object: nil)
        }

    }
    func getCustomDateWithHour(_ hour: NSInteger) -> Date {
        let currentDate = Date()
        let currentCalendar = Calendar.current
        
        let currentComponent = currentCalendar.dateComponents([.year, .month, .day, .hour, .minute, .second], from: currentDate)
        
        var resultComponent = DateComponents()
        resultComponent.setValue(currentComponent.year, for: .year)
        resultComponent.setValue(currentComponent.month, for: .month)
        resultComponent.setValue(currentComponent.day, for: .day)
        resultComponent.setValue(hour, for: .hour)
        
        return currentCalendar.date(from: resultComponent)!
    }
    func isBetweenFromHour(_ fromHour: NSInteger, toHour: NSInteger) -> Bool {
        let date1 = self.getCustomDateWithHour(fromHour)
        let date2 = self.getCustomDateWithHour(toHour)
        let currentDate = Date()
        
        if !(currentDate.compare(date1) == ComparisonResult.orderedDescending && currentDate.compare(date2) == ComparisonResult.orderedAscending){
            return true
        } else {
            return false
        }
    }
}

extension AppDelegate : UNUserNotificationCenterDelegate {
    @available(iOS 10.0, *)
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        completionHandler([.alert, .sound, .badge])
    }
    
    @available(iOS 10.0, *)
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        completionHandler()
    }
}
