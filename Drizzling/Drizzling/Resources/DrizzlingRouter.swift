//
//  DrizzlingRouter.swift
//  Drizzling
//
//  Created by longjianjiang on 17/2/24.
//  Copyright © 2017年 Jiang. All rights reserved.
//

import Foundation

struct DrizzlingRouter {
    // MARK: - URL Components
    
    var urlComponents = URLComponents()
    let APIKey = "ee5b941953591d6b" //"38e25298c490dffc" // "ee5b941953591d6b"
    
    init() {
        urlComponents.scheme = "https"
        urlComponents.host = "api.wunderground.com"
    }
    
    
    mutating func getThreeDayForecastURLWithComponents(CountryOrProvinceName: String, cityName: String) -> URL {
        urlComponents.path = "/api/\(APIKey)/forecast/q/\(CountryOrProvinceName)/\(cityName).json"
        
        return urlComponents.url!
    }
    
    // use latitude and longitude to get current temperature url
    mutating func getCurrentTemperatureURL(latitude: String, longitude: String) -> URL {
        urlComponents.path = "/api/\(APIKey)/conditions/q/\(latitude),\(longitude).json"
        
        return urlComponents.url!
    }
    
    // use latitude and longitude to get three day's forecast url
    mutating func getThreeDayForecastURL(latitude: String, longitude: String) -> URL {
        urlComponents.path = "/api/\(APIKey)/forecast/q/\(latitude),\(longitude).json"
        
        return urlComponents.url!
    }
}


