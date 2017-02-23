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
    private var _date: String!
    private var _weatherType: String!
    private var _highTemp: String!
    private var _lowTemp: String!
   
    
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
        
    init(weatherDict: [String: AnyObject]) {
        //Temperature values
        if let temp = weatherDict[JSONForecast.temp] as? Dictionary<String, AnyObject> {
            if let min = temp[JSONForecast.min] as? Double, let max = temp[JSONForecast.max] as? Double {
                let minCelsius = min.convertKelvinToCelsius(kelvin: min)                
                self._lowTemp = "\(minCelsius.roundTo(places: 1))"
                let maxCelsius = max.convertKelvinToCelsius(kelvin: max)
                self._highTemp = "\(maxCelsius.roundTo(places: 1))"
            }
        }
        //Weather type value
        if let weather = weatherDict[JSONForecast.weather] as? [Dictionary<String, AnyObject>] {
            if let weatherType = weather[0][JSONForecast.main] as? String {
                self._weatherType = weatherType
            }
        }
        //Day value
        if let date = weatherDict[JSONForecast.date] as? Double {
            let unixConvertedDate = Date(timeIntervalSince1970: date)
            let dateFormatter = DateFormatter()
            dateFormatter.dateStyle = .full
            dateFormatter.dateFormat = "EEEE"
            dateFormatter.timeStyle = .none
            self._date = unixConvertedDate.dayOfTheWeek()            
        }
    }
        
}

extension Date {
    
    func dayOfTheWeek() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "EEEE"
        return dateFormatter.string(from:  self)
    }
}

