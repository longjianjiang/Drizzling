//
//  ForecastDay.swift
//  Drizzling
//
//  Created by longjianjiang on 17/2/23.
//  Copyright © 2017年 Jiang. All rights reserved.
//

import UIKit
import ObjectMapper
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
    var forecastHighTemperature: [String : AnyObject]?
    var forecastLowTemperature: [String : AnyObject]?
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
