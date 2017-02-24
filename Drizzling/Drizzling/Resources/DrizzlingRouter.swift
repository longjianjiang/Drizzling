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
    
    init() {
        urlComponents.scheme = "https"
        urlComponents.host = "api.wunderground.com"
    }
    
    
    mutating func getThreeDayForecastURLWithComponents(APIKey: String, CountryOrProvinceName: String, cityName: String) -> URL {
        urlComponents.path = "/api/\(APIKey)/forecast/q/\(CountryOrProvinceName)/\(cityName).json"
        
        return urlComponents.url!
    }
}
