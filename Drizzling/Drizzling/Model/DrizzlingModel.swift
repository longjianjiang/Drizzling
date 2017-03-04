//
//  DrizzlingModel.swift
//  Drizzling
//
//  Created by longjianjiang on 17/2/24.
//  Copyright © 2017年 Jiang. All rights reserved.
//

import Foundation
import ObjectMapper
import UIKit
/**
 {
 "date": {
 "epoch": "1487761200",
 "pretty": "7:00 PM CST on February 22, 2017",
 "day": 22,
 "month": 2,
 "year": 2017,
 "yday": 52,
 "hour": 19,
 "min": "00",
 "sec": 0,
 "isdst": "0",
 "monthname": "February",
 "monthname_short": "Feb",
 "weekday_short": "Wed",
 "weekday": "Wednesday",
 "ampm": "PM",
 "tz_short": "CST",
 "tz_long": "Asia/Shanghai"
 },
 "period": 1,
 "high": {
 "fahrenheit": "42",
 "celsius": "5"
 },
 "low": {
 "fahrenheit": "32",
 "celsius": "0"
 },
 "conditions": "Fog",
 "icon": "fog",
 "icon_url": "http://icons.wxug.com/i/c/k/fog.gif",
 },
 */

class ForecastDay: Mappable {
    var forecastCondition: String?
    var forecastDate: [String : AnyObject]?
    var forecastHighTemperature: [String : String]?
    var forecastLowTemperature: [String : String]?
    var forecastIcon: String?
    
    func mapping(map: Map) {
        forecastCondition         <- map["conditions"]
        forecastDate              <- map["date"]
        forecastHighTemperature   <- map["high"]
        forecastLowTemperature    <- map["low"]
        forecastIcon              <- map["icon"]
    }
    
    required init?(map: Map) {
        
    }
}

/**
 // this is the response data, when the data is correct, then no error key.
 {
 "version": "0.1",
 "termsofService": "http://www.wunderground.com/weather/api/d/terms.html",
 "features": {},
 "error": {
 "type": "keynotfound",
 "description": "this key does not exist"
 }
 }
 */

class ForecastResponse: Mappable {
    var forecastVersion: String?
    var forecastTermsOfService: String?
    var forecastError: [String : String]?
    
    
    
    func mapping(map: Map) {
        forecastVersion         <- map["vresion"]
        forecastTermsOfService  <- map["termsofService"]
        forecastError           <- map["error"]
    }
    
    required init?(map: Map) {
        
    }
}


class ForecastError: Mappable {
    var forecastErrorType: String?
    var forecastErrorDescription: String?
    
    
    func mapping(map: Map) {
        forecastErrorType        <- map["type"]
        forecastErrorDescription <- map["description"]
    }
    
    
    required init?(map: Map) {
        
    }
}


public struct Gradient {
    let startColor: UIColor
    let endColor: UIColor
}
struct ScreenSize
{
    static let SCREEN_WIDTH = UIScreen.main.bounds.size.width
    static let SCREEN_HEIGHT = UIScreen.main.bounds.size.height
    static let SCREEN_MAX_LENGTH = max(ScreenSize.SCREEN_WIDTH, ScreenSize.SCREEN_HEIGHT)
    static let SCREEN_MIN_LENGTH = min(ScreenSize.SCREEN_WIDTH, ScreenSize.SCREEN_HEIGHT)
}
struct DeviceType
{
    static let IS_IPHONE_4_OR_LESS =  UIDevice.current.userInterfaceIdiom == .phone && ScreenSize.SCREEN_MAX_LENGTH < 568.0
    static let IS_IPHONE_5 = UIDevice.current.userInterfaceIdiom == .phone && ScreenSize.SCREEN_MAX_LENGTH == 568.0
    static let IS_IPHONE_6 = UIDevice.current.userInterfaceIdiom == .phone && ScreenSize.SCREEN_MAX_LENGTH == 667.0
    static let IS_IPHONE_6P = UIDevice.current.userInterfaceIdiom == .phone && ScreenSize.SCREEN_MAX_LENGTH == 736.0
}
