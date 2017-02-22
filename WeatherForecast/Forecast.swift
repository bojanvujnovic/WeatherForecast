//
//  Forecast.swift
//  WeatherForecast
//
//  Created by Mac on 2/22/17.
//  Copyright © 2017 Boki. All rights reserved.
//

import UIKit
import Alamofire

class Forecast {
    var _date: String!
    var _weatherType: String!
    var _highTemp: String!
    var _lowTemp: String!
   
    
    var date: String {
        if _date == nil {
            _date = ""
        }
        return _date
    }
    var weatherType: String {
        if _weatherType == nil {
            _weatherType = ""
        }
        return _weatherType
    }
    var highTemp: String {
        if _highTemp == nil {
            _highTemp = ""
        }
        return _highTemp
    }
    var lowTemp: String {
        if _lowTemp == nil {
            _lowTemp = ""
        }
        return _lowTemp
    }
    init() {
        
    }
    
    init(weatherDict: [String: AnyObject]) {
        if let temp = weatherDict[JSONForecast.temp] as? Dictionary<String, AnyObject> {
            if let min = temp[JSONForecast.min] as? Double {
                let minCelsius = min.convertKelvinToCelsius(kelvin: min)                
                self._lowTemp = "\(minCelsius.roundTo(places: 1))"
                print(self._lowTemp)
            }
        }
    }
    
        
}

