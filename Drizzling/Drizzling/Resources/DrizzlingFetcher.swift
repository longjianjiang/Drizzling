//
//  DrizzlingFetcher.swift
//  Drizzling
//
//  Created by longjianjiang on 17/2/24.
//  Copyright © 2017年 Jiang. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON
import ObjectMapper

enum ForecastResult {
    case success([ForecastDay])
    case failure(ForecastError)
}


enum CurrentConditionResult {
    case success(CurrentCondition)
    case failure(ForecastError)
}

struct DrizzlingFetcher {
    
    //MARK: - get the three days forecast info
    mutating func getThreeDayForecast(url: URL, completion: @escaping (ForecastResult) -> Void) {
        Alamofire.request(url).responseJSON { (responseData) in
            if let JSONObject = responseData.result.value {
                // error handling
                let forecastError = ForecastError(JSONString: JSON(JSONObject)["response"]["error"].rawString()!)
                if let error = forecastError {
                    completion(ForecastResult.failure(error))
                }
                
                // get the data
                var forecastDayArr: [ForecastDay] = []
                let forecastDays = JSON(JSONObject)["forecast"]["simpleforecast"]["forecastday"].array
                if let forecastDayArray = forecastDays {
                    for obj in forecastDayArray {
                        forecastDayArr.append(ForecastDay(JSONString: obj.rawString()!)!)
                    }
                }
                
                if forecastDayArr.count > 0 {
                    completion(ForecastResult.success(forecastDayArr))
                }
                
            }
        }
    }
    
    //MARK: - get the current temperature condition
    mutating func getCurrentTemperature(url: URL, completion: @escaping (CurrentConditionResult) -> Void) {
        Alamofire.request(url).responseJSON { (responseData) in
            if let JSONObject = responseData.result.value {
                // error handling
                let error = ForecastError(JSONString: JSON(JSONObject)["response"]["error"].rawString()!)
                if let error = error {
                    completion(CurrentConditionResult.failure(error))
                }
                
                // get the data
                let current = CurrentCondition(JSONString:  JSON(JSONObject)["current_observation"].rawString()!)
                completion(CurrentConditionResult.success(current!))
            }
        }
    }
    
}
